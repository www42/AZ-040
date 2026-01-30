# Lab 10: Managing Microsoft 365 with PowerShell

# --->LON-CL1

# Exercise 1: Managing users and groups in Azure AD
# -------------------------------------------------
# Task 1: Connect to Azure AD
Install-Module AzureAD
Connect-AzureAD
Get-AzureADUser

# Task 2: Create a new administrative user
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "<password>"
$verifiedDomain = (Get-AzureADTenantDetail).VerifiedDomains[0].Name
New-AzureADUser -DisplayName "Noreen Riggs" -UserPrincipalName Noreen@$verifiedDomain -AccountEnabled $true -PasswordProfile $PasswordProfile -MailNickName Noreen
$user = Get-AzureADUser -ObjectID Noreen@$verifiedDomain
$role = Get-AzureADDirectoryRole | Where {$_.displayName -eq 'Global Administrator'}
Add-AzureADDirectoryRoleMember -ObjectId $role.ObjectId -RefObjectId $user.ObjectID
Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId

# Task 3: Create and license a new user
New-AzureADUser -DisplayName "Allan Yoo" -UserPrincipalName Allan@$verifiedDomain -AccountEnabled $true -PasswordProfile $PasswordProfile -MailNickName Allan
Set-AzureADUser -ObjectId Allan@$verifiedDomain -UsageLocation US
Get-AzureADSubscribedSku | FL
$SkuId = (Get-AzureADSubscribedSku | Where SkuPartNumber -eq "ENTERPRISEPREMIUM").SkuID
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$License.SkuId = $SkuId
$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$LicensesToAssign.AddLicenses = $License
Set-AzureADUserLicense -ObjectId Allan@$verifiedDomain -AssignedLicenses $LicensesToAssign

# Task 4: Create and populate a group
Get-AzureADGroup
New-AzureADGroup -DisplayName "Sales Security Group" -SecurityEnabled $true -MailEnabled $false -MailNickName "SalesSecurityGroup"
$group = Get-AzureAdGroup -SearchString "Sales Security"
$user = Get-AzureADUser -ObjectId Allan@$verifiedDomain
Add-AzureADGroupMember -ObjectId $group.ObjectId -RefObjectId $user.ObjectId
Get-AzureADGroupMember -ObjectId $group.ObjectId



# Exercise 2: Managing Exchange Online
# ------------------------------------
# Task 1: Connect to Exchange Online
Install-Module ExchangeOnlineManagement
Connect-ExchangeOnline
Get-EXOMailbox

# Task 2: Create a room mailbox
New-Mailbox -Room -Name BoardRoom
Set-CalendarProcessing BoardRoom -AutomateProcessing AutoAccept

# Task 3: Verify room resource booking
Start-Process https://outlook.office.com
#   Sign in as Allan Woo and change your password as instructed.
#   When prompted to stay signed in, select No.
#   From the menu bar, select Calendar, and then select New event.
#   In the Add a title box, Enter Staff Meeting.
#   In the Invite attendees box, Enter BoardRoom, select BoardRoom, select the first available time, and then select Send.
#   From the menu, select Mail.
#   Verify that Allan has received a response from BoardRoom that the meeting request was accepted.



# Exercise 3: Managing SharePoint Online
# --------------------------------------
# Task 1: Connect to SharePoint Online
Install-Module -Name Microsoft.Online.SharePoint.PowerShell
$verifiedDomainShort = $verifiedDomain.Split(".")[0]
Connect-SPOService -Url "https://$verifiedDomainShort-admin.sharepoint.com"
# Sign in as Noreen Riggs and change your password as instructed.
Get-SPOSite

# Task 2: Create a new site
Get-SPOWebTemplate
New-SPOSite -Url https://$verifiedDomainShort.sharepoint.com/sites/Sales -Owner noreen@$verifiedDomain -StorageQuota 256 -Template EHS#1 -NoWait
Get-SPOSite | FL Url,Status
Disconnect-SPOService



# Exercise 4: Managing Microsoft Teams
# ------------------------------------
# Task 1: Connect to Microsoft Teams
Install-Module MicrosoftTeams
Connect-MicrosoftTeams
# Sign in as your admin user. Notice that you can't use Noreen for this activity, because you need a Microsoft Teams license to create teams.
Get-Team
#  there are no existing teams

# Task 2: Create a new team
New-Team -DisplayName "Sales Team" -MailNickName "SalesTeam"
$team = Get-Team -DisplayName "Sales Team"
$team | FL
Add-TeamUser -GroupId $team.GroupId -User Allan@$verifiedDomain -Role Member
Get-TeamUser -GroupId $team.GroupId

## Task 3: Verify access to the team
Start-Process https://teams.microsoft.com
# Sign in as Allan Yoo
# Close the Bring your team together window, and then verify that Sales Team is listed.
# Select New conversation, Enter "Prices are increasing 10% at month end", and then select Enter.
