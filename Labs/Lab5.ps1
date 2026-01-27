# Lab 5: Querying information by using WMI and CIM

# ---> LON-CL1

# Exercise 1: Querying information by using WMI
# ---------------------------------------------
# Task 1: Query IP addresses
Get-WmiObject -Namespace root\cimv2 -List | Where Name -like '*configuration*' | Sort Name
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where DHCPEnabled -eq $False | Select IPAddress

# Task 2: Query operating system version information
Get-WmiObject -Namespace root\cimv2 -List | Where Name -like '*operating*' | Sort Name
Get-WmiObject -Class Win32_OperatingSystem | Get-Member
Get-WmiObject -Class Win32_OperatingSystem | Select Version,ServicePackMajorVersion,BuildNumber

# Task 3: Query computer system hardware information
Get-WmiObject -Namespace root\cimv2 -List | Where Name -like '*system*' | Sort Name
Get-WmiObject -Class Win32_ComputerSystem | Format-List -Property *
Get-WmiObject -Class Win32_ComputerSystem | Select Manufacturer,Model,@{n='RAM';e={$PSItem.TotalPhysicalMemory}}

# Task 4: Query service information
Get-WmiObject -Namespace root\cimv2 -List | Where Name -like '*service*' | Sort Name
Get-WmiObject -Class Win32_Service | FL *
Get-WmiObject -Class Win32_Service -Filter "Name LIKE 'S%'" | Select Name,State,StartName


# Exercise 2: Querying information by using CIM
# ---------------------------------------------
# Task 1: Query user accounts
Get-CimClass -ClassName *user*
Get-CimInstance -Class Win32_UserAccount | Get-Member
Get-CimInstance -Class Win32_UserAccount | Format-Table -Property Caption,Domain,SID,FullName,Name

# Task 2: Query BIOS information
Get-CimClass -ClassName *bios*
Get-CimInstance -Class Win32_BIOS
Get-CimInstance -Classname Win32_NetworkAdapterConfiguration
Get-CimInstance -Classname Win32_NetworkAdapterConfiguration -ComputerName LON-DC1

# Task 3: Query network adapter configuration information
Get-CimInstance -Classname Win32_NetworkAdapterConfiguration
Get-CimInstance -Classname Win32_NetworkAdapterConfiguration -ComputerName LON-DC1

# Task 4: Query user group information
Get-CimClass -ClassName *group*
Get-CimInstance -ClassName Win32_Group -ComputerName LON-DC1


# Exercise 3: Invoking methods
# ----------------------------
# Task 1: Invoke a CIM method
Invoke-CimMethod -ClassName Win32_OperatingSystem -ComputerName LON-DC1 -MethodName Reboot

# Task 2: Invoke a WMI method
Get-Service WinRM | FL *
Get-WmiObject -Class Win32_Service -Filter "Name='WinRM'" | Invoke-WmiMethod -Name ChangeStartMode -Argument 'Automatic'
Get-Service WinRM | FL *
