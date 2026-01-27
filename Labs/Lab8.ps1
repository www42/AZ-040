# Lab 8: Performing remote administration with PowerShell

# --->LON-CL1

# Exercise 1: Enabling remoting on the local computer
# ---------------------------------------------------
# Task 1: Enable remoting for incoming connections
Set-ExecutionPolicy RemoteSigned
Enable-PSremoting
help *sessionconfiguration*
Get-PSSessionConfiguration



# Exercise 2: Performing one-to-one remoting
# ------------------------------------------
# Task 1: Connect to the remote computer and install an operating system feature
Enter-PSSession -ComputerName LON-DC1
    Install-WindowsFeature NLB
    Exit-PSSession

# Task 2: Test multi-hop remoting
Enter-PSSession -ComputerName LON-DC1
    Enter-PSSession -ComputerName LON-CL1 # Does not work
    Exit-PSSession

# Task 3: Observe remoting limitations
Enter-PSSession -ComputerName localhost
    Notepad  # No graphical output
             # <Ctrl-C>
    Exit-PSSession



# Exercise 3: Performing one-to-many remoting
# -------------------------------------------
# Task 1: Retrieve a list of physical network adapters from two computers
help *adapter*
help Get-NetAdapter 
Invoke-Command -ComputerName LON-CL1,LON-DC1 -ScriptBlock { Get-NetAdapter -Physical }

# Task 2: Compare the output of a local command to that of a remote command
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { Get-Process } | Get-Member
#   Note: The second set of results only includes two MemberType of Methods; GetType, and ToString. This is because the remote value TypeName is deserialized in comparison to the local output.




# Exercise 4: Using implicit remoting
# -----------------------------------
# Task 1: Create a persistent remoting connection to a server
$dc = New-PSSession -ComputerName LON-DC1
$dc

# Task 2: Import and use a module from a server
Get-Module -ListAvailable -PSSession $dc
Get-Module -ListAvailable -PSSession $dc | Where { $_.Name -Like '*share*' }
Import-Module -PSSession $dc -Name SMBShare -Prefix DC
Get-DCSMBShare
Get-SMBShare

# Task 3: Close all open remoting connections
Get-PSSession | Remove-PSSession
Get-PSSession



# Exercise 5: Managing multiple computers
# ---------------------------------------
# Task 1: Create PSSessions to two computers
$computers = New-PSSession -ComputerName LON-CL1,LON-DC1
$computers

# Task 2: Create a report that displays Windows Firewall rules from two computers
Get-Module *security* -ListAvailable
Invoke-Command -Session $computers -ScriptBlock { Import-Module NetSecurity }
Get-Command -Module NetSecurity
Help Get-NetFirewallRule -ShowWindow
Invoke-Command -Session $computers -ScriptBlock { Get-NetFirewallRule -Enabled True } | Select Name,PSComputerName
Invoke-Command -Session $computers -ScriptBlock { Remove-Module NetSecurity }
Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
Invoke-Command -Session $computers -ScriptBlock { Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" }
Invoke-Command -Session $computers -ScriptBlock { Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" } | ConvertTo-Html -Property PSComputerName,DeviceID,FreeSpace,Size

# Task 4: Close all open PSSessions
Get-PSSession | Remove-PSSession
