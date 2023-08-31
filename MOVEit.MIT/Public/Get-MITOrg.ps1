function Get-MITOrg {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Org(s)
    .LINK
        Get list of organizations
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/GETapi/v1/organizations?Page={Page}&PerPage={PerPage}&SortField={SortField}&SortDirection={SortDirection}-1.0        
    #>
    [CmdLetBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
            Position=0,
            ValueFromPipelineByPropertyName=$true,
            ParameterSetName='Detail')]
        [Alias('Id')]                    
        [string]$OrgId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$PerPage,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [ValidateSet('name', 'id')]
        [string]$SortField,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]                    
        [ValidateSet('ascending', 'descending')]
        [string]$SortDirection,
        
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]        
        [switch]$IncludePaging,

        [Parameter(Mandatory, ParameterSetName='ListAll')]
        [switch]$All
    )
 
    try { 
        # Set the resource for this request
        $resource = "organizations"

        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                Invoke-MITRequest -Resource "$resource/$OrgId" |
                    Write-MITResponse -Typename 'MITOrgDetail'
            }
            'List' {            
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                    SortField { $query['sortField'] = $SortField }
                    SortDirection { $query['sortDirection'] = $SortDirection }
                }
                Invoke-MITRequest -Resource $resource -Body $query |
                    Write-MITResponse -Typename 'MITOrgSimple' -IncludePaging:$IncludePaging
            }
            'ListAll' {
                Invoke-MITGetAll -Scriptblock ${function:Get-MITOrg} -BoundParameters $PSBoundParameters
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}