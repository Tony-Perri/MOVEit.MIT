function Get-MITInfo {
    <#
        .SYNOPSIS
        Get MOVEit Transfer server public org info
    #>
    [CmdletBinding()]
    param (
    )

    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/info"
                
    # Set the request headers
    $headers = @{
        Accept          = "application/json"
        Authorization   = "Bearer $($script:Token.AccessToken)"        
    }

    try {
        $response = Invoke-RestMethod -Uri $uri -Headers $headers
        $response | Write-MITResponse -Typename 'MITInfo'
    }
    catch {
        $_
    }
}