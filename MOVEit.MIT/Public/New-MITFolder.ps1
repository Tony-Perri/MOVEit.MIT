function New-MITFolder {
    <#
    .SYNOPSIS
        Create a MOVEit Transfer Folder
    .LINK
        Create new subfolder in folder
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/POSTapi/v1/folders/{Id}/subfolders-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FolderId,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory=$false)]
        [ValidateSet('None','CopyOnly','Always')]
        [string]$InheritPermissions
    )

    try {
        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Name { $body['name'] = $Name }
            InheritPermissions { $body['inheritPermissions'] = $InheritPermissions }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "folders/$FolderId/subfolders"
            Method = 'Post'
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