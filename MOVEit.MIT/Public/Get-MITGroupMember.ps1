function Get-MITGroupMember {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Group Member(s)
    .LINK
        Get a list of the members of a group
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/GETapi/v1/groups/{Id}/members?Page={Page}&PerPage={PerPage}-1.0        
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]                    
        [string]$GroupId,

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
        $resource = "groups/$GroupId/members"
        
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
                    Write-MITResponse -Typename 'MITUserSimple' -IncludePaging:$IncludePaging
            }
            'ListAll' {
                Invoke-MITGetAll -Scriptblock ${function:Get-MITGroupMember} -BoundParameters $PSBoundParameters
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}