function Get-MITLog {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Logs
    .DESCRIPTION
        Get MOVEit Transfer logs from /api/v1/logs endpoint
        Requires MOVEit Transfer 2020.1 and later
        Call Connect-MITServer prior to calling this function
    .EXAMPLE
        Get-MITLog -SortDirection desc
        Get logs in descending order
    .EXAMPLE
        Get-MITLog -Action FileTransfer -SortDirection desc
        Get logs in descending order filtered by action
    .EXAMPLE
        Get-MITlog -StartDateTime (Get-Date).AddDays(-1) -SortDirection desc
        Get logs in descending order for past 24 hours
    .EXAMPLE
        # Script to get all log entries since yesterday
        $logFilter = @{
            SortDirection = 'desc'    
            StartDateTime = (Get-Date).Date.AddDays(-1)
            IncludeSigns = $true    
        }
        
        # Loop through each page of logs
        $page = 1
        $allLogs = @()
        do {
            $paging, $logs = Get-MITLog @logFilter -Page $page -PerPage 200 -IncludePaging    
            $allLogs += $logs
        } while ($page++ -lt $paging.totalPages)
        
        $allLogs               
    .INPUTS
        None
    .OUTPUTS
        Collection of log records as custom MITLog objects
        Paging info as custom MITPaging object
    .LINK
        Get list of logs current user can view
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/index.html#operation/GETapi/v1/logs?Page={Page}&PerPage={PerPage}&SortField={SortField}&SortDirection={SortDirection}&StartDateTime={StartDateTime}&EndDateTime={EndDateTime}&Action={Action}&UserNameContains={UserNameContains}&UserId={UserId}&FileIdContains={FileIdContains}&FileNameContains={FileNameContains}&SizeComparison={SizeComparison}&Size={Size}&FolderId={FolderId}&FolderPathContains={FolderPathContains}&IpContains={IpContains}&AgentBrandContains={AgentBrandContains}&SuccessFailure={SuccessFailure}&SuppressSigns={SuppressSigns}&SuppressEmailNotes={SuppressEmailNotes}&SuppressLogViews={SuppressLogViews}-1.0
    .LINK        
        Get log's info
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/index.html#operation/GETapi/v1/logs/{Id}-1.0
    #>
    [CmdletBinding()]
    param (           
        # logId for REST call
        [Parameter(Mandatory=$true,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='Detail')]
        [Alias('Id')]
        [string]$LogId,

        # startDateTime for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [datetime]$StartDateTime,
        
        # endDateTime for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [datetime]$EndDateTime,

        # action for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [ValidateSet('None','FileTransfer','Administration','Upload',
                    'Download','UserMaintenance','ContentScanning')]
        [string]$Action,

        # userNameContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [string]$UserNameContains,

        # userId for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [string]$UserId,

        # fileIdContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [string]$FileIdContains,

        # fileNameContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [string]$FileNameContains,

        # sizeComparison for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [ValidateSet('None','LargerOrEqual','SmallerOrEqual')]
        [string]$SizeComparison,

        # size for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [string]$Size,

        # folderId for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [string]$FolderId,

        # folderPathContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [string]$FolderPathContains,
        
        # ipContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [string]$IpContains,

        # agentBrandContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [string]$AgentBrandContains,

        # successFailure for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [ValidateSet('None', 'Success', 'Error')]
        [string]$SuccessFailure,

        # suppressSigns for REST call
        # Note this switch sets suppressSigns to False
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [switch]$IncludeSigns,

        # suppressEmailNotes for REST call
        # Note this switch sets suppressEmailNotes to False
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [switch]$IncludeEmailNotes,

        # suppressLogViews for REST call
        # Note this switch sets suppressLogViews to False
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [switch]$IncludeLogViews,        
        
        # page for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [int32]$Page,
        
        # perPage for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [int32]$PerPage,

        # sortField for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [ValidateSet('id', 'logtime', 'action', 'username', 'userrealname', 'targetname', 
                    'filename', 'fileid', 'folderpath', 'xfersize', 'duration', 
                    'rate', 'ipaddress', 'agentbrand', 'resilnode')]
        [string]$SortField,
        
        # sortDirection for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [ValidateSet('asc', 'desc')]
        [string]$SortDirection,
        
        # switch to not include PagingInfo in the output
        [Parameter(Mandatory=$false)]
        [switch]$IncludePaging
    )
    
    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/logs"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        }   

        # Send the request and write out the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $response = Invoke-RestMethod -Uri "$uri/$LogId" -Headers $headers
                $response | Write-MITResponse -TypeName 'MITLogDetail'
            }
            'List' {
                # Build the query string as an object to pass to the -Body parameter.  The
                # switch works like a foreach.  This way, the query only contains 
                # parameters that were supplied.
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    StartDateTime { $query['startDateTime'] = $StartDateTime.ToString('yyyy-MM-ddTHH:mm:ss') }
                    EndDateTime { $query['endDateTime'] = $EndDateTime.ToString('yyyy-MM-ddTHH:mm:ss') }
                    Action { $query['action'] = $Action }
                    UserNameContains { $query['userNameContains'] = $UserNameContains }
                    UserId { $query['userId'] = $UserId }
                    FileIdContains { $query['fileIdContains'] = $FileIdContains }
                    FileNameContains { $query['fileNameContains'] = $FileNameContains }
                    SizeComparison { $query['sizeComparison'] = $SizeComparison }
                    Size { $query['size'] = $Size }
                    FolderId { $query['folderId'] = $FolderId }
                    FolderPathContains { $query['folderPathContains'] = $FolderPathContains }
                    IpContains { $query['ipContains'] = $IpContains }
                    AgentBrandContains { $query['agentBrandContains'] = $AgentBrandContains }
                    SuccessFailure { $query['successFailure'] = $SuccessFailure }
                    IncludeSigns { $query['suppressSigns'] = -not $IncludeSigns }
                    IncludeEmailNotes { $query['suppressEmailNotes'] = -not $IncludeEmailNotes }
                    IncludeLogViews { $query['suppressLogViews'] = -not $IncludeLogViews }
                    Page { $query['page'] = $Page }
                    PerPage {$query['perPage'] = $PerPage }
                    SortField {$query['sortField'] = $SortField }
                    SortDirection { $query['sortDirection'] = $SortDirection }
                }

                Write-Verbose ($query | Out-String)
            
                # Call the REST Api
                $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -Body $query

                # Write the response
                $response | Write-MITResponse -TypeName 'MITLog' -IncludePaging:$IncludePaging
            }
        }
    }
    catch {        
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }                  
}