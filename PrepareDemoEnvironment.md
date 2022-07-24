# Prepare Demo Environment (Azure)

## Create Mirosoft account

Go to [outlook.com](https://outlook.com) and create free account. Note email address and password!

<img src="img/Create-Microsoft-Account.png" alt="Create Microsoft Account" width="400"/>



## Redeem your Azure Pass code

Go to [microsoftazurepass.com](https://www.microsoftazurepass.com). Sign in with your new Microsoft account!

<img src="img/Redeem-Azure-Pass.png" alt="Redeem Azure Pass" width="400"/>



## Activate Cloud Shell

Select PowerShell.

<img src="img/Activate-Cloud-Shell-1.png" alt="Activate Cloud Shell 1" width="400"/>

<img src="img/Activate-Cloud-Shell-2.png" alt="Activate Cloud Shell 2" width="400"/>



## Clone github repo

```
git clone https://github.com/www42/AZ-040-Student.git
```

<img src="img/Clone-Repo.png" alt="Clone Repo" width="400"/>



## Deploy ARM template

``` 
cd AZ-040-Student
./Deploy-Template.ps1
```

<img src="img/Deploy-ARM-Template.png" alt="Deploy ARM Template" width="400"/>



## Connect to virtual machine

Select Bastion. Login with username localadmin. Start PowerShell ISE.

<img src="img/Connect-to-VM-1.png" alt="Connect to VM 1" width="400"/>

<img src="img/Connect-to-VM-2.png" alt="Connect to VM 2" width="400"/>

<img src="img/Connect-to-VM-3.png" alt="Connect to VM 3" width="400"/>



## Optional - Mount file share

Go to storage account named storage040...

<img src="img/Mount-File-Share-1.png" alt="Mount File Share 1" width="400"/>

Locate the file share named powershell

<img src="img/Mount-File-Share-2.png" alt="Mount File Share 2" width="400"/>

Click Connect. Copy the PowerShell script (grey box) to clipboard.

<img src="img/Mount-File-Share-3.png" alt="Mount File Share 3" width="400"/>

Paste the script into PowerShell ISE and Run Script (F5)

<img src="img/Mount-File-Share-4.png" alt="Mount File Share 4" width="400"/>