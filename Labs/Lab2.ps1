# Lab 2: Performing local system administration with PowerShell

# Exercise 1: Creating and managing Active Directory objects
# ----------------------------------------------------------

# ---> LON-CL1

# Task 1: Create a new organizational unit (OU) for a branch office
New-ADOrganizationalUnit -Name London

# Task 2: Create a group for branch office administrators
New-ADGroup "London Admins" -GroupScope Global

# Task 3: Create a user and computer account for the branch office
New-ADUser -Name Ty -DisplayName "Ty Carlson" 
Add-ADGroupMember "London Admins" -Members Ty
New-ADComputer LON-CL2

# Task 4: Move the group, user, and computer accounts to the branch office OU
Move-ADObject -Identity "CN=London Admins,CN=Users,DC=Adatum,DC=com" -TargetPath "OU=London,DC=Adatum,DC=com"
Move-ADObject -Identity "CN=Ty,CN=Users,DC=Adatum,DC=com" -TargetPath "OU=London,DC=Adatum,DC=com"
Move-ADObject -Identity "CN=LON-CL2,CN=Computers,DC=Adatum,DC=com" -TargetPath "OU=London,DC=Adatum,DC=com"



# Exercise 2: Configuring network settings on Windows Server
# ----------------------------------------------------------

# ---> LON-SVR1

# Task 1: Test the network connection and review the configuration
Test-Connection LON-DC1
Get-NetIPConfiguration

# Task 2: Change the server IP address
New-NetIPAddress -InterfaceAlias Ethernet -IPAddress 172.16.0.15 -PrefixLength 16
Remove-NetIPAddress -InterfaceAlias Ethernet -IPAddress 172.16.0.11

# Task 3: Change the DNS settings and default gateway for the server
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddress 172.16.0.12
Remove-NetRoute -InterfaceAlias Ethernet -DestinationPrefix 0.0.0.0/0 -Confirm:$false
New-NetRoute -InterfaceAlias Ethernet -DestinationPrefix 0.0.0.0/0 -NextHop 172.16.0.2

# Task 4: Verify and test the changes
Get-NetIPConfiguration
Test-Connection LON-DC1



# Exercise 3: Creating a website
# ------------------------------

# ---> LON-SVR1

# Task 1: Install the Web Server (IIS) role on the server
Install-WindowsFeature Web-Server

# Task 2: Create a folder on the server for the website files
New-Item C:\inetpub\wwwroot\London -Type directory

# Task 3: Create the IIS website
New-IISSite London -PhysicalPath C:\inetpub\wwwroot\London -BindingInformation "172.16.0.15:8080:"
# http://172.16.0.15:8080  --> Error