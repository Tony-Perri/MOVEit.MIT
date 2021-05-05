function Get-MITInfo {
    <#
    .SYNOPSIS
        Get MOVEit Transfer server public org info
    .LINK
        Gets public information about organization
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/info?orgId={orgId}-1.0        
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