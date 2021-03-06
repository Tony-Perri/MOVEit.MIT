function Get-MITFolder {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Folder(s)
    .LINK
        Get list of folders current user can view
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/PATCHapi/v1/folders/{Id}-1.0    
    .LINK
        Return folder details
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/folders/{Id}-1.0         
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
        [string]$Name,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [string]$Path,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$PerPage,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('name', 'type', 'path', 'lastContentChangeTime')]
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
        $uri = "$script:BaseUri/folders"
                
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        }
        
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $response = Invoke-RestMethod -Uri "$uri/$FolderId" -Headers $headers
                $response | Write-MITResponse -Typename 'MITFolderDetail'
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
                $response = Invoke-RestMethod -Uri $uri -Headers $headers -Body $query
                $response | Write-MITResponse -Typename 'MITFolderSimple' -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}