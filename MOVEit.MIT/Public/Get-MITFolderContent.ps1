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
                    ParameterSetName='Content',
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory,
                    ParameterSetName='ContentAll',
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory,
                    ParameterSetName='File',
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory,
                    ParameterSetName='FileAll',
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory,
                    ParameterSetName='Subfolder',
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Parameter(Mandatory,
                    ParameterSetName='SubfolderAll',
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]                    
        [string]$FolderId,

        # Switch to only display subfolders
        [Parameter(Mandatory=$true,
                    ParameterSetName='Subfolder')]
        [Parameter(Mandatory=$true,
                    ParameterSetName='SubfolderAll')]
        [switch]$Subfolder,

        # Switch to only display files
        [Parameter(Mandatory=$true,
                    ParameterSetName='File')]
        [Parameter(Mandatory=$true,
                    ParameterSetName='FileAll')]
        [switch]$File,

        [Parameter()]
        [string]$Name,

        [Parameter(Mandatory=$false,
                    ParameterSetName='File')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='FileAll')]
        [switch]$NewOnly,

        [Parameter(Mandatory=$false,
                    ParameterSetName='Content')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='File')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='Subfolder')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='Content')]
        [Parameter(Mandatory=$false,
                        ParameterSetName='File')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='Subfolder')]
        [int32]$PerPage,

        [Parameter(Mandatory=$false)]
        [string]$SortField,

        [Parameter(Mandatory=$false)]
        [ValidateSet('ascending', 'descending')]
        [string]$SortDirection,

        [Parameter(Mandatory=$false,
                    ParameterSetName='Content')]
        [Parameter(Mandatory=$false,
                        ParameterSetName='File')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='Subfolder')]
        [switch]$IncludePaging,

        [Parameter(Mandatory=$true,
                    ParameterSetName='ContentAll')]
        [Parameter(Mandatory=$true,
                        ParameterSetName='FileAll')]
        [Parameter(Mandatory=$true,
                    ParameterSetName='SubfolderAll')]
        [switch]$All
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
        switch -Wildcard ($PSCmdlet.ParameterSetName)
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
            '*All' {
                Invoke-MITGetAll -Scriptblock ${function:Get-MITFolderContent} -BoundParameters $PSBoundParameters
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}