function New-MITFolderAcl {
    <#
    .SYNOPSIS
        Create a MOVEit Transfer Folder Acl
    .LINK
        Set the Access Controls for a given folder
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/POSTapi/v1/folders/{Id}/acls-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]                    
        [string]$FolderId,

        [Parameter(Mandatory)]
        [ValidateSet('None','User','Group','Email')]
        [string]$Type,

        [Parameter(Mandatory)]
        [string]$TypeId,

        [Parameter()]
        [string]$NotificationMessage,

        # The caller can pass-in a hashtable that will be passed straight
        # to the REST API...
        [Parameter(Mandatory,
                    ParameterSetName='HashTable')]
        [hashtable]$Permissions,

        # ...or, the caller can pass-in a StringArray
        [Parameter(Mandatory,
                ParameterSetName = 'StringArray')]
        [ValidateSet('ReadFiles','WriteFiles','DeleteFiles','ListFiles',
                     'Notify','AddDeleteSubfolders','Share','Admin','ListUsers')]
        [string[]]$FolderPermissions,

        # ...or, the caller can use switches to specify the permissions
        [Parameter(ParameterSetName='Switches')]
        [switch]$ReadFiles,

        [Parameter(ParameterSetName='Switches')]
        [switch]$WriteFiles,

        [Parameter(ParameterSetName='Switches')]
        [switch]$DeleteFiles,

        [Parameter(ParameterSetName='Switches')]
        [switch]$ListFiles,

        [Parameter(ParameterSetName='Switches')]
        [switch]$Notify,

        [Parameter(ParameterSetName='Switches')]
        [switch]$AddDeleteSubfolders,

        [Parameter(ParameterSetName='Switches')]
        [switch]$Share,

        [Parameter(ParameterSetName='Switches')]
        [switch]$Admin,

        [Parameter(ParameterSetName='Switches')]
        [switch]$ListUsers
        
    )

    try {
        # Build up the permissions hashtable from the switches. Use -Permissions to set share permissions.
        switch ($PSCmdlet.ParameterSetName) {
            'Switches' {
                $Permissions = [ordered]@{
                    readFiles           = "$ReadFiles"
                    writeFiles          = "$WriteFiles"
                    deleteFiles         = "$DeleteFiles"
                    listFiles           = "$ListFiles"
                    notify              = "$Notify"
                    addDeleteSubfolders = "$AddDeleteSubfolders"
                    share               = "$Share"
                    admin               = "$Admin"
                    listUsers           = "$ListUsers"
                }
            }

            'StringArray' {
                $Permissions = [ordered]@{
                    readFiles           = "$($FolderPermissions -contains 'ReadFiles')"
                    writeFiles          = "$($FolderPermissions -contains 'WriteFiles')"
                    deleteFiles         = "$($FolderPermissions -contains 'DeleteFiles')"
                    listFiles           = "$($FolderPermissions -contains 'ListFiles')"
                    notify              = "$($FolderPermissions -contains 'Notify')"
                    addDeleteSubfolders = "$($FolderPermissions -contains 'AddDeleteSubfolders')"
                    share               = "$($FolderPermissions -contains 'Share')"
                    admin               = "$($FolderPermissions -contains 'Admin')"
                    listUsers           = "$($FolderPermissions -contains 'ListUsers')"
                }
            }
        }
        
        # Build the body for this request.  
        $body = [ordered]@{
            type                = $Type
            id                  = $TypeId
            notificationMessage = $NotificationMessage
            permissions         = $Permissions
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource    = "folders/$FolderId/acls"
            Method      = 'Post'
            ContentType = 'application/json'
            Body        = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITFolderAcl'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}