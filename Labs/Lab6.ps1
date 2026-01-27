# Lab 6: Using variables, arrays, and hash tables in PowerShell

# --->LON-CL1

# Exercise 1: Working with variable types
# ---------------------------------------
# Task 1: Use string variables
$logPath = "C:\Logs\"
$logPath.GetType()
$logPath | Get-Member
$logFile = "log.txt"
$logPath += $logFile
$logPath
$logPath.Replace("C:","D:")
$logPath = $logPath.Replace("C:","D:")
$logPath

# Task 2: Use DateTime variables
$today = Get-Date
$today.GetType()
$today | Get-Member
$logFile = [string]$today.Year + "-" + $today.Month + "-" + $today.Day + "-" + $today.Hour + "-" + $today.Minute + ".txt"
$cutOffDate = $today.AddDays(-30)
Get-ADUser -Properties LastLogonDate -Filter {LastLogonDate -gt $cutOffDate}



# Exercise 2: Using arrays
# ------------------------
# Task 1: Use an array to update the department for users
$mktgUsers = Get-ADUser -Filter {Department -eq "Marketing"} -Properties Department
$mktgUsers.count
$mktgUsers[0]
$mktgUsers | Set-ADUser -Department "Business Development"
$mktgUsers | Format-Table Name,Department
Get-ADUser -Filter {Department -eq "Marketing"}
Get-ADUser -Filter {Department -eq "Business Development"}

# Task 2: Use an array list
[System.Collections.ArrayList]$computers="LON-SRV1","LON-SRV2","LON-DC1"
$computers.IsFixedSize
$computers.IsFixedSize
$computers.Remove("LON-SRV2")
$computers



# Exercise 3: Using hash tables
# -----------------------------
# Task 1: Use a hash table
$mailList=@{"Frank"="Frank@fabriakm.com";"Libby"="LHayward@contso.com";"Matej"="MSTaojanov@tailspintoys.com"}
$mailList
$mailList.Libby
$mailList.Libby="Libby.Hayward@contoso.com"
$mailList.Add("Stela","Stela.Sahiti")
$mailList.Remove("Frank")
$mailList
