function Get-MITTransferStatus {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Transfer Status
    .LINK
        Gets Transfer status information
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/xferstatus-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [int32]$RecentlyCompletedPeriod,

        [Parameter(Mandatory=$false)]
        [int32]$StatusDistributionPeriod,

        [Parameter(Mandatory=$false)]
        [string]$UserLoginName,

        [Parameter(Mandatory=$false)]
        [string]$UserRealName,

        [Parameter(Mandatory=$false)]
        [string]$UserFullName,

        [Parameter(Mandatory=$false)]
        [string]$UserIp,

        [Parameter(Mandatory=$false)]
        [string]$FolderName,

        [Parameter(Mandatory=$false)]
        [string]$FileName,

        #Note - the REST API supports an array (i.e. ?transferStatus=Failed&transferStatus=Active).
        #However, we are using a hashtable to build up the query string by passing the hasttable to
        #the invoke-restmethod -Body parameter, so, we can only supply one transferStatus query
        #parameter.
        [Parameter(Mandatory=$false)]
        [ValidateSet('Failed','Stalled','Active','Completed')]
        [string]$TransferStatus,

        [Parameter(Mandatory=$false)]
        [string]$Search,

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
        $resource = "xferstatus"
    
        # Build the query parameters.
        $query = @{}
        switch ($PSBoundParameters.Keys) {
            RecentlyCompletedPeriod { $query['recentlyCompletedPeriod'] = $RecentlyCompletedPeriod }
            StatusDistributionPeriod { $query['statusDistributionPeriod'] = $StatusDistributionPeriod }
            UserLoginName { $query['userLoginName'] = $UserLoginName }
            UserFullName { $query['userFullName'] = $UserFullName }
            UserIp { $query['userIp'] = $UserIp }
            FolderName { $query['folderName'] = $FolderName }
            FileName { $query['fileName'] = $FileName }
            TransferStatus { $query['transferStatus'] = $TransferStatus }
            Search { $query['search'] = $Search }
            Page { $query['page'] = $Page }
            PerPage { $query['perPage'] = $PerPage }
            SortField { $query['sortField'] = $SortField }
            SortDirection { $query['sortDirection'] = $SortDirection }
        }

        # Send the request and output the response
        $response = Invoke-MITRequest -Resource $resource -Body $query
        $response | Write-MITResponse -TypeName 'MITTransferStatus' -IncludePaging:$IncludePaging
        $response.statusDistribution | Write-MITResponse -Typename 'MITTransferStatusDistribution'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}