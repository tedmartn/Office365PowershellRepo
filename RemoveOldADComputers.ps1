Import-Module activedirectory
$DaysInactive = 120
$Time = (Get-Date).AddDays(-($DaysInactive)
$Computers = Get-ADComputer -Filter {passwordlastset -lt $date} -Properties passwordlastset | select name,passwordlastset

foreach ($computer in $Computers) {
    Remove-ADObject
}





