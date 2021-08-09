function Invoke-MITReport {
    <#
    .SYNOPSIS
        Invoke (run) a MOVEit Transfer Report
    .LINK
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/reports/{Id}/results/download?Format={Format}-1.0                
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]$ReportId,

        [Parameter()]
        [ValidateSet('XML','CSV','HTMLNAKED','HTMLSTYLED','Unknown')]
        [string]$Format
    )

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/reports/$ReportId/results/download"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/octet-stream"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

        # Build the query parameters.
        $query = @{}
        switch ($PSBoundParameters.Keys) {
            Format { $query['format'] = $Format }
        }

        # Send the request and write out the response
        $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query
        $response | Write-Output
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}