function Set-MITOrg {
    <#
    .SYNOPSIS
        Update a MOVEit Transfer Org
    .LINK
        Create new organization
        https://docs.ipswitch.com/MOVEit/Transfer2021_1/Api/Rest/#operation/PATCHapi/v1/organizations/{orgId}-1.0     
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$OrgId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [string]$ShortName,

        [Parameter()]
        [string]$Notes,

        [Parameter()]
        [string]$BaseUrl
    )
    
    try {
        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Name { $body['name'] = $Name }    
            ShortName { $body['shortName'] = $ShortName }
            Notes { $body['notes'] = $Notes }
            BaseUrl { $body['baseUrl'] = $BaseUrl }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource    = "organizations/$OrgId"
            Method      = 'Patch'
            ContentType = 'application/json'
            Body        = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITOrgSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }

}