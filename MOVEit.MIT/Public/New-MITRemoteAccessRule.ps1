function New-MITRemoteAccessRule {
    <#
    .SYNOPSIS
        Create a MOVEit Transfer remote access rule
    .LINK
        Create new default rule for remote access
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/POSTapi/v1/settings/security/remoteaccess/rules-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('Deny', 'Allow')]
        [string]$Rule,

        [Parameter()]
        [string]$Comment,

        [Parameter(Mandatory)]
        [ValidateSet('Admin', 'EndUser')]
        [string]$PermitType,

        [Parameter()]
        [ValidateSet('Highest', 'Middle', 'Lowest')]
        [string]$Priority,

        [Parameter(Mandatory)]
        [string]$HostOrIP
    )

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/settings/security/remoteaccess/rules"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Rule { $body['rule'] = $Rule }    
            Comment { $body['comment'] = $Comment }
            PermitType { $body['permitType'] = $PermitType }
            Priority { $body['priority'] = $Priority }
            HostOrIp { $body['host'] = $HostOrIp }
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
        $response | Write-MITResponse
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}