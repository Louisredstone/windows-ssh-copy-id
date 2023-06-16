# windows-ssh-copy-id
ssh-copy-id script on Windows, based on PowerShell

Windows原生的OpenSSH程序包不包含`ssh-copy-id`这一工具，这对我们日常的使用造成了许多不便。

为此，笔者书写了PowerShell版本的`ssh-copy-id`脚本，只要将它放在系统路径（path环境变量）内，便可以在命令行中便捷访问。

拷贝同路径下的`ssh-copy-id.ps1`的文本文件，将它放入系统路径内。
```powershell
Copy-Item ssh-copy-id.ps1 -Destination "C:\Windows\System32"
```
你也可以复制到其他路径，但必须确保路径包含在系统环境变量Path中。

目前这个脚本的`-o`参数还不支持，但完全足够日常使用。

# 参考资料
[怎样使用 awk 删掉文件中重复的行 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/96934479)