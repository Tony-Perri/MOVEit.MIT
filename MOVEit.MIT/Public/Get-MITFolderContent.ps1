function Get-MITFolderContent {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Folder Content
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
        # Confirm the token, refreshing if necessary
        Confirm-MITToken
        
        # Set the Uri for this request
        $uri = "$script:BaseUri/folders/$FolderId"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        }

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
                $response = Invoke-RestMethod -Uri "$uri/content" -Headers $headers -Body $query
                $response | Write-MITResponse -Typename 'MITFolderContent' -IncludePaging:$IncludePaging
            }

            'Subfolder' {
                $response = Invoke-RestMethod -Uri "$uri/subfolders" -Headers $headers -Body $query
                $response | Write-MITResponse -Typename 'MITFolderSimple' -IncludePaging:$IncludePaging
            }

            'File' {
                $response = Invoke-RestMethod -Uri "$uri/files" -Headers $headers -Body $query
                $response | Write-MITResponse -Typename 'MITFileSimple' -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}