function Set-MITFolderAcl {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer Folder Acl
    .LINK
        Change the Access Controls for a given folder
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/PUTapi/v1/folders/{Id}/acls-1.0
    .LINK
        Change the single user Access Controls for a given folder
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/PATCHapi/v1/folders/{Id}/acls/{entryId}-1.0                
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]                    
        [string]$FolderId,

        [Parameter(Mandatory,
            ParameterSetName = 'ByType')]
        [ValidateSet('None','User','Group','Email')]
        [string]$Type,

        [Parameter(Mandatory,
            ParameterSetName = 'ByType')]
        [string]$TypeId,

        [Parameter(Mandatory,
            ParameterSetName = 'ByEntry')]
        [string]$EntryId,
        
        [Parameter()]
        [ValidateSet('AddToInherited', 'OverrideInherited')]
        [string]$OverrideBehaviourType,

        # Permissions can either be provided as a hashtable or by
        # using switches.  The hashtable will be used if specified
        # and the switches will be ignored.
        [Parameter()]
        [hashtable]$Permissions,

        [Parameter()]
        [switch]$ReadFiles,

        [Parameter()]
        [switch]$WriteFiles,

        [Parameter()]
        [switch]$DeleteFiles,

        [Parameter()]
        [switch]$ListFiles,

        [Parameter()]
        [switch]$Notify,

        [Parameter()]
        [switch]$AddDeleteSubfolders,

        [Parameter()]
        [switch]$Share,

        [Parameter()]
        [switch]$Admin,

        [Parameter()]
        [switch]$ListUsers 
    )

    try {
        # Set the resource for this request
        $resource = "folders/$FolderId/acls"
                    
        # Build up the permissions hashtable from the switches if -Permissions was not used. 
        # Use -Permissions to set share permissions.
        if ( -not $PSBoundParameters.ContainsKey('Permissions')) {
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

        switch ($PSCmdlet.ParameterSetName) {
            ByType {
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

            ByEntry {
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