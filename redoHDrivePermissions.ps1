$FolderPath = "D:\data" 
 
Write-Host "#Adding global Permissions    #" -ForegroundColor Green 
 
foreach ($homeFolder in (Get-ChildItem $FolderPath | Where {$_.psIsContainer -eq $true})) { 
    $homefolder 
    $acl = Get-Acl $homefolder.FullName  
    $acl.Access | %{$acl.RemoveAccessRule($_)}  
    $acl.SetAccessRuleProtection($False, $True)  
    $Rights = [System.Security.AccessControl.FileSystemRights]::FullControl 
    $inherit = [System.Security.AccessControl.FileSystemAccessRule]::ContainerInherit -bor [System.Security.AccessControl.FileSystemAccessRule]::ObjectInherit 
    $Propagation = [System.Security.AccessControl.PropagationFlags]::None 
    $Access = [System.Security.AccessControl.AccessControlType]::Allow 
    $acct = New-Object System.Security.Principal.NTAccount("Builtin\Administrators")  
    $acl.SetOwner($acct)  
    Set-Acl $homefolder.FullName $acl 
} 
 
Write-Host "#Adding user specific Permissions    #" -ForegroundColor Green 
 
foreach ($homeFolder in (Get-ChildItem $FolderPath | Where {$_.psIsContainer -eq $true})) { 
    $homeFolder 
    $acl = Get-Acl $homefolder.FullName 
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($homefolder.Name,"Modify", "ContainerInherit, ObjectInherit", "None", "Allow") 
    $acl.AddAccessRule($rule) 
    Set-Acl $homefolder.FullName $acl 
}