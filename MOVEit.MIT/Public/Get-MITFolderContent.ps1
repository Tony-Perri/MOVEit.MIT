function Get-MITFolderContent {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Folder Content
    .LINK
        Get content of the folder
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/folders/{Id}/content?Page={Page}&PerPage={PerPage}&SortField={SortField}&SortDirection={SortDirection}&Name={Name}-1.0        
    .LINK
        Get list of subfolders in folder
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/folders/{Id}/subfolders?Page={Page}&PerPage={PerPage}&SortField={SortField}&SortDirection={SortDirection}&Name={Name}-1.0
    .LINK
        Get list of files in folder
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/GETapi/v1/folders/{Id}/files?Page={Page}&PerPage={PerPage}&SortField={SortField}&SortDirection={SortDirection}&Name={Name}&NewOnly={NewOnly}-1.0                
    #>
    [CmdletBinding(DefaultParameterSetName='Content')]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]                    
        [string]$FolderId,

        # Switch to only display subfolders
        [Parameter(Mandatory=$true,
                    ParameterSetName='Subfolder')]
        [switch]$Subfolder,

        # Switch to only display files
        [Parameter(Mandatory=$true,
                    ParameterSetName='File')]
        [switch]$File,

        [Parameter(Mandatory=$false)]
        [string]$Name,

        [Parameter(Mandatory=$false,
                    ParameterSetName='File')]
        [switch]$NewOnly,

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

    try {
        # Set the resource for this request
        $resource = "folders/$FolderId"
                    
        # Build the query parameters.
        $query = @{}
        switch ($PSBoundParameters.Keys) {
            Name { $query['name'] = $Name }
            NewOnly { $query['newOnly'] = $NewOnly }
            Page { $query['page'] = $Page }
            PerPage { $query['perPage'] = $PerPage }
            SortField { $query['sortField'] = $SortField }
            SortDirection { $query['sortDirection'] = $SortDirection }
        }

        # Send the request and write out the response
        switch ($PSCmdlet.ParameterSetName)
        {
            'Content' {                
                Invoke-MITRequest -Resource "$resource/content" -Body $query |
                    Write-MITResponse -Typename 'MITFolderContent' -IncludePaging:$IncludePaging
            }

            'Subfolder' {
                Invoke-MITRequest -Resource "$resource/subfolders" -Body $query |
                    Write-MITResponse -Typename 'MITFolderSimple' -IncludePaging:$IncludePaging
            }

            'File' {
                Invoke-MITRequest -Resource "$resource/files" -Body $query |
                    Write-MITResponse -Typename 'MITFileSimple' -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}