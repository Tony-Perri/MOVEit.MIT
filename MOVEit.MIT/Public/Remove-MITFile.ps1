function Remove-MITFile {
    <#
    .SYNOPSIS
        Remove a MOVEit Transfer File
    .LINK
        Delete folder
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/DELETEapi/v1/files/{Id}-1.0        
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FileId
    )

    process {
        try {
            # Set the Uri for this request
            $resource = "files/$FileId"

            if ($PSCmdlet.ShouldProcess("File: $FileId", "Deleting file")) {
                # Send the request and output the response
                Invoke-MITRequest -Resource $resource -Method 'Delete'
            }            
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}