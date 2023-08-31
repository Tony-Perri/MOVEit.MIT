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
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [datetime]$StartDateTime,
        
        # endDateTime for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [datetime]$EndDateTime,

        # action for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [ValidateSet('None','FileTransfer','Administration','Upload',
                    'Download','UserMaintenance','ContentScanning')]
        [string]$Action,

        # userNameContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [string]$UserNameContains,

        # userId for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [string]$UserId,

        # fileIdContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [string]$FileIdContains,

        # fileNameContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [string]$FileNameContains,

        # sizeComparison for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [ValidateSet('None','LargerOrEqual','SmallerOrEqual')]
        [string]$SizeComparison,

        # size for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [string]$Size,

        # folderId for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [string]$FolderId,

        # folderPathContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [string]$FolderPathContains,
        
        # ipContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [string]$IpContains,

        # agentBrandContains for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [string]$AgentBrandContains,

        # successFailure for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [ValidateSet('None', 'Success', 'Error')]
        [string]$SuccessFailure,

        # suppressSigns for REST call
        # Note this switch sets suppressSigns to False
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [switch]$IncludeSigns,

        # suppressEmailNotes for REST call
        # Note this switch sets suppressEmailNotes to False
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [switch]$IncludeEmailNotes,

        # suppressLogViews for REST call
        # Note this switch sets suppressLogViews to False
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [switch]$IncludeLogViews,        
        
        # page for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [int32]$Page,
        
        # perPage for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [int32]$PerPage,

        # sortField for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [ValidateSet('id', 'logtime', 'action', 'username', 'userrealname', 'targetname', 
                    'filename', 'fileid', 'folderpath', 'xfersize', 'duration', 
                    'rate', 'ipaddress', 'agentbrand', 'resilnode')]
        [string]$SortField,
        
        # sortDirection for REST call
        [Parameter(Mandatory=$false, ParameterSetName='List')]
        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [ValidateSet('asc', 'desc')]
        [string]$SortDirection,
        
        # switch to not include PagingInfo in the output
        [Parameter(Mandatory=$false)]
        [switch]$IncludePaging,

        [Parameter(Mandatory, ParameterSetName='ListAll')]
        [switch]$All        
    )
    
    try {
        # Set the resource for this request
        $resource = "logs"

        # Send the request and write out the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                Invoke-MITRequest -Resource "$resource/$LogId" |
                    Write-MITResponse -TypeName 'MITLogDetail'
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
            
                # Send the request and write out the response
                Invoke-MITRequest -Resource $resource -Body $query |
                    Write-MITResponse -TypeName 'MITLog' -IncludePaging:$IncludePaging
            }
            'ListAll' {
                Invoke-MITGetAll -Scriptblock ${function:Get-MITLog} -BoundParameters $PSBoundParameters
            }
        }
    }
    catch {        
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }                  
}