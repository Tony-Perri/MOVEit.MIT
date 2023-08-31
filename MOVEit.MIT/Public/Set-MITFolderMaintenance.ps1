function Set-MITFolderMaintenance {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer Folder Maintenance Setting(s)
    .LINK
        Change Automated Maintenance Settings
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/PATCHapi/v1/folders/{Id}/maintenance-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FolderId,
        
        # Folder Quota params
        [Parameter()]
        [int64]$Quota,

        [Parameter()]
        [ValidateSet('KB', 'MB')]
        [string]$QuotaLevel,

        [Parameter()]
        [bool]$ApplyToFilesInSubfolders,

        [Parameter()]
        [int32]$DisplayNewFilesForDays,

        [Parameter()]
        [bool]$ApplyToSubfolders,

        # Folder Cleanup params
        [Parameter()]
        [int32]$DeleteEmptySubfoldersAfterDays,

        [Parameter()]
        [int32]$DeleteOldFilesAfterDays,

        [Parameter()]
        [bool]$IsCleanupEnabled
    )

    try {
        # Build the request body
        $body = @{}

        switch ($PSBoundParameters.Keys) {
            Quota {
                if (-not $body['folderQuota']) { $body['folderQuota'] = @{} }
                $body['folderQuota']['quota'] = $Quota
            }
            QuotaLevel {
                if (-not $body['folderQuota']) { $body['folderQuota'] = @{} }
                $body['folderQuota']['quotaLevel'] = $QuotaLevel
            }
            ApplyToFilesInSubfolders {
                if (-not $body['folderQuota']) { $body['folderQuota'] = @{} }
                $body['folderQuota']['applyToFilesInSubfolders'] = $ApplyToFilesInSubfolders
            }
            DisplayNewFilesForDays { $body['displayNewFilesForDays'] = $DisplayNewFilesForDays}
            ApplyToSubfolders { $body['applyToSubfolders'] = $ApplyToSubfolders}
            DeleteEmptySubfoldersAfterDays {
                if (-not $body['folderCleanup']) { $body['folderCleanup'] = @{} }
                $body['folderCleanup']['deleteEmptySubfoldersAfterDays'] = $DeleteEmptySubfoldersAfterDays
            }
            DeleteOldFilesAfterDays { 
                if (-not $body['folderCleanup']) { $body['folderCleanup'] = @{} }
                $body['folderCleanup']['deleteOldFilesAfterDays'] = $DeleteOldFilesAfterDays
            }
            IsCleanupEnabled { 
                if (-not $body['folderCleanup']) { $body['folderCleanup'] = @{} }
                $body['folderCleanup']['isCleanupEnabled'] = $IsCleanupEnabled
            }
        }
                
        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "folders/$FolderId/maintenance"
            Method = 'Patch'
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse # -TypeName 'MITFolderSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}