function Set-MITPackage {
    <#
        .SYNOPSIS
        Update a MOVEit Transfer package
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
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/packages/$PackageId"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Recalled { if ($Recalled) {$body['recalled'] = $true} }
            IsNew { $body['isNew'] = $IsNew }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri = $uri
            Method = 'Patch'
            Headers = $headers
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -TypeName 'MITPackageSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}