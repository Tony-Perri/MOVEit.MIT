function Get-MITReport {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Report List
    .LINK
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/reports?Page={Page}&PerPage={PerPage}&SortField={SortField}&SortDirection={SortDirection}-1.0          
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(ParameterSetName='List')]
        [int32]$Page,

        [Parameter(ParameterSetName='List')]
        [int32]$PerPage,

        [Parameter(ParameterSetName='List')]        
        [switch]$IncludePaging,

        [Parameter(Mandatory, ParameterSetName='ListAll')]
        [switch]$All
    )

    try {
        # Set the Uri for this request
        $resource = "reports"

        switch ($PSCmdlet.ParameterSetName) {
            'List' {
                # Build the query parameters.
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                }

                # Send the request and write out the response
                Invoke-MITRequest -Resource "$resource" -Body $query |
                    Write-MITResponse -Typename 'MITReportSimple' -IncludePaging:$IncludePaging
            }
            'ListAll' {
                Invoke-MITGetAll -Scriptblock ${function:Get-MITReport} -BoundParameters $PSBoundParameters
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}