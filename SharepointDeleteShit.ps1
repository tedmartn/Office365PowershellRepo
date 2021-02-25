#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Function to Delete all files and Sub-folders of a given Folder
Function Empty-SPOFolder([Microsoft.SharePoint.Client.Folder]$Folder)
{
    Try {
        #Get All Files from the Folder
        $Ctx = $Folder.Context
        $Files = $Folder.Files
        $Ctx.Load($Files)
        $Ctx.ExecuteQuery()
  
        #Iterate through each File in the Root folder
        Foreach($File in $Files)
        {
            #Delete the file
            $Folder.Files.GetByUrl($File.ServerRelativeUrl).Recycle() | Out-Null
            Write-host -f Green "Deleted File '$($File.Name)' from '$($File.ServerRelativeURL)'"
        }
        $Ctx.ExecuteQuery()
  
        #Process all Sub Folders of the given folder
        $SubFolders = $Folder.Folders
        $Ctx.Load($SubFolders)
        $Ctx.ExecuteQuery()
        Foreach($Folder in $SubFolders)
        {
            #Exclude "Forms" and Hidden folders
            If( ($Folder.Name -ne "Forms") -and (-Not($Folder.Name.StartsWith("_"))))
            {
                #Call the function recursively to empty the folder
                Empty-SPOFolder -Folder $Folder
 
                #Delete the folder
                $Ctx.Web.GetFolderById($Folder.UniqueId).Recycle() | Out-Null
                $Ctx.ExecuteQuery()
                Write-host  -f Green "Deleted Folder:"$Folder.ServerRelativeUrl
            }
        }
    }
    Catch {
    write-host -f Red "Error:" $_.Exception.Message
    }
}
 
#Variables
$SiteURL = "https://cyrfinancial1.sharepoint.com"
$ServerRelativeUrl= "/Documents/Judd Properties/Judd Properties/General"
 
Try {
    #Get Credentials to connect
    $Cred= Get-Credential
 
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
   
    #Get the web from URL
    $Web = $Ctx.web
    $Ctx.Load($Web)
    $Ctx.executeQuery()
 
    #Get the Folder object by Server Relative URL
    $Folder = $Web.GetFolderByServerRelativeUrl($ServerRelativeUrl)
    $Ctx.Load($Folder)
    $Ctx.ExecuteQuery()
 
    #Call the function to empty Folder
    Empty-SPOFolder $Folder
 
    #Delete the given Folder itself
    Write-host  -f Green "Deleting Folder:"$Folder.ServerRelativeUrl
    $Folder.Recycle() | Out-Null
    $Ctx.ExecuteQuery()
}
Catch {
    write-host -f Red "Error:" $_.Exception.Message
}


#Read more: https://www.sharepointdiary.com/2018/08/sharepoint-online-delete-all-files-and-sub-folders-recursively-from-folder-using-powershell.html#ixzz6ZXehrvKP