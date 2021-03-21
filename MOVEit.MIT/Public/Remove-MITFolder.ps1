function Remove-MITFolder {
    <#
    .SYNOPSIS
        Remove a MOVEit Transfer Folder
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
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/folders/$FolderId"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri         = $uri
            Method      = 'Delete'
            Headers     = $headers
        }

        # Send the request and output the response
        $response = Invoke-RestMethod @irmParams
        $response
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}