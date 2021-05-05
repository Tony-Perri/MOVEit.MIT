function New-MITOrg {
    <#
    .SYNOPSIS
        Create a MOVEit Transfer Org
    .LINK
        Create new organization
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/POSTapi/v1/organizations-1.0        
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
    
    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

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
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -TypeName 'MITOrgSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }

}