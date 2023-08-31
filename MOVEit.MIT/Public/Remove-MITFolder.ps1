function Remove-MITFolder {
    <#
    .SYNOPSIS
        Remove a MOVEit Transfer Folder
    .LINK
        Delete folder
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/DELETEapi/v1/folders/{Id}-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FolderId
    )

    try {
        # Set the resource for this request
        $resource = "folders/$FolderId"

        # Send the request and output the response
        Invoke-MITRequest -Resource $resource -Method 'Delete'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}