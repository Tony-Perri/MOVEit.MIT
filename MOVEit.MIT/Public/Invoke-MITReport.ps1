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
        # Build the query parameters.
        $query = @{}
        switch ($PSBoundParameters.Keys) {
            Format { $query['format'] = $Format }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "reports/$ReportId/results/download"
            Accept = "application/octet-stream"
            Body = $query
        }
        
        # Send the request and write out the response
        Invoke-MITRequest @irmParams
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}