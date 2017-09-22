10-4 Log


#    STEP 1
#    Install the AD Domain Services


PS C:> Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Success Restart Needed Exit Code      Feature Result
------- -------------- ---------      --------------
True    No             NoChangeNeeded {}


PS C:\> $PasswordSS = ConvertTo-SecureString  -string 'Pa$$w0rd' -AsPlainText -Force

PS C:\> Install-ADDSForest -DomainName Reskit.Org `
                   -SafeModeAdministratorPassword $PasswordSS `
                   -InstallDNS `
                   -DomainMode Win2012R2 -ForestMode Win2012R2 `
                   -Force
WARNING: Windows Server 2016 domain controllers have a default for the security setting 
named "Allow cryptography algorithms compatible with Windows NT 4.0" that prevents 
weaker cryptography algorithms when establishing security channel sessions.

For more information about this setting, see Knowledge Base article 942564 
(http://go.microsoft.com/fwlink/?LinkId=104751).

WARNING: A delegation for this DNS server cannot be created because the authoritative 
parent zone cannot be found or it does not run Windows DNS server. If you are integrating 
with an existing DNS infrastructure, you should manually create a delegation to this DNS 
server in the parent zone to ensure reliable name resolution from outside the domain 
"Reskit.Org". Otherwise, no action is required.

WARNING: Windows Server 2016 domain controllers have a default for the security setting  
named "Allow cryptography algorithms compatible with Windows NT 4.0" that prevents 
weaker cryptography algorithms when establishing security channel sessions.

For more information about this setting, see Knowledge Base article 942564 
(http://go.microsoft.com/fwlink/?LinkId=104751).

WARNING: A delegation for this DNS server cannot be created because the authoritative parent 
zone cannot be found or it does not run Windows DNS server. If you are integrating with an 
existing DNS infrastructure, you should manually create a delegation to this DNS server in 
the parent zone to ensure reliable name resolution from outside the domain "Reskit.Org". 
Otherwise, no action is required.

Message                                                     Context           RebootRequired  Status
-------                                                     -------           --------------  ------
You must restart this computer to complete the operation... DCPromo.General.4           True Success


#    STEP 2


#    STEP 3


#    STEP 4


#    STEP 5


#    STEP 6

   