# Recipe 10-9
# Install a PKI

# Run this bit on root

# 1. Install CA services on root
Install-WindowsFeature -Name ADCS-Cert-Authority -IncludeManagementTools

# 2. Install CA on Rootc
Install-AdcsCertificationAuthority -CAType StandaloneRootCA `
                    -KeyLength 4096  -HashAlgorithmName SHA256 `
                    -ValidityPeriod Years -ValidityPeriodUnits 20 `
                    -CACommonName "Reskit Root CA" `
                    -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" `
                    -Confirm:$false

# 3. Configure the CA
certutil.exe –setreg CA\CRLPublicationURLs '1:C:\Windows\System32\CertSrv\CertEnroll\%3%8.crl\n2:http://ca.reskit.org/pki/%3%8.crl'
certutil.exe –setreg CA\CACertPublicationURLs '2:http://ca.reskit.org/pki/%1_%3%4.crt'
certutil.exe –setreg CA\CRLPeriod 'Weeks'
certutil.exe –setreg CA\CRLPeriodUnits 26
certutil.exe –setreg CA\CRLDeltaPeriod 'Days'
certutil.exe –setreg CA\CRLDeltaPeriodUnits 0
certutil.exe –setreg CA\CRLOverlapPeriod 'Hours'
certutil.exe –setreg CA\CRLOverlapPeriodUnits 12
certutil.exe –setreg CA\ValidityPeriod 'Years'
certutil.exe –setreg CA\ValidityPeriodUnits 10
certutil.exe –setreg CA\DSConfigDN 'CN=Configuration,DC=reskit,DC=org'

# 4. Restart the CA with updated configuration
Restart-Service -Name certsvc

# 5. Publish the CRL and view CRL files
certutil.exe -crl
$CEPath =  'C:\Windows\System32\CertSrv\CertEnroll'
Get-ChildItem -Path $CEPath

# 6. Copy the CA cert and the CRL to the subordinate issuing CA:
$PathSCrl = Join-Path -Path 'C:\Windows\System32\CertSrv\CertEnroll' `
                      -ChildPath 'Reskit Root CA.crl'
$PathDCrl = Join-Path -Path '\\ca\c$' `
                      -ChildPath 'Reskit Root CA.crl'
Copy-Item $PathSCrl $PathDCrl

$PathSCrt = Join-Path -Path 'C:\Windows\System32\CertSrv\CertEnroll' `
                      -ChildPath 'ROOT_Reskit Root CA.crt'
$PathDCrt = Join-Path -Path '\\ca\c$' `
                      -ChildPath 'ROOT_Reskit Root CA.crt'
Copy-Item $PathSCrt $PathDCrt

#  STEPS 7-12 - done over on ca.reskit.org

# 7. On Issuing CS - ca.reskit.org, create a PKI folder and
#    then move the CRT and CRL files to the folder:
New-Item C:\PKI -ItemType Directory -ErrorAction Ignore
Move-Item -Path 'C:\Reskit Root CA.crl' -Destination 'C:\pki\Reskit Root CA.crl'
Move-Item -Path 'C:\ROOT_Reskit Root CA.crt' -Destination 'C:\pki\ROOT_Reskit Root CA.crt'

# 8. Publish the CA details to the Active Directory and local certificate store:
Set-Location -Path C:\PKI
certutil.exe -dspublish -f 'ROOT_Reskit Root CA.crt' RootCA
certutil.exe -addstore  -f root 'ROOT_Reskit Root CA.crt'
certutil.exe -addstore -f root 'Reskit Root CA.crl'

# 9. Create root CA certificate and CRL distribution endpoints
$ShareHT = [ordered] @{
  Name           ='PKI'
  FullAccess     = "SYSTEM,'Reskit\Domain Admins'"
  ChangeAccess   = 'Reskit\Cert Publishers'
  Path           = 'C:\PKI'
}
New-SmbShare @ShareHT

# 10. Install a subordinate enterprise issuing CA
$Features  =  'ADCS-Cert-Authority', 'ADCS-Web-Enrollment'
$Features +=  'ADCS-Enroll-Web-Pol', 'ADCS-Enroll-Web-Svc'
$Features +=  'ADCS-Online-Cert' ,'Web-Mgmt-Console'

Install-WindowsFeature -Features $Features -IncludeManagementTools

# 11. Configure CRL endpoints in IIS:
VDHT = [ordered] @{
  Site         = 'Default Web Site'
  Name         = 'PKI'
  PhysicalPath = 'C:\PKI'
}

New-WebVirtualDirectory @VDHT

# 12. Install the subordinate issuing CA on CA.Reskit.Org
# Create capolicy.inf
$CaInf = @'
[Version]
Signature="$Windows NT$"
[Certsrv_Server]
RenewalKeyLength=4096
RenewalValidityPeriod=Years
RenewalValidityPeriodUnits=5
LoadDefaultTemplates=0
AlternateSignatureAlgorithm=1
'@

# Save INF file
$PathInf = Join-Path -Path $Env:SystemRoot `
                     -ChildPath 'capolicy.inf'
$CaInf | Out-File -FilePath $PathInf

# Install 2nd tier, issuing CA
$CAHT = [ordered] @{
  CAType             = 'EnterpriseSubordinateCA'
  CACommonName       = 'ReskitIssuing CA'
  CryptoProviderName = 'RSA#Microsoft Software Key Storage Provider'
  KeyLength          = 4096
  HashAlgorithmName  = 'SHA256'
  Confirm            = $false
}

Install-AdcsCertificationAuthority @CAHT


#   Do the next steps on ROOT

# 13. Request CA cert for ca.reskit.net
Set-Location -Path c:\
Copy-Item -Path '\\ca\c$\CA.Reskit.Org_ReskitIssuing CA.req' `
          -Destination .\
certreq.exe –submit 'C:\CA.Reskit.Org_ReskitIssuing CA.req'

# 14. retreive the certificate and copy it back to ca.reskit.org
#    use the GUI to issue the certificate, then
certreq.exe -retrieve 2 c:\ca.reskit.org.crt
Copy-Item  -Path c:\ca.reskit.org* -Destination \\ca\c$\

# 15. After copying cert from the root computer, install it on CA.Reskit.Org, then
#     start and check the service
Certutil.exe -InstallCert C:\CA.Reskit.Org.Crt
Start-Service -Name CertSvc
Get-Service -Name CertSvc

# 16. Set up CRL settings in the registry
certutil.exe -setreg CACRLPeriod 'Weeks'
certutil.exe -setreg CACRLPeriodUnits 2
certutil.exe -setreg CACRLDeltaPeriod 'Days'
certutil.exe -setreg CACRLDeltaPeriodUnits 1
certutil.exe -setreg CACRLOverlapPeriod "Hours"
certutil.exe -setreg CACRLOverlapPeriodUnits 12
certutil.exe -setreg CAValidityPeriod "Years"
certutil.exe -setreg CAValidityPeriodUnits 5

# 17. Set up CRL distribution points
$CrlList = Get-CACrlDistributionPoint
foreach ($Crl in $CrlList)
    {Remove-CACrlDistributionPoint -Uri $Crl.uri -Force}
$URI = 'C:\Windows\System32\CertSrv\CertEnroll\ReskitIssuing CA.crl'
Add-CACRLDistributionPoint -Uri $URI `
  -PublishToServer -PublishDeltaToServer -Force
Add-CACRLDistributionPoint
  -Uri http://ca.reskit.org/pki/reskit.crl `
  -AddToCertificateCDP -Force
Add-CACRLDistributionPoint
  -Uri file://ca.reskit.orgpki%3%8%9.crl `
  -PublishToServer -PublishDeltaToServer -Force
Restart-Service Certsvc
Start-Sleep -Seconds 15
certutil.exe -crl

#18. Restart the service and publish the CRL
# Step 19 - restart service then publish the CRL
Restart-Service -Name CertSvc
Start-Sleep -Seconds 15
Certutil.exe -crl

# 19. Test the CRL
$WC = New-Object System.Net.WebClient
$Url = 'http://ca.reskit.org/pki/ReskitIssuing CA.crl'
$To = 'C:\ReskitIssuing CA.crl'
$WC.DownloadFile($URL,$to)
certutil -dump $to
