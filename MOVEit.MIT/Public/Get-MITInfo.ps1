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
        # Send the request and write out the response
        Invoke-MITRequest -Resource 'info' |
            Write-MITResponse -Typename 'MITInfo'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}