function New-MITFolder {
    <#
    .SYNOPSIS
        Create a MOVEit Transfer Folder
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
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/folders/$FolderId/subfolders"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Name { $body['name'] = $Name }
            InheritPermissions { $body['inheritPermissions'] = $InheritPermissions }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri = $uri
            Method = 'Post'
            Headers = $headers
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -TypeName 'MITFolderSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}