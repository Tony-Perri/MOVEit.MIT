function Disconnect-MITServer {
    <#
    .SYNOPSIS
        Disconnect from a MOVEit Transfer server.
    #>
    
    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/token/revoke"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
    } 

    # Build the request body
    $body = @{
        token = $script:Token.AccessToken
    }

    # Setup the params to splat to IRM
    $irmParams = @{
        Uri         = $uri
        Method      = 'Post'
        Headers     = $headers
        ContentType = 'application/x-www-form-urlencoded'
        Body        =  $body
    }

    # Send the request and output the response
    try {
        $response = Invoke-RestMethod @irmParams
        if ($response.message) {
            $response.message
            "Disconnected from MOVEit Transfer server"
        }
    }
    catch {
        $_
    }
    finally {        
        # Clear the saved Token
        $script:Token = @()

        # Clear the saved Base Uri
        $script:BaseUri = ''
    }
}