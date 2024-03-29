function Move-MITFile {
    <#
    .SYNOPSIS
        Move a MOVEit Transfer file(s) to another folder
    .LINK
        Move file into another folder
        https://docs.ipswitch.com/MOVEit/Transfer2023//Api/Rest/#operation/POSTapi/v1/files/{Id}/move-1.0
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FileId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationFolderId
    )

    begin {
        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            DestinationFolderId { $body['destinationFolderId'] = $DestinationFolderId }
        }
        
        # Setup the params to splat to IRM
        $irmParams = @{
            Method      = 'Post'
            ContentType = 'application/json'
            Body        = ($body | ConvertTo-Json)
        }
    }

    # Put this in a process block so it can be used to move multiple files
    # by piping objects to it.
    process {
        try {            
            # Set the resource for this request
            $resource = "files/$FileId/move"

            if ($PSCmdlet.ShouldProcess("File: $FileId", "Moving file to different folder")) {
                # Send the request and output the response
                Invoke-MITRequest -Resource $resource @irmParams |
                    Write-MITResponse -TypeName 'MITFileDetail'   
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}