function Switch-MITOrg {
    <#
    .SYNOPSIS
        Switch (ie. ActAsAdmin) to a different Org.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]                    
        [int32]$OrgId
    )

    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/auth/actasadmin"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
        Authorization = "Bearer $($script:Token.AccessToken)"        
    }

    # Build the request body.
    $body = @{
        orgId = $OrgId
    }

    # Setup the params to splat to IRM
    $irmParams = @{
        Uri = $uri
        Method = 'Post'
        Headers = $headers
        ContentType = 'application/json'
        Body = ($body | ConvertTo-Json)
    }

    # Send the request and output the response
    try {
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -TypeName 'MITSwitchOrg'
    }
    catch {
        $_
    }
}