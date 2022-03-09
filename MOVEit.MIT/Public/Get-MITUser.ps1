function Get-MITUser {
    <#
    .SYNOPSIS
        Get MOVEit Transfer User(s)
    .LINK
        Get list of users
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/users?Page={Page}&PerPage={PerPage}&SortField={SortField}&SortDirection={SortDirection}&Permission={Permission}&Status={Status}&Username={Username}&FullName={FullName}&Email={Email}&IsExactMatch={IsExactMatch}&OrgId={OrgId}-1.0
    .LINK
        Get current user details
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/users/self-1.0
    .LINK
        Get user details
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/users/{Id}-1.0                
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        #Detail params
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='Detail')]
        [Alias('Id')]                    
        [string]$UserId,

        #Self params
        [Parameter(Mandatory,
                    ParameterSetName='Self')]
        [switch]$Self,

        #List params
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [string]$Username,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet("AllUsers","EndUsers","Administrators","FileAdmins","GroupAdmins","TemporaryUsers","SysAdmins" )]
        [string]$Permission,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet("AllUsers","ActiveUsers","InactiveUsers","NeverSignedOnUsers","TemplateUsers")]
        [string]$Status,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [string]$FullName,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [string]$Email,
        
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]        
        [switch]$IsExactMatch,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]        
        [Int32]$OrgId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$PerPage,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('username', 'realname', 'lastLoginStamp', 'email')]
        [string]$SortField,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('ascending', 'descending')]
        [string]$SortDirection,
                
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]        
        [switch]$IncludePaging
    )

    try {
        # Set the resource for this request
        $resource = "users"
        
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                Invoke-MITRequest -Resource "$resource/$UserId" |
                    Write-MITResponse -TypeName 'MITUserDetail'
            }
            'Self' {
                Invoke-MITRequest -Resource "$resource/self" |
                    Write-MITResponse -TypeName 'MITUserDetail'
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Username { $query['username'] = $Username }
                    Permission { $query['permission'] = $Permission }
                    Status { $query['status'] = $Status }
                    FullName { $query['fullName'] = $FullName }
                    Email { $query['email'] = $Email }
                    IsExactMatch { $query['isExactMatch'] = $IsExactMatch}
                    OrgId { $query['orgId'] = $OrgId }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                    SortField { $query['sortField'] = $SortField }
                    SortDirection { $query['sortDirection'] = $SortDirection }
                }
                Invoke-MITRequest -Resource "$resource" -Body $query |
                    Write-MITResponse -TypeName 'MITUserSimple' -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}