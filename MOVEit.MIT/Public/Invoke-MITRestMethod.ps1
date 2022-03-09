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
        # Additonal params that will be splatted
        $irmParams = @{}
        if ($Query) { $irmParams['Body'] = $Query}

        # Send the request and write out the response
        Invoke-MITRequest -Resource $Resource @irmParams |
            Write-MITResponse -TypeName 'MITGeneric' -IncludePaging:$IncludePaging
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}