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
            Resource = "organizations"
            Method = 'Post'
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITOrgSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }

}