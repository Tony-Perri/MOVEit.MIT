function Remove-MITUser {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer User
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]                    
        [Alias('Id')]
        [string]$UserId
    )

    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/users/$UserId"
                
    # Set the request headers
    $headers = @{
        Accept          = "application/json"
        Authorization   = "Bearer $($script:Token.AccessToken)"        
    }

    # Setup the params to splat to IRM
    $irmParams = @{
        Uri         = $uri
        Method      = 'Delete'
        Headers     = $headers
    }

    # Send the request and output the response
    try {
        $response = Invoke-RestMethod @irmParams
        $response
    }
    catch {
        $_
    }
}