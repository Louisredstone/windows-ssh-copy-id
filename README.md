# windows-ssh-copy-id
ssh-copy-id script on Windows, based on PowerShell

Windowsԭ����OpenSSH�����������`ssh-copy-id`��һ���ߣ���������ճ���ʹ���������಻�㡣

Ϊ�ˣ�������д��PowerShell�汾��`ssh-copy-id`�ű���ֻҪ��������ϵͳ·����path�����������ڣ���������������б�ݷ��ʡ�

����ͬ·���µ�`ssh-copy-id.ps1`���ı��ļ�����������ϵͳ·���ڡ�
```powershell
Copy-Item ssh-copy-id.ps1 -Destination "C:\Windows\System32"
```
��Ҳ���Ը��Ƶ�����·����������ȷ��·��������ϵͳ��������Path�С�

Ŀǰ����ű���`-o`��������֧�֣�����ȫ�㹻�ճ�ʹ�á�

# �ο�����
[����ʹ�� awk ɾ���ļ����ظ����� - ֪�� (zhihu.com)](https://zhuanlan.zhihu.com/p/96934479)