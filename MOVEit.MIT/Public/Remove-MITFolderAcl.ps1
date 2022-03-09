function Remove-MITFolderAcl {
    <#
    .SYNOPSIS
        Remove a MOVEit Transfer Folder Acl
    .LINK
        Delete the Access Controls for a given folder
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/DELETEapi/v1/folders/{Id}/acls-1.0        
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
        [string]$TypeId
    )

    try {
        # Build the body for this request.  
        $body = [ordered]@{
            type    = $Type
            id      = $TypeId
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource    = "folders/$FolderId/acls"
            Method      = 'Delete'
            ContentType = 'application/json'
            Body        = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}