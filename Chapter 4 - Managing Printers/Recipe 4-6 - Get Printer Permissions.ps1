# Recipe 4.5
# Get  Printer Permissions

# 1. Create a hash table containing printer permissions:
$Permissions =  @{
  ReadPermissions   = [uint32] 131072
  Print             = [uint32] 131080
  PrintAndRead      = [uint32] 196680
  ManagePrinter     = [uint32] 983052
  ManageDocuments   = [uint32] 983088
  ManageChild       = [uint32] 268435456
  GenericExecute    = [uint32] 536870912
  ManageThisPrinter =  [uint32] 983116 
}

# 2. Get a list of all printers and select sg's
$Printer = Get-CimInstance -Class Win32_Printer | 
    Where-Object name -EQ SGCP1

# 3. Get the Security Descriptor and Discretionary Access Control Lists (DACL)
#for each printer:

$SD = Invoke-CimMethod -InputObject $Printer `
                       -MethodName GetSecurityDescriptor
$DACL = $SD.Descriptor.DACL

# 4 For each ACE in the DACL, look to see what permissions
#   are set, and report accordingly

ForEach ($Ace in $DACL) {
"Trustee: $($ace.Trustee.Name)"

# 4.1 look at each permission
   Foreach ($Flag in ($Permissions.GetEnumerator() ) ) {

# 4.2 Is this flag  set in the access mask?
   If ($Flag.value -eq $Ace.AccessMask) {

# 4.3 Get ACE type and display user and permission type
    $AceType = switch ($ace.AceType)   
         {
            0  {'Allowed'; Break}
            1  {'Denied'; Break}
            2  {'Audit'}
          }
# 4.4 Get permission type, nicely formatted
    $PermType = $flag.name -Csplit'(?=[A-Z])' -ne '' -join ' '

# 4.5 Display the results
  "  Account: {0}\{1} - {2}: {3}" -f $Ace.Trustee.Domain,`
                                     $Ace.Trustee.Name, `
                                     $PermType, $AceType

   }  #End if Flag.Value
          
  } # End Foreach $Flag loop

}  # End Each $Ace