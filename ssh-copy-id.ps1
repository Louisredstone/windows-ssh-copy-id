$ScriptName = $MyInvocation.MyCommand.Name
function Usage {
    Write-Host "Usage: $ScriptName [-h|-?|-f|-n] [-i [identity_file]] [-p port] [[-o <ssh -o options>] ...] [user@]hostname"
    Write-Host "`t-f: force mode -- copy keys without trying to check if they are already installed"
    Write-Host "`t-n: dry run    -- no keys are actually copied"
    Write-Host "`t-h|-?: print this help"
    exit 1
}

$PARAM_F_SEEN = $false
$FORCE = $false
$PARAM_N_SEEN = $false
$DRY_RUN = $false
$PARAM_I_SEEN = $false
$IDENTITY_FILE = "~/.ssh/id_rsa.pub"
$PARAM_P_SEEN = $false
$PORT = 22
$PARAM_O_SEEN = $false
$USER_AT_HOST = ""

for ($i = 0; $i -lt $args.Count; $i++) {
    $arg = $args[$i]
    switch ($arg) {
        "-h" { Usage }
        "-?" { Usage }
        "-f" {
            if($PARAM_F_SEEN) {
                Write-Error "${ScriptName}: ERROR: -f option must not be specified more than once"
                Usage
                exit 1
            }
            else{
                $PARAM_F_SEEN = $true
                $FORCE = $true
            }
        }
        "-n" { 
            if($PARAM_N_SEEN) {
                Write-Error "${ScriptName}: ERROR: -n option must not be specified more than once"
                Usage
                exit 1
            }
            else{
                $PARAM_N_SEEN = $true
                $DRY_RUN = $true
            }
        }
        "-i" { 
            if($PARAM_I_SEEN) {
                Write-Error "${ScriptName}: ERROR: -i option must not be specified more than once"
                Usage
                exit 1
            }
            else{
                $PARAM_I_SEEN = $true
                $i++
                $arg = $args[$i]
                $IDENTITY_FILE = $arg
            }
        }
        "-p" { 
            if($PARAM_P_SEEN) {
                Write-Error "${ScriptName}: ERROR: -p option must not be specified more than once"
                Usage
                exit 1
            }
            else{
                $PARAM_P_SEEN = $true
                $i++
                $arg = $args[$i]
                $PORT = $arg -as [Int32]
                if ($PORT -lt 0 -or $PORT -ge 65536){
                    Write-Error "${ScriptName}: ERROR: Port should be 0~65535, got $PORT."
                    exit 1
                }
            }
        }
        "-o" { 
            if($PARAM_O_SEEN) {
                Write-Error "${ScriptName}: ERROR: -o option must not be specified more than once"
                Usage
                exit 1
            }
            else{
                $PARAM_O_SEEN = $true
                $i++
                Write-Error "${ScriptName}: ERROR: Parameter -o not implemented yet."
                exit 1
            }
        }
        Default {
            if($USER_AT_HOST -ne ""){
                Write-Error "${ScriptName}: ERROR: user@hostname option must not be specified more than once"
                Usage
                exit 1
            }
            else{
                $USER_AT_HOST = $arg
            }
        }
    }
}

# Parse user@hostname
if ($USER_AT_HOST -eq ""){
    Write-Error "${ScriptName}: ERROR: No hostname specified."
    exit 1
}
$result = $USER_AT_HOST -split "@"
if ($result.Count -eq 1){
    $USER = $env:USERNAME
    $HOSTNAME = $result[0]
}
elseif ($result.Count -eq 2){
    $USER = $result[0]
    $HOSTNAME = $result[1]
}
else{
    Write-Error "${ScriptName}: ERROR: Syntax error while parsing `"$USER_AT_HOST`"."
    exit 1
}

# Find IDENTITY_FILE
if (-not (Test-Path $IDENTITY_FILE)){
    Write-Error "${ScriptName}: ERROR: No identities found."
    exit 1
}

# Add identity to remote
if ($DRY_RUN){
    Write-Host @"
    Would have added the following key(s) to $HOSTNAME with user "$USERNAME" on port ${PORT}:

    $(Get-Content $IDENTITY_FILE)
"@
    exit 0
}

if ($FORCE){
    Get-Content $IDENTITY_FILE | ssh -l $USER -p $PORT $HOSTNAME "cat >> .ssh/authorized_keys"
}
else{
    Get-Content $IDENTITY_FILE | ssh -l $USER -p $PORT $HOSTNAME "cp .ssh/authorized_keys .ssh/authorized_keys.bak; cp .ssh/authorized_keys .ssh/tmp; cat >> .ssh/tmp; awk '!visited[`$0]++' .ssh/tmp > .ssh/authorized_keys; rm .ssh/tmp"
    # basically, just add lines from IDENTITY_FILE to remote:~/.ssh/authorized_keys without duplication.
}

Write-Host @"
Key(s) from "$IDENTITY_FILE" added.
Now you can try logging into the machine, with:
`t"ssh -l $USER -p $PORT $HOSTNAME"
and check to make sure that only the key(s) you wanted were added.
"@
exit 0