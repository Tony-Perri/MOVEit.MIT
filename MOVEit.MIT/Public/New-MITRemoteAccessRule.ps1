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
            Resource = "settings/security/remoteaccess/rules"
            Method = 'Post'
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}