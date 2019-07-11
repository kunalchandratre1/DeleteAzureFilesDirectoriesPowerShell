function RemoveFileDir ([Microsoft.Azure.Storage.File.CloudFileDirectory] $dir, [Microsoft.Azure.Commands.Common.Authentication.Abstractions.IStorageContext] $ctx)
{   
    $filelist = Get-AzStorageFile -Directory $dir
    
    foreach ($f in $filelist)
    {   
        if ($f.GetType().Name -eq "CloudFileDirectory")
        {
            RemoveFileDir $f $ctx #Calling the same unction again. This is recursion.
        }
        else
        {
            Remove-AzStorageFile -File $f           
        }
    }
    Remove-AzStorageDirectory -Directory $dir
    
} 


#define varibales
$StorageAccountName = "Your Storage account name" 
$StorageAccountKey = "Your storage account primary key"
$AzShare = "kunalshare - your azure file share name"
$AzDirectory = "LatestPublish - your directory name under which you want to delete everything; including this directry"
 
 

#create primary region storage context
$ctx = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$ctx.ToString()

#Check for Share Existence
$S = Get-AzStorageShare -Context $ctx -ErrorAction SilentlyContinue|Where-Object {$_.Name -eq $AzShare}

# Check for directory
$d = Get-AzStorageFile -Share $S -ErrorAction SilentlyContinue|select Name

if ($d.Name -notcontains $AzDirectory)
{
    # directory is not present; no action to be performed
    
}
else
{    
    $dir = Get-AzStorageFile -Share $s -Path $AzDirectory    
    RemoveFileDir $dir $ctx    
}

