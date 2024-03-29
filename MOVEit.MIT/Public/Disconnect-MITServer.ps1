function Disconnect-MITServer {
    <#
    .SYNOPSIS
        Disconnect from a MOVEit Transfer server
    .LINK
        Revokes API token
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/Auth_RevokeToken        
    #>
    [CmdletBinding()]
    param (
    )

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/token/revoke"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
        } 

        # Build the request body
        $body = @{
            token = $script:Token.AccessToken
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri         = $uri
            Method      = 'Post'
            Headers     = $headers
            ContentType = 'application/x-www-form-urlencoded'
            Body        =  $body
            UserAgent   =  $script:UserAgent
        }

        # Add SkipCertificateCheck parameter if set
        if ($script:SkipCertificateCheck) {
            $irmParams['SkipCertificateCheck'] = $true
            Write-Verbose "SkipCertificateCheck: $true"
        }

        # Send the request and output the response
        $response = Invoke-RestMethod @irmParams
        if ($response.message) {
            $response.message
            "Disconnected from MOVEit Transfer server"
        }
    }
    catch [System.Net.Http.HttpRequestException], [System.Net.WebException] {
        # Format ErrorDetails which contains the JSON response from the REST API
        $PSCmdlet.ThrowTerminatingError((Format-RestErrorDetails $PSItem))
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
    finally {        
        # Clear the saved Token
        $script:Token = @()

        # Clear the saved Base Uri
        $script:BaseUri = ''
    }
}