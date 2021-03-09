function New-MITRemoteAccessRule {
    <#
    .SYNOPSIS
        Create a MOVEit Transfer remote access rule
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

    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

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
    try {
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse
    }
    catch {
        $_
    }
}