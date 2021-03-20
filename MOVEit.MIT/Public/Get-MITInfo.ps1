function Get-MITInfo {
    <#
    .SYNOPSIS
        Get MOVEit Transfer server public org info
    #>
    [CmdletBinding()]
    param (
    )

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/info"
                    
        # Set the request headers
        $headers = @{
            Accept          = "application/json"
            Authorization   = "Bearer $($script:Token.AccessToken)"        
        }

        # Send the request and write out the response
        $response = Invoke-RestMethod -Uri $uri -Headers $headers
        $response | Write-MITResponse -Typename 'MITInfo'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}