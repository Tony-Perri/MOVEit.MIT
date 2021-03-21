function Confirm-MITToken {
    <#
    .SYNOPSIS
        Confirm an auth token, refresh if necessary.
    .DESCRIPTION
        Determines if the token is expired or half way to expiring.
        Refreshes an auth token using the /api/v1/token endpoint.
        Called from the Get-MIT* commands.            
    .INPUTS
        None.
    .OUTPUTS
        None.
    #>    
    [CmdletBinding()]
    param (
    )

    try {
        # Check to see if Connect-MITServer has been called and exit with an error
        # if it hasn't.
        if (-not $script:BaseUri) {
            Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first." -ErrorAction Stop
        }

        # Determine how close the token is to expiring
        $elapsed = New-TimeSpan -Start $script:Token.CreatedAt
        Write-Verbose "MIT Token at $($elapsed.TotalSeconds.ToString('F0')) of $($script:Token.ExpiresIn) seconds"

        # If the key is half-way to expiring, let's go ahead and
        # refresh it.
        if ($elapsed.TotalSeconds -gt ($script:Token.ExpiresIn / 2)) {

            Write-Verbose "MIT Token expired, refreshing..."

            $params = @{
                Uri = "$script:BaseUri/token"
                Method = 'POST'
                ContentType = 'application/x-www-form-urlencoded'
                Body = "grant_type=refresh_token&refresh_token=$($script:Token.RefreshToken)"
                Headers = @{Accept = "application/json"}
            }
            
            $response = Invoke-RestMethod @params
            if ($response.access_token) {
                $script:Token = @{                    
                    AccessToken = $Response.access_token
                    CreatedAt = $(Get-Date)
                    ExpiresIn = $Response.expires_in
                    RefreshToken = $Response.refresh_token
                }
                Write-Verbose "MIT Token refreshed for access to $script:BaseUri"
            }        
        }
    }
    catch {
        Write-Verbose "MIT Token not refreshed"
        
        # Clear the saved Token
        $script:Token = @()

        # Clear the saved Base Uri
        $script:BaseUri = ''

        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}