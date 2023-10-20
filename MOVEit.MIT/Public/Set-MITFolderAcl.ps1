function Set-MITFolderAcl {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer Folder Acl
    .LINK
        Change the Access Controls for a given folder
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/PUTapi/v1/folders/{Id}/acls-1.0
    .LINK
        Change the single user Access Controls for a given folder
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/PATCHapi/v1/folders/{Id}/acls/{entryId}-1.0                
    #>
    [OutputType('MITFolderAcl')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]                    
        [string]$FolderId,

        [Parameter(Mandatory,
            ParameterSetName = 'ByTypeHashtable')]
        [Parameter(Mandatory,                    
            ParameterSetName = 'ByTypeSwitches')]
        [Parameter(Mandatory,                    
            ParameterSetName = 'ByTypeStringArray')]
        [ValidateSet('None','User','Group','Email')]
        [string]$Type,

        [Parameter(Mandatory,
            ParameterSetName = 'ByTypeHashtable')]
        [Parameter(Mandatory,
            ParameterSetName = 'ByTypeSwitches')]
        [Parameter(Mandatory,
            ParameterSetName = 'ByTypeStringArray')]
        [string]$TypeId,

        [Parameter(Mandatory,
            ParameterSetName = 'ByEntryHashtable')]
        [Parameter(Mandatory,
            ParameterSetName = 'ByEntrySwitches')]
        [Parameter(Mandatory,
            ParameterSetName = 'ByEntryStringArray')]
        [string]$EntryId,
        
        [Parameter()]
        [ValidateSet('AddToInherited', 'OverrideInherited')]
        [string]$OverrideBehaviourType,

        # The caller can pass-in a hashtable that will be passed straight
        # to the REST API...
        [Parameter(Mandatory, 
                ParameterSetName = 'ByTypeHashtable')]
        [Parameter(Mandatory,
                ParameterSetName = 'ByEntryHashtable')]
        [hashtable]$Permissions,

        # ...or, the caller can pass-in a StringArray
        [Parameter(Mandatory,
                ParameterSetName = 'ByTypeStringArray')]
        [Parameter(Mandatory,
                ParameterSetName = 'ByEntryStringArray')]
        [ValidateSet('ReadFiles','WriteFiles','DeleteFiles','ListFiles',
                     'Notify','AddDeleteSubfolders','Share','Admin','ListUsers')]
        [string[]]$FolderPermissions,

        # ...or, the caller can use switches to specify the permissions
        [Parameter(ParameterSetName = 'ByTypeSwitches')]
        [Parameter(ParameterSetName = 'ByEntrySwitches')]
        [switch]$ReadFiles,

        [Parameter(ParameterSetName = 'ByTypeSwitches')]
        [Parameter(ParameterSetName = 'ByEntrySwitches')]
        [switch]$WriteFiles,

        [Parameter(ParameterSetName = 'ByTypeSwitches')]
        [Parameter(ParameterSetName = 'ByEntrySwitches')]
        [switch]$DeleteFiles,

        [Parameter(ParameterSetName = 'ByTypeSwitches')]
        [Parameter(ParameterSetName = 'ByEntrySwitches')]
        [switch]$ListFiles,

        [Parameter(ParameterSetName = 'ByTypeSwitches')]
        [Parameter(ParameterSetName = 'ByEntrySwitches')]
        [switch]$Notify,

        [Parameter(ParameterSetName = 'ByTypeSwitches')]
        [Parameter(ParameterSetName = 'ByEntrySwitches')]
        [switch]$AddDeleteSubfolders,

        [Parameter(ParameterSetName = 'ByTypeSwitches')]
        [Parameter(ParameterSetName = 'ByEntrySwitches')]
        [switch]$Share,

        [Parameter(ParameterSetName = 'ByTypeSwitches')]
        [Parameter(ParameterSetName = 'ByEntrySwitches')]
        [switch]$Admin,

        [Parameter(ParameterSetName = 'ByTypeSwitches')]
        [Parameter(ParameterSetName = 'ByEntrySwitches')]
        [switch]$ListUsers 
    )

    try {
        # Set the resource for this request
        $resource = "folders/$FolderId/acls"
                    
        # Build up the permissions hashtable from the switch parameters or the [MITFolderAcl] parameters
        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            '*Switches' {
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

            '*StringArray' {
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

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            'ByType*' {
                $body = @{
                    type                = $Type
                    id                  = $TypeId
                    permissions         = $Permissions
                }
                
                if ($PSBoundParameters.ContainsKey('OverrideBehaviourType')) {
                    $body['overrideBehaviourType'] = $OverrideBehaviourType
                }
                                
                # Setup the params to splat to IRM
                $irmParams = @{
                    Resource    = $resource
                    Method      = 'Put'
                    ContentType = 'application/json'
                    Body        = ($body | ConvertTo-Json)
                }
            }

            'ByEntry*' {
                $body = @{
                    permissions = $Permissions
                }
                
                if ($PSBoundParameters.ContainsKey('OverrideBehaviourType')) {
                    $body['overrideBehaviourType'] = $OverrideBehaviourType
                }
                                
                # Setup the params to splat to IRM
                $irmParams = @{
                    Resource    = "$resource/$EntryId"
                    Method      = 'Patch'
                    ContentType = 'application/json'
                    Body        = ($body | ConvertTo-Json)
                }
            }
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITFolderAcl'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}