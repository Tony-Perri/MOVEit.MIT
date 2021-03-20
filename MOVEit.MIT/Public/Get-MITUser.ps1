function Get-MITUser {
    <#
    .SYNOPSIS
        Get MOVEit Transfer User(s)
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
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/users"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        } 
        
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $response = Invoke-RestMethod -Uri "$uri/$UserId" -Headers $headers
                $response | Write-MITResponse -TypeName 'MITUserDetail'
            }
            'Self' {
                $response = Invoke-RestMethod -Uri "$uri/self" -Headers $headers
                $response | Write-MITResponse -TypeName 'MITUserDetail'
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
                $response = Invoke-RestMethod -Uri $uri -Headers $headers -Body $query
                $response | Write-MITResponse -TypeName 'MITUserSimple' -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}