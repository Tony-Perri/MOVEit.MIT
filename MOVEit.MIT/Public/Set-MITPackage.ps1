function Set-MITPackage {
    <#
    .SYNOPSIS
        Update a MOVEit Transfer package
    .LINK
        Partial package update
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/PATCHapi/v1/packages/{Id}-1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$PackageId,

        [Parameter(Mandatory=$false)]
        [switch]$Recalled,

        [Parameter(Mandatory=$false)]
        [bool]$IsNew
    )

    try {
        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Recalled { if ($Recalled) {$body['recalled'] = $true} }
            IsNew { $body['isNew'] = $IsNew }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "packages/$PackageId"
            Method = 'Patch'
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITPackageSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}