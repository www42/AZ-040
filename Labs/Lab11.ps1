# Lab 11: Jobs management with PowerShell

# --->LON-CL1

# Exercise 1: Starting and managing jobs
# --------------------------------------
# Task 1: Start a Windows PowerShell remote job
Invoke-Command -ScriptBlock { Get-NetAdapter -Physical } -ComputerName LON-DC1,LON-SVR1 -AsJob -JobName RemoteNetAdapt
Invoke-Command -ScriptBlock { Get-SMBShare } -ComputerName LON-DC1,LON-SVR1 -AsJob -JobName RemoteShares
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Invoke-Command -ScriptBlock { Get-CimInstance -ClassName Win32_Volume } -ComputerName (Get-ADComputer –Filter * | Select -Expand Name) -AsJob -JobName RemoteDisks
# Note: You need to enable PowerShell Remoting on LON-CL1 in order to connect to it by using PowerShell Remoting, which is, by default, disabled on Windows 10. The RemoteDisk targets all domain computers, including LON-CL1.
# Note: Because some of the computers in the domain might not be online, this job might not complete successfully. This is expected behavior.

# Task 2: Start a local job
Start-Job -ScriptBlock { Get-EventLog -LogName Security } -Name LocalSecurity
Start-Job -ScriptBlock { 1..100 | ForEach-Object { Dir C:\ -Recurse } } -Name LocalDir

# Task 3: Review and manage job status
Get-Job
Get-Job -Name Remote*
Stop-Job -Name LocalDir
Receive-Job -Name RemoteNetAdapt
Get-Job -Name RemoteDisks -IncludeChildJob | Receive-Job


# Exercise 2: Creating a scheduled job
# ------------------------------------
# Task 1: Create job options and a job trigger
$option = New-ScheduledJobOption -WakeToRun -RunElevated
$trigger1 = New-JobTrigger -Once -At (Get-Date).AddMinutes(5)

# Task 2: Create a scheduled job and retrieve results
Register-ScheduledJob -ScheduledJobOption $option `
    -Trigger $trigger1 `
    -ScriptBlock { Get-EventLog -LogName Security } `
    -Name LocalSecurityLog
Get-ScheduledJob -Name LocalSecurityLog | Select -Expand JobTriggers 
Get-Job
Receive-Job -Name LocalSecurityLog

# Task 3: Use a Windows PowerShell script as a scheduled task

#   1. Switch to the console session to LON-DC1 and, if needed, sign into LON-DC1 as Adatum\Administrator with the password Pa55w.rd.
#   
#   2. On LON-DC1, in Server Manager, select Tools, and then select Active Directory Users and Computers.
#   
#   3. In the Active Directory Users and Computers console tree, select and expand Adatum.com, and then select Managers.
#   
#   4. In the details pane of Managers, select one of the user accounts, such as Adam Hobbs. Right-click the account or activate its context menu, and then select Disable Account.
#   
#   5. Double-click the user you disabled, or select it and then press the Enter key.
#   
#   6. Select the Member of tab and verify that the user is a member of the Managers security group.
#   
#   7. Select OK and then minimize Active Directory Users and Computers.
#   
#   8. Select Start, enter Task Scheduler, and then select Task Scheduler.
#   
#   9. In Task Scheduler, in the console tree, right-click Task Scheduler (local) or activate its context menu, and then select Create Task.
#   
#   10. In the Create Task window, in the General tab, in the Name and Description boxes, enter Remove Disabled User from Managers Security Group.
#   
#   11. In the Security options section, select Run whether user is logged on or not, and then select the Run with highest privileges checkbox.
#   
#   12. In the Triggers tab, select New.
#   
#   13. In the New Trigger window, in Settings, select Daily, in the Start time box, change the time to 5 minutes from the current time, and then select OK.
#   
#   Note: If you get a Task Scheduler pop-up window, select OK.
#   
#   14. In the Actions tab, select New.
#   
#   15. In the New Action window, in the Program/script box, enter PowerShell.exe.
#   
#   16. In the Add arguments (optional) box, enter -ExecutionPolicy Bypass E:\Labfiles\Mod11\DeleteDisabledUserManagersGroup.ps1, select OK and then, in a pop-up window, select Yes.
#   
#   17. In the Conditions tab, review the items, but make no changes.
#   
#   18. In the Settings tab, in the If the task is already running, then the following rule applies: drop-down list, select Stop the existing instance, and then select OK.
#   
#   19. In the Task Scheduler credentials pop-up window, in the Password box, enter Pa55w.rd, and then select OK.
#   
#   20. In Task Scheduler, select Task Schedule Library and then in the details pane, select Remove Disabled User from Managers Security Group.
#   
#   21. In the details pane, select the History tab. After the five minutes pass, select Refresh in the Actions pane. You should notice an item with the Task Category of Task completed.
#   
#   22. Maximize Active Directory Users and Computers.
#   
#   23. Double-click the user you disabled, or select it and then press the Enter key.
#   
#   24. Select the Member of tab. The user should no longer be a member of the Managers security group.