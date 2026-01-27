# Lab 1: Configuring Windows PowerShell, and finding and running commands

# ---> LON-CL1

# Exercise 1: Configuring the Windows PowerShell console application
# ------------------------------------------------------------------
# Task 1: Start the console application as Administrator, and pin the Windows PowerShell icon to the taskbar
# Task 2: Configure the Windows PowerShell console application
# Task 3: Start a shell transcript
Start-Transcript C:\DayOne.txt
Stop-Transcript


# Exercise 2: Configuring the Windows PowerShell ISE application
# ---------------------------------------------------------------
# Task 1: Open the Windows PowerShell ISE application as Administrator
# Task 2: Customize the ISE's appearance to use a single-pane view, hide the Command pane, and adjust the font size



# Exercise 3: Finding and running Windows PowerShell commands
# ------------------------------------------------------------
# Task 1: Find commands that'll accomplish specified tasks
Get-Help *resolve* 
Get-Command *resolve* 
Resolve-DnsName

Get-Help *adapter* 
Get-Command *adapter*
Get-NetAdapter

Get-Help *sched* 
Get-Command *sched*
Get-ScheduledTask
 
Get-Command *block*
Get-Help Block-SmbShareAccess
 
Get-Command *branch*
Clear-BranchCache
 
Get-Command *cache*
Get-Command -Verb clear
Clear-DnsClientCache
 
Get-Command *firewall*
Get-NetFirewallRule
Get-Help Get-NetFirewallRule -Full
 
Get-Command *address*
Get-NetIPAddress

Get-Alias Type
Get-Content
 

# Task 2: Run commands to accomplish specified tasks
Get-NetFirewallRule -Enabled True
Get-NetIPAddress -AddressFamily IPv4
Set-Service -Name BITS -StartupType Automatic
Test-NetConnection LON-DC1 -Quiet
Get-EventLog -LogName Security -Newest 10
 
 
# Exercise 4: Using About files
# -----------------------------
# Task 1: Locate and review About help files
Get-Help *comparison*
Get-Help about_comparison_operators -ShowWindow
Get-Help about_environment_variables
$env:COMPUTERNAME
Get-Help *signing*
Get-Help about_signing 
