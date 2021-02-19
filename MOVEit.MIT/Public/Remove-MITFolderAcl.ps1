function Remove-MITFolderAcl {
    <#
    .SYNOPSIS
        Remove a MOVEit Transfer Folder Acl
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
        Position=0,
        ValueFromPipelineByPropertyName)]
        [Alias('Id')]                    
        [string]$FolderId,

        [Parameter(Mandatory)]
        [ValidateSet('None','User','Group','Email')]
        [string]$Type,

        [Parameter(Mandatory)]
        [string]$TypeId
    )

    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/folders/$FolderId/acls"
                
    # Set the request headers
    $headers = @{
        Accept          = "application/json"
        Authorization   = "Bearer $($script:Token.AccessToken)"        
    }

    # Build the body for this request.  
    $body = [ordered]@{
        type    = $Type
        id      = $TypeId
    }

    # Setup the params to splat to IRM
    $irmParams = @{
        Uri         = $uri
        Method      = 'Delete'
        Headers     = $headers
        ContentType = 'application/json'
        Body        = ($body | ConvertTo-Json)
    }

    # Send the request and output the response
    try {
        $response = Invoke-RestMethod @irmParams
        $response
    }
    catch {
        $_
    }
}