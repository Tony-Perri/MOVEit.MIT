function Get-MITFolderAcl {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Folder ACL
    .LINK
        Lists the Access Controls for a given folder
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/folders/{Id}/acls?Page={Page}&PerPage={PerPage}&SortField={SortField}&SortDirection={SortDirection}-1.0        
    #>
    [CmdletBinding(DefaultParameterSetName='Content')]
    param (
        [Parameter(Mandatory,
                    Position=0,
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

    try{
        # Set the Uri for this request
        $resource = "folders/$FolderId/acls"

        # Build the query parameters.
        $query = @{}
        switch ($PSBoundParameters.Keys) {
            Page { $query['page'] = $Page }
            PerPage { $query['perPage'] = $PerPage }
            SortField { $query['sortField'] = $SortField }
            SortDirection { $query['sortDirection'] = $SortDirection }
        }

        Invoke-MITRequest -Resource $resource -Body $query |
            Write-MITResponse -Typename 'MITFolderAcl' -IncludePaging:$IncludePaging
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }

}