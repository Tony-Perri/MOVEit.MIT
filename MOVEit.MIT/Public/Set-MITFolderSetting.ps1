function Set-MITFolderSetting {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer Folder Setting(s)
    .LINK
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/PATCHapi/v1/folders/{Id}/maintenance-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FolderId,
        
        [Parameter(ParameterSetName='Maintenance')]
        [int32]$DisplayNewFilesForDays,

        [Parameter(ParameterSetName='Maintenance')]
        [int32]$DeleteOldFilesAfterDays,

        [Parameter(ParameterSetName='Maintenance')]
        [bool]$IsCleanupEnabled
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

        # Build the request body based on the parameter set
        $body = @{}

        switch ($PSBoundParameters.Keys) {
            DisplayNewFilesForDays { $body['displayNewFilesForDays'] = $DisplayNewFilesForDays}
            DeleteOldFilesAfterDays { 
                if (-not $body['folderCleanup']) { $body['folderCleanup'] = @{} }
                $body['folderCleanup']['deleteOldFilesAfterDays'] = $DeleteOldFilesAfterDays
            }
            IsCleanupEnabled { 
                if (-not $body['folderCleanup']) { $body['folderCleanup'] = @{} }
                $body['folderCleanup']['isCleanupEnabled'] = $IsCleanupEnabled
            }
        }

        # Set the Uri based on the parameter set
        $uri = "$uri/maintenance"

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri = $uri
            Method = 'Patch'
            Headers = $headers
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse # -TypeName 'MITFolderSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}