function Switch-MITOrg {
    <#
    .SYNOPSIS
        Switch (ie. ActAsAdmin) to a different Org.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]                    
        [int32]$OrgId
    )

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/auth/actasadmin"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

        # Build the request body.
        $body = @{
            orgId = $OrgId
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri = $uri
            Method = 'Post'
            Headers = $headers
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -TypeName 'MITSwitchOrg'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}