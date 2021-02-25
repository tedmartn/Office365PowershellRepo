#Parameters
$SiteURL = "https://cyrfinancial1.sharepoint.com/"
$LibraryName = "Documents\Judd P"
  
#Connect to the Site
Connect-PnPOnline -URL $SiteURL -UseWebLogin
  
#Get the web & Root folder of the library
$Web = Get-PnPWeb
$Library = Get-PnPList -Identity $LibraryName -Includes RootFolder
$RootFolder = $Library.RootFolder
 
#Function to delete all Files and sub-folders from a Folder
Function Empty-PnPFolder($Folder)
{
    #Get the site relative path of the Folder
    If($Folder.Context.web.ServerRelativeURL -eq "/")
    {
        $FolderSiteRelativeURL = $Folder.ServerRelativeUrl
    }
    Else
    {       
        $FolderSiteRelativeURL = $Folder.ServerRelativeUrl.Replace($Folder.Context.web.ServerRelativeURL,"")
    }
  
    #Delete all files in the Folder
    $Files = Get-PnPFolderItem -FolderSiteRelativeUrl $FolderSiteRelativeURL -ItemType File
    ForEach ($File in $Files)
    {
        #Delete File
        Remove-PnPFile -ServerRelativeUrl $File.ServerRelativeURL -Force -Recycle
        Write-Host -f Green ("Deleted File: '{0}' at '{1}'" -f $File.Name, $File.ServerRelativeURL)      
    }
  
    #Process all Sub-Folders
    $SubFolders = Get-PnPFolderItem -FolderSiteRelativeUrl $FolderSiteRelativeURL -ItemType Folder
    Foreach($SubFolder in $SubFolders)
    {
        #Exclude "Forms" and Hidden folders
        If(($SubFolder.Name -ne "Forms") -and (-Not($SubFolder.Name.StartsWith("_"))))
        {
            #Call the function recursively
            Empty-PnPFolder -Folder $SubFolder
  
            #Delete the folder
            Remove-PnPFolder -Name $SubFolder.Name -Folder $FolderSiteRelativeURL -Force -Recycle
            Write-Host -f Green ("Deleted Folder: '{0}' at '{1}'" -f $SubFolder.Name, $SubFolder.ServerRelativeURL)
        }
    }
}
  
#Call the function to empty document library
Empty-PnPFolder -Folder $RootFolder


#Read more: https://www.sharepointdiary.com/2018/05/sharepoint-online-delete-all-files-in-document-library-using-powershell.html#ixzz6ZYCpgOHU