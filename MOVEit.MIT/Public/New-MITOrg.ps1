function New-MITOrg {
    <#
    .SYNOPSIS
        Create a MOVEit Transfer Org
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [string]$ShortName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$PassPhrase,

        [Parameter()]
        [string]$TechName,

        [Parameter()]
        [string]$TechPhone,

        [Parameter()]
        [string]$TechEmail
    )
    
    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/organizations"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
        Authorization = "Bearer $($script:Token.AccessToken)"        
    }

    # Build the request body.
    $body = @{}
    switch ($PSBoundParameters.Keys) {
        Name { $body['name'] = $Name }    
        ShortName { $body['shortName'] = $ShortName }
        PassPhrase { $body['passPhrase'] = $PassPhrase }
        TechName { $body['techName'] = $TechName }
        TechPhone { $body['techPhone'] = $TechPhone }
        TechEmail { $body['techEmail'] = $TechEmail }
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
        $response | Write-MITResponse -TypeName 'MITOrgSimple'
    }
    catch {
        $_
    }

}