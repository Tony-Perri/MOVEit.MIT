function Get-MITFile {
    <#
    .SYNOPSIS
        Get MOVEit Transfer File(s)
    .LINK
        Get list of files current user can view
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/GETapi/v1/files?Page={Page}&PerPage={PerPage}&SortField={SortField}&SortDirection={SortDirection}&NewOnly={NewOnly}-1.0
    .LINK
        Return file details        
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/GETapi/v1/files/{Id}-1.0 
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='Detail')]
        [Alias('Id')]                    
        [string]$FileId,
        
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='ListDetailed')]
        [string]$PathMask,
        
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='ListDetailed')]
        [string]$FileMask,

        [Parameter(Mandatory=$false,
                    ParameterSetName='ListDetailed')]
        [switch]$Recursive,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListDetailed')]
        [switch]$NewOnly,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListDetailed')]                    
        [datetime]$SinceDate,

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
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListDetailed')]
        [ValidateSet('name', 'size', 'datetime', 'uploadstamp', 'path')]
        [string]$SortField,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListDetailed')]
        [ValidateSet('ascending', 'descending')]
        [string]$SortDirection,
        
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]        
        [switch]$IncludePaging,
        
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]        
        [switch]$IncludeCurrentTimestamp,
        
        [Parameter(Mandatory=$true,
                    ParameterSetName='ListAll')]        
        [switch]$All
    )
    try {
        # Set the resource for this request
        $resource = "files"
                    
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName)
        {
            'Detail' {
                Invoke-MITRequest -Resource "$resource/$FileId" |
                    Write-MITResponse -Typename 'MITFileDetail'
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    NewOnly { $query['newOnly'] = $NewOnly}
                    SinceDate { $query['sinceDate'] = $SinceDate.ToString('yyyy-MM-ddTHH:mm:ss') }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                    SortField { $query['sortField'] = $SortField }
                    SortDirection { $query['sortDirection'] = $SortDirection }
                }
                $response = Invoke-MITRequest -Resource $resource -Body $query
                if ($IncludeCurrentTimestamp) {
                    $response | Select-Object -Property currentTimestamp |
                        Write-MITResponse -Typename 'MITCurrentTimestamp'
                }
                $response | Write-MITResponse -Typename 'MITFileSimple' -IncludePaging:$IncludePaging
            }
            'ListAll' {                
                Invoke-MITGetAll -Scriptblock ${function:Get-MITFile} -BoundParameters $PSBoundParameters
            }
            'ListDetailed' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    PathMask { $query['pathMask'] = $PathMask }
                    FileMask { $query['fileMask'] = $FileMask }
                    Recursive { $query['recursive'] = $Recursive}
                    NewOnly { $query['newOnly'] = $NewOnly}
                    SinceDate { $query['sinceDate'] = $SinceDate.ToString('yyyy-MM-ddTHH:mm:ss') }
                    SortField { $query['sortField'] = $SortField }
                    SortDirection { $query['sortDirection'] = $SortDirection }
                }
                Invoke-MITRequest -Resource "$resource/detailed" -Body $query |
                    Write-MITResponse -Typename 'MITFileSimple'
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}