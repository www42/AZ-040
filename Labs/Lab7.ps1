# Lab 7: Using scripts with PowerShell

# --->LON-CL1

# Exercise 1: Signing a script
# ----------------------------
# Task 1: Create a code signing certificate
#   mmc.exe
#   Add or Remove Snap-ins -> Certificates -> My user account
#   Certificates - Current User -> Personal
#   All Tasks -> Request New Certificate
#   Next -> Next -> Adatum Code Signing -> Enroll -> Finish
#   Personal -> Certificates 
#   Close mmc

# Task 2: Digitally sign a script
Get-ChildItem Cert:\CurrentUser\My\ -CodeSigningCert
$cert = Get-ChildItem Cert:\CurrentUser\My\ -CodeSigningCert
Set-Location E:\Mod07\Labfiles
Rename-Item HelloWorld.txt HelloWorld.ps1
Set-AuthenticodeSignature -FilePath HelloWorld.ps1 -Certificate $cert

# Task 3: Set the execution policy
Set-ExecutionPolicy AllSigned
.\HelloWorld.ps1
Set-ExecutionPolicy Unrestricted



# Exercise 2: Processing an array with a ForEach loop
# ---------------------------------------------------
New-ADGroup -Name IPPhoneTest -GroupScope Universal -GroupCategory Security
Move-ADObject "CN=IPPhoneTest,CN=Users,DC=Adatum,DC=com" -TargetPath "OU=IT,DC=Adatum,DC=com"
Add-ADGroupMember IPPhoneTest -Members Abbi,Ida,Parsa,Tonia

# Task 2: Create a script to configure the ipPhone attribute
#   E:\Mod07\Labfiles\AZ-040_Mod07_Ex2_LAK.txt
$users = Get-ADGroupMember IPPhoneTest

ForEach ($u in $users) {
    $fullUser = Get-ADUser $u
    $ipPhone = $fullUser.GivenName + "." + $fullUser.Surname + "@adatum.com"
    Set-ADUser $fullUser -replace @{ipPhone="$ipPhone"}
}



# Exercise 3: Processing items by using If statements
# ---------------------------------------------------
# Task 1: Create services.txt with service names
Set-Location E:\Mod07\Labfiles
New-Item services.txt -ItemType File
Get-Service "Print Spooler" | Select -ExpandProperty Name | Out-File services.txt -Append
Get-Service "Windows Time" | Select -ExpandProperty Name | Out-File services.txt -Append

# Task 2: Create a script that starts stopped services
#    E:\Mod07\Labfiles\AZ-040_Mod07_Ex3_LAK.txt
$services = Get-Content services.txt

ForEach ($s in $services) {
    $status = (Get-Service $s).Status
    If ($Status -ne "Running") {
        Start-Service $s
        Write-Host "Started $s"
    } Else {
        Write-Host "$s is already started"
    }
}



# Exercise 4: Creating users based on a CSV file
# ----------------------------------------------
# Task 1: Create AD DS users from a CSV file
#   E:\Mod07\Labfiles\AZ-040_Mod07_Ex4_LAK.txt
$users = Import-Csv -Path users.csv

ForEach ($u in $users) {
    $path = "OU=" + $u.Department + ",DC=Adatum,DC=com"
    $upn = $u.UserID + "@adatum.com"
    $display = $u.First + " " + $u.Last
    Write-Host "Creating $display in $path"
    New-ADUser -GivenName $u.First -Surname $u.Last -Name $display -DisplayName $display -SamAccountName $u.UserID -UserPrincipalName $UPN -Path $path -Department $u.Department
}



# Exercise 5: Querying disk information from remote computers
# -----------------------------------------------------------
# Task 1: Create a script that queries disk information with current credentials
#   E:\Mod07\Labfiles\AZ-040_Mod07_Ex5_LAK.txt
param(
    [string]$ComputerName=(Read-Host "Enter computer name")
    )
    
Get-CimInstance Win32_LogicalDisk -ComputerName $ComputerName -Filter "DriveType=3"



# Exercise 6: Updating the script to use alternate credentials
# ------------------------------------------------------------
# Task 1: Update the script to use alternate credentials
#   E:\Mod07\Labfiles\AZ-040_Mod07_Ex6_LAK.txt
If ($AlternateCredential -eq $true) {
    $cred = Get-Credential
    $session = New-CimSession -ComputerName $ComputerName -Credential $cred
    Get-CimInstance Win32_LogicalDisk -CimSession $session -Filter "DriveType=3"
} Else {
    Get-CimInstance Win32_LogicalDisk -ComputerName $ComputerName -Filter "DriveType=3"
}
