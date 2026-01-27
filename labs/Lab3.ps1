# Lab 3: Using PowerShell pipeline
# =================================

# Lab 3 Teil 1 (historisch gewachsen)


# Exercise 1: Selecting, sorting, and displaying data using Powershell Binding
# ---------------------------------------------------
# Task 1: Display the current day of the year
help *date* 
#  --> Get-Date

Get-Help Get-Date -Parameter * | Where-Object { $_.PipelineInput -match "true" }
#  --> -Date 

Get-Date | Get-Member
Get-Date | Select-Object -Property DayOfYear
Get-Date | Select-Object -Property DayOfYear | fl


# Task 2: Display information about installed hotfixes
Get-Command *hotfix* 
#  --> Get-Hotfix

Get-Help Get-Hotfix -Parameter * | Where-Object { $_.PipelineInput -match "true" } 
#  --> -Computername

Get-Hotfix | Get-Member 
Get-Hotfix | Select-Object -Property HotFixID,InstalledOn,InstalledBy
Get-Hotfix | Select-Object -Property HotFixID,@{n='HotFixAge';e={(New-TimeSpan -Start $PSItem.InstalledOn).Days}},InstalledBy


# Task 3: Display a list of available scopes from the DHCP server
help *scope* 
# --> Get-DHCPServerv4Scope

Help Get-DHCPServerv4Scope -ShowWindow 
Get-DHCPServerv4Scope -ComputerName LON-DC1
Get-DHCPServerv4Scope -ComputerName LON-DC1 | Select-Object -Property ScopeId,SubnetMask,Name | fl


# Task 4: Display a sorted list of enabled Windows Firewall rules
help *rule* 
#  --> Get-NetFirewallRule

Get-NetFirewallRule 
Help Get-NetFirewallRule -ShowWindow
Get-NetFirewallRule -Enabled True
Get-NetFirewallRule -Enabled True | Format-Table -wrap
Get-NetFirewallRule -Enabled True | Select-Object -Property DisplayName,Profile,Direction,Action | Sort-Object -Property Profile, DisplayName | ft -GroupBy Profile


# Task 5: Display a sorted list of network neighbors
help *neighbor*  
#  --> Get-NetNeighbor

help Get-NetNeighbor -ShowWindow
Get-NetNeighbor
Get-NetNeighbor | Sort-Object -Property State
Get-NetNeighbor | Sort-Object -Property State | Select-Object -Property IPAddress,State | Format-Wide -GroupBy State -AutoSize

# Task 6: Display information from the DNS name resolution cache
Test-NetConnection LON-DC1
help *cache* 
#  -->  Get-DnsClientCache

Get-DnsClientCache
Get-DnsClientCache | Select Name,Type,TimeToLive | Sort Name | Format-List



# Exercise 2: Filtering objects
# -----------------------------
# Task 1: Display a list of all the users in the Users container of Active Directory
help *user*
Get-Help Get-ADUser -ShowWindow
Get-ADUser -Filter * | ft
Get-ADUser -Filter * -SearchBase "cn=Users,dc=Adatum,dc=com" | ft

# Task 2: Create a report displaying the Security event log entries that have the event ID 4624
Get-EventLog -LogName Security | Where EventID -eq 4624 | Measure-Object | fw
Get-EventLog -LogName Security | Where EventID -eq 4624 | Select TimeWritten,EventID,Message
Get-EventLog -LogName Security | Where EventID -eq 4624 | Select TimeWritten,EventID,Message -Last 10 | fl

# Task 3: Display a list of the encryption certificates installed on the computer
Get-ChildItem -Path CERT: -Recurse
Get-ChildItem -Path CERT: -Recurse | Get-Member
Get-ChildItem -Path CERT: -Recurse | Where HasPrivateKey -eq $False | Select-Object -Property FriendlyName,Issuer | fl
Get-ChildItem -Path CERT: -Recurse | Where { $PSItem.HasPrivateKey -eq $False } | Select-Object -Property FriendlyName,Issuer | fl
Get-ChildItem -Path CERT: -Recurse | Where { $PSItem.HasPrivateKey -eq $False -and $PSItem.NotAfter -gt (Get-Date) -and $PSItem.NotBefore -lt (Get-Date) } | Select-Object -Property NotBefore,NotAfter, FriendlyName,Issuer | ft -wrap

# Task 4: Create a report of the disk volumes that are running low on space
Get-Volume
Get-Volume | Get-Member
Get-Volume | Where-Object { $PSItem.SizeRemaining -gt 0 } | fl
Get-Volume | Where-Object { $PSItem.SizeRemaining -gt 0 -and $PSItem.SizeRemaining / $PSItem.Size -lt .99 }| Select-Object DriveLetter, @{n='Size';e={'{0:N2}' -f ($PSItem.Size/1MB)}}
Get-Volume | Where-Object { $PSItem.SizeRemaining -gt 0 -and $PSItem.SizeRemaining / $PSItem.Size -lt .1 }

# Task 5: Create a report that displays specified Control Panel items
help *control* 
Get-ControlPanelItem 
Get-ControlPanelItem -Category 'System and Security' | Sort Name
Get-ControlPanelItem -Category 'System and Security' | Where-Object -FilterScript {-not ($PSItem.Category -notlike '*System and Security*')} | Sort Name



# Lab 3 Teil 2


# Exercise 1: Enumerating objects
# -------------------------------
# Task 1: Display a list of files on drive E of your computer
Get-ChildItem -Path E: -Recurse
Get-ChildItem -Path E: -Recurse | Get-Member 
Get-ChildItem -Path E: -Recurse | ForEach GetFiles

# Task 2: Use enumeration to produce 100 random numbers
help *random* 
help Get-Random -ShowWindow 
1..100 
1..100 | ForEach { Get-Random -SetSeed $PSItem }

# Task 3: Run a method of a Windows Management Instrumentation (WMI) object
Get-WmiObject -Class Win32_OperatingSystem -EnableAllPrivileges
Get-WmiObject -Class Win32_OperatingSystem -EnableAllPrivileges | Get-Member
Get-WmiObject -Class Win32_OperatingSystem -EnableAllPrivileges | ForEach Reboot



# Exercise 2: Converting objects
# ------------------------------
# Task 1: Update Active Directory user information
Get-ADUser -Filter * -Properties Department,City | Where {$PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London'} | Select-Object -Property Name,Department,City| Sort Name
Get-ADUser -Filter * -Properties Department,City | Where {$PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London'} | Set-ADUser -Office 'LON-A/1000'
Get-ADUser -Filter * -Properties Department,City,Office | Where {$PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London'} | Select-Object -Property Name,Department,City,Office | Sort Name

# Task 2: Generate files listing the Active Directory users in the IT department
help ConvertTo-Html -ShowWindow
Get-ADUser -Filter * -Properties Department,City,Office | 
    Where {$PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London'} | 
    Sort Name | 
    Select-Object -Property Name,Department,City,Office |
    ConvertTo-Html -Property Name,Department,City -PreContent Users | 
    Out-File E:\UserReport.html

Invoke-Expression E:\UserReport.html
Get-ADUser -Filter * -Properties Department,City,Office | 
    Where {$PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London'} | 
    Sort Name | 
    Select-Object -Property Name,Department,City,Office |
    Export-Clixml E:\UserReport.xml

Get-ADUser -Filter * -Properties Department,City,Office | 
    Where {$PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London'} | 
    Sort Name | 
    Select-Object -Property Name,Department,City,Office |
    Export-Csv E:\UserReport.csv
