function Set-MITFolder {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer Folder
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
        [string]$Name
    )

    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/folders/$FolderId"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
        Authorization = "Bearer $($script:Token.AccessToken)"        
    }

    # Build the request body.
    $body = @{}
    switch ($PSBoundParameters.Keys) {
        Name { $body['name'] = $Name }
        # InheritPermissions { $body['inheritPermissions'] = $InheritPermissions }
    }

    # Setup the params to splat to IRM
    $irmParams = @{
        Uri = $uri
        Method = 'Patch'
        Headers = $headers
        ContentType = 'application/json'
        Body = ($body | ConvertTo-Json)
    }

    # Send the request and output the response
    try {
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -TypeName 'MITFolderSimple'
    }
    catch {
        $_
    }    
}