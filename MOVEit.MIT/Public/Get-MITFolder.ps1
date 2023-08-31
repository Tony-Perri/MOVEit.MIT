function Get-MITFolder {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Folder(s)
    .LINK
        Get list of folders current user can view
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/PATCHapi/v1/folders/{Id}-1.0    
    .LINK
        Return folder details
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/GETapi/v1/folders/{Id}-1.0         
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='Detail')]
        [Alias('Id')]                    
        [string]$FolderId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [string]$Name,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [string]$Path,

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
        [ValidateSet('name', 'type', 'path', 'lastContentChangeTime')]
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
        $resource = "folders"
        
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                Invoke-MITRequest -Resource "$resource/$FolderId" |
                    Write-MITResponse -Typename 'MITFolderDetail'
            }
            'List' {            
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Name { $query['name'] = $Name }
                    Path { $query['path'] = $Path }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                    SortField { $query['sortField'] = $SortField }
                    SortDirection { $query['sortDirection'] = $SortDirection }
                }
                Invoke-MITRequest -Resource $resource -Body $query |
                    Write-MITResponse -Typename 'MITFolderSimple' -IncludePaging:$IncludePaging
            }
            'ListAll' {                
                Invoke-MITGetAll -Scriptblock ${function:Get-MITFolder} -BoundParameters $PSBoundParameters
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}