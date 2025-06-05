function Get-MITCurrentTimestamp {
    <#
    .SYNOPSIS
        Get MOVEit Transfer current time
    #>
    [CmdletBinding()]
    param (
    )

    try {
        # Send the request and write out the response
        Invoke-MITRequest -Resource 'files' -Body @{sinceDate = '2037-12-30 23:59:59'} |
            Select-Object -Property 'currentTimestamp' |
            Write-MITResponse -Typename 'MITCurrentTimestamp'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}