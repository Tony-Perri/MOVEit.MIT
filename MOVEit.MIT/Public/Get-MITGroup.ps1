function Get-MITGroup {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Group(s)
    .LINK
        Get list of groups current user can view
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/groups?Page={Page}&PerPage={PerPage}-1.0        
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
        # Set the resource for this request
        $resource = "groups"

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
                    Write-MITResponse -Typename 'MITGroupSimple' -IncludePaging:$IncludePaging
            }
            'ListAll' {
                Invoke-MITGetAll -Scriptblock ${function:Get-MITGroup} -BoundParameters $PSBoundParameters
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}