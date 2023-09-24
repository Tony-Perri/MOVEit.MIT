function Invoke-MITWebRequest {
    <#
    .SYNOPSIS
        Cmdlet for invoking MOVEit Transfer REST methods that
        there isn't a wrapper for yet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    Position=1)]
        [string]$Resource,

        [Parameter(Mandatory=$false)]
        [hashtable]$Query,

        [Parameter(Mandatory=$false)]
        [switch]$IncludePaging
    )
    
    try {
        Confirm-MITToken
        # Confirm the token, refreshing if necessary

        # Set the Uri for this request
        $uri = "$script:BaseUri/$Resource"
                
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        } 

        # Additonal params that will be splatted
        $irmParams = @{}
        if ($Query) { $irmParams['Body'] = $Query}

        # Add SkipCertificateCheck parameter if set
        if ($script:SkipCertificateCheck) {
            $irmParams['SkipCertificateCheck'] = $true
            Write-Verbose "SkipCertificateCheck: $true"
        }

        # If this is PowerShell 7, lets add the -SkipHttpErrorCheck param
        if ($PSVersionTable.PSVersion.Major -ge 7) { $irmParams['SkipHttpErrorCheck'] = $true}
        
        # Send the request and write out the response
        Invoke-WebRequest -Uri $uri -Headers $headers @irmParams
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}