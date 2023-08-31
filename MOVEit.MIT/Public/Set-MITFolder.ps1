function Set-MITFolder {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer Folder
    .LINK
        Partial Folder update
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/PATCHapi/v1/folders/{Id}-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FolderId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]        
        [string]$Description,

        [Parameter()]
        [bool]$InheritAccess
    )

    try {
        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Name { $body['name'] = $Name }
            Description { $body['description'] = $Description }
            InheritAccess { $body['inheritAccess'] = $InheritAccess }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "folders/$FolderId"
            Method = 'Patch'
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITFolderSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}