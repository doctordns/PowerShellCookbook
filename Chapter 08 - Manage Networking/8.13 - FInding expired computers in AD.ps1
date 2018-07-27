# Recipe 10-13 0 FInding expired computers in AD

# 1 Build the report header:
$RKReport = ''
$RkReport += "*** Reskit.Org AD Unused Computer Report`n"
$RKReport += "*** Generated [$(Get-Date)]`n"
$RKReport += "***********************************`n`n"

# 2. Report on computer accounts that have not logged in in past 14 days:
$RkReport += "*** Machines not logged on in past 14 days`n"
$FortnightAgo = (Get-Date).AddDays(-14)
$RKHT1 = @{
    Properties = 'lastLogonDate'
    Filter     = 'lastLogonDate -lt $FortnightAgo'
}
$RKReport += Get-ADComputer -$RKHT1 |
    Format-Table -PropertyName lastLogonDate |
        Out-String

# 4. Report on computer accounts that have not logged in the past month:
$RkReport += " * * * Machines not logged on in past month`n"
$AMonthAgo = (Get-Date).AddMonths(-1)
$RkReport += Get-ADComputer `-Properties lastLogonDate -Filter 'lastLogonDate -lt $AMonthAgo' |
    Sort-Object -Property lastLogonDate |
        Foramat-Table -Property Name, LastLogonDate |
            Out-String

            # 4. Display the report:
$RKReport