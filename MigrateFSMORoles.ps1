import-module activedirectory
$domainForest = Get-ADDomain |select Forest
$domainController = $env:computername
Move-ADDirectoryServerOperationMasterRole -Identity $domainController –OperationMasterRole DomainNamingMaster,PDCEmulator,RIDMaster,SchemaMaster,InfrastructureMaster
