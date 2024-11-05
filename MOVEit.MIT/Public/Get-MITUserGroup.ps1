function Get-MITUserGroup {
    <#
    .SYNOPSIS
        Get MOVEit Transfer User's Group(s)          
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]                    
        [string]$UserId,

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
        $resource = "users/$UserId/groups"
        
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
                    Write-MITResponse -Typename 'MITUserGroup' -IncludePaging:$IncludePaging
            }
            'ListAll' {
                Invoke-MITGetAll -Scriptblock ${function:Get-MITUserGroup} -BoundParameters $PSBoundParameters
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}