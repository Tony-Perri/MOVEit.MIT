function Get-MITFolderAcl {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Folder ACL
    #>
    [CmdletBinding(DefaultParameterSetName='Content')]
    param (
        [Parameter(Mandatory,
                    Position=1,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]                    
        [string]$FolderId,

        [Parameter(Mandatory=$false)]
        [int32]$Page,

        [Parameter(Mandatory=$false)]
        [int32]$PerPage,

        [Parameter(Mandatory=$false)]
        [string]$SortField,

        [Parameter(Mandatory=$false)]
        [ValidateSet('ascending', 'descending')]
        [string]$SortDirection,

        [Parameter(Mandatory=$false)]
        [switch]$IncludePaging
    )

    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/folders/$FolderId/acls"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
        Authorization = "Bearer $($script:Token.AccessToken)"
    }

    # Build the query parameters.
    $query = @{}
    switch ($PSBoundParameters.Keys) {
        Page { $query['page'] = $Page }
        PerPage { $query['perPage'] = $PerPage }
        SortField { $query['sortField'] = $SortField }
        SortDirection { $query['sortDirection'] = $SortDirection }
    }

    try{
        $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query
        $response | Write-MITResponse -Typename 'MITFolderAcl' -IncludePaging:$IncludePaging
    }
    catch {
        $_
    }

}