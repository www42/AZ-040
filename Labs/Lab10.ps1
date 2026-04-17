# Lab 10: Managing Microsoft 365 with PowerShell

# --->LON-CL1

# Exercise 1: Managing users and groups in Microsoft Entra ID
# -----------------------------------------------------------
# Task 1: Connect to Microsoft Entra ID

# Wichtig! Windows PowerShell console (nicht ISE!) [ISE kann nicht WAM]

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module Microsoft.Graph -Scope CurrentUser  # Say yes to NuGet package provider
Get-InstalledModule Microsoft.Graph

Connect-MgGraph -Scopes "User.ReadWrite.All", "Application.ReadWrite.All", "Sites.ReadWrite.All", "Directory.ReadWrite.All", "Group.ReadWrite.All", "RoleManagement.ReadWrite.Directory"
# Do *not* consent on behalf of your organisation
# Say 'No, this app only'
# Powershell ISE does not work with WAM. Use -UseDeviceCode

Get-MgUser

# Task 2: Create a new administrative user
$verifiedDomain = (Get-MgOrganization).VerifiedDomains[0].Name
$PasswordProfile = @{  
    "Password"="<password>";  
    "ForceChangePasswordNextSignIn"=$true  
}
New-MgUser -DisplayName "Noreen Riggs" -UserPrincipalName "Noreen@$verifiedDomain" -AccountEnabled -PasswordProfile $PasswordProfile -MailNickName "Noreen"
$user = Get-MgUser -UserId "Noreen@$verifiedDomain"
$role = Get-MgDirectoryRole | Where {$_.displayName -eq 'Global Administrator'}

$OdataId = "https://graph.microsoft.com/v1.0/directoryObjects/" + $user.id  
New-MgDirectoryRoleMemberByRef -DirectoryRoleId $role.id -OdataId $OdataId    
Get-MgDirectoryRoleMember -DirectoryRoleId $role.id
#  UPN z. B.  Noreen@LODSA341487.onmicrosoft.com

# Task 3: Create and license a new user
New-MgUser -DisplayName "Allan Yoo" -UserPrincipalName Allan@$verifiedDomain -AccountEnabled -PasswordProfile $PasswordProfile -MailNickName "Allan"
Update-MgUser -UserId Allan@$verifiedDomain -UsageLocation US
Get-MgSubscribedSku | FL
Get-MgSubscribedSku | FT SkuPartNumber,ConsumedUnits
$SkuId = (Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -eq "Office_365_E5_(no_Teams)" }).SkuId
Set-MgUserLicense -UserId Allan@$verifiedDomain -AddLicenses @{SkuId = $SkuId} -RemoveLicenses @()


# Task 4: Create and populate a group
Get-MgGroup
New-MgGroup -DisplayName "Sales Security Group" -MailEnabled:$False  -MailNickName "SalesSecurityGroup" -SecurityEnabled
$group = Get-MgGroup -ConsistencyLevel eventual -Count groupCount -Search '"DisplayName:Sales Security"'
$user = Get-MgUser -UserId Allan@$verifiedDomain
New-MgGroupMember -GroupId $group.id -DirectoryObjectId $user.id
Get-MgGroupMember -GroupId $group.id
#  UPN z. B.  Allan@LODSA341487.onmicrosoft.com



# Exercise 2: Managing Exchange Online
# ------------------------------------
# Task 1: Connect to Exchange Online
Install-Module ExchangeOnlineManagement -force
Connect-ExchangeOnline
Get-EXOMailbox

# Task 2: Create a room mailbox
New-Mailbox -Room -Name BoardRoom
Set-CalendarProcessing BoardRoom -AutomateProcessing AutoAccept

# Task 3: Verify room resource booking
# https://outlook.office.com
# Sign in as Allan Yoo by using the UserPrincipalName as the user name and providing the password you recorded in the previous exercise of this lab.
# From the menu bar, select Calendar, and then select New event.




# Exercise 3: Managing SharePoint Online
# --------------------------------------
# Task 1: Connect to SharePoint Online
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser
$verifiedDomainShort = $verifiedDomain.Split(".")[0]
Connect-SPOService -Url "https://$verifiedDomainShort-admin.sharepoint.com"
Get-SPOSite

# Task 2: Create a new site
Get-SPOWebTemplate
New-SPOSite -Url https://$verifiedDomainShort.sharepoint.com/sites/Sales -Owner noreen@$verifiedDomain -StorageQuota 256 -Template EHS#1 -NoWait
Get-SPOSite | FL Url,Status

Disconnect-SPOService




# Exercise 4: Managing Microsoft Teams
# ------------------------------------
# Task 1: Connect to Microsoft Teams
Install-Module -Name MicrosoftTeams -Force -AllowClobber
Connect-MicrosoftTeams
Get-Team

# Task 2: Create a new team
New-Team -DisplayName "Sales Team" -MailNickName "SalesTeam"
$team = Get-Team -DisplayName "Sales Team"
$team | FL
$verifiedDomain = (Get-MgOrganization).VerifiedDomains[0].Name
Add-TeamUser -GroupId $team.GroupId -User Allan@$verifiedDomain -Role Member
Get-TeamUser -GroupId $team.GroupId


# Task 3: Verify access to the team
