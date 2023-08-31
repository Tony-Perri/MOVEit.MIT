function Get-MITFile {
    <#
    .SYNOPSIS
        Get MOVEit Transfer File(s)
    .LINK
        Get list of files current user can view
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/files?Page={Page}&PerPage={PerPage}&SortField={SortField}&SortDirection={SortDirection}&NewOnly={NewOnly}-1.0
    .LINK
        Return file details        
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/files/{Id}-1.0 
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='Detail')]
        [Alias('Id')]                    
        [string]$FileId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [switch]$NewOnly,

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
        [ValidateSet('name', 'size', 'datetime', 'uploadstamp', 'path')]
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
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                    SortField { $query['sortField'] = $SortField }
                    SortDirection { $query['sortDirection'] = $SortDirection }
                }
                Invoke-MITRequest -Resource $resource -Body $query |
                    Write-MITResponse -Typename 'MITFileSimple' -IncludePaging:$IncludePaging
            }
            'ListAll' {                
                Invoke-MITGetAll -Scriptblock ${function:Get-MITFile} -BoundParameters $PSBoundParameters
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}