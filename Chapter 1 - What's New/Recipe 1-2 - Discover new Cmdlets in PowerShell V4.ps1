# Recipe 1-2 - Discover new cmdlets in PowerShell V4
# NB this recipe has steps you do with the GUI presented via Show-GUI

# 1. You use the Show-Command to investigate the Get-FileHash cmdlet:
Show-Command -Name Get-FileHash

# 2. In the dialog that pops up, the Path tab corresponds to one of three parameter
# sets for this command. For the Path tab, enter $Env:windirnotepad.exe or any
# other valid file path.

# 3. Choose an algorithm like SHA512 from the drop-down menu.

# 4. Click the Copy button then paste the command into your PowerShell ISE and
# press Enter to run it. Note the hash value that is returned.

# 5. Use Show-Command to investigate Test-NetConnection:
Show-Command -Name Test-NetConnection

# 6. In the dialog box, the CommonTCPPort tab corresponds to the default parameter
#    set, the first of four. Choose HTTP from the CommonTCPPort drop-down, and
#    choose Detailed for InformationLevel. Then click Copy, and paste the script into
#    your editor below the Show-Command line, then close the Show-Command
#    window. Select this line and press F8 to run this line.

# 7. Repeat your call to Show-Command -Name Test-NetConnection. Choose the
#    ICMP tab and enter a valid internet hostname like Windows.Com in the
#    ComputerName field, or leave it blank, and choose Detailed for
#    InformationLevel.

# 8. Click the Copy button then paste the command into your PowerShell ISE below
#    the previous command, then close the Show-Command window and select the line
#    and press F8 to run it.

# 9. Repeat your call to Show-Command Name Test-NetConnection. Choose the
#    NetRouteDiagnostics tab, check the box for DiagnoseRouting, and click Run.

# 10. Repeat your call to Show-Command -Name Test-NetConnection. Choose the
#     RemotePort tab, enter 443 for the Port, and choose Detailed for
#     InformationLevel, and click Run.

