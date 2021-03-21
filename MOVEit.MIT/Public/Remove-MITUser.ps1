function Remove-MITUser {
    <#
    .SYNOPSIS
        Remove a MOVEit Transfer User
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]                    
        [Alias('Id')]
        [string]$UserId
    )

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/users/$UserId"
                    
        # Set the request headers
        $headers = @{
            Accept          = "application/json"
            Authorization   = "Bearer $($script:Token.AccessToken)"        
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