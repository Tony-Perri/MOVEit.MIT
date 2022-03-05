function Copy-MITFile {
    <#
    .SYNOPSIS
        Copy a MOVEit Transfer file(s) to another folder
    .LINK
        Move file into another folder
        https://docs.ipswitch.com/MOVEit/Transfer2021_1/Api/Rest/#operation/POSTapi/v1/files/{Id}/copy-1.0
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

    # Put this in a process block so it can be used to move multiple files
    # by piping objects to it.
    Process {
        try {
            # Confirm the token, refreshing if necessary
            Confirm-MITToken

            # Set the Uri for this request
            $uri = "$script:BaseUri/files/$FileId/copy"
                    
            # Set the request headers
            $headers = @{
                Accept        = "application/json"
                Authorization = "Bearer $($script:Token.AccessToken)"        
            }

            # Build the request body.
            $body = @{}
            switch ($PSBoundParameters.Keys) {
                DestinationFolderId { $body['destinationFolderId'] = $DestinationFolderId }
            }

            # Setup the params to splat to IRM
            $irmParams = @{
                Uri         = $uri
                Method      = 'Post'
                Headers     = $headers
                ContentType = 'application/json'
                Body        = ($body | ConvertTo-Json)
            }

            if ($PSCmdlet.ShouldProcess("File: $FileId", "Copying file to different folder")) {
              # Send the request and output the response
                $response = Invoke-RestMethod @irmParams
                $response | Write-MITResponse -TypeName 'MITFileDetail'     
            }                     
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($PSItem)
        }
    }
}