function Invoke-MITRestMethod {
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

        # Send the request and write out the response
        $response = Invoke-RestMethod -Uri $uri -Headers $headers @irmParams
        $response | Write-MITResponse -TypeName 'MITGeneric' -IncludePaging:$IncludePaging
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}