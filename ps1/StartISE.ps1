# Start ISE as Administrator at logon 

$TaskName    = "Start ISE"
$Path        = "\"
$AtLogon     = New-ScheduledTaskTrigger -AtLogOn
$StartISE    = New-ScheduledTaskAction -Execute PowerShell_ISE.exe
$CurrentUser = New-ScheduledTaskPrincipal -RunLevel Highest -LogonType Interactive -UserId $env:USERNAME

Register-ScheduledTask -TaskName  $TaskName `
                       -TaskPath  $Path `
                       -Trigger   $AtLogon `
                       -Principal $CurrentUser `
                       -Action    $StartISE