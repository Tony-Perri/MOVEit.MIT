function New-MITFolderAcl {
    <#
    .SYNOPSIS
        Create a MOVEit Transfer Folder Acl
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
        [string]$TypeId,

        [Parameter()]
        [string]$NotificationMessage,

        [Parameter(Mandatory,
                    ParameterSetName='HashTable')]
        [hashtable]$Permissions,

        [Parameter(ParameterSetName='Switches')]
        [switch]$ReadFiles,

        [Parameter(ParameterSetName='Switches')]
        [switch]$WriteFiles,

        [Parameter(ParameterSetName='Switches')]
        [switch]$DeleteFiles,

        [Parameter(ParameterSetName='Switches')]
        [switch]$ListFiles,

        [Parameter(ParameterSetName='Switches')]
        [switch]$Notify,

        [Parameter(ParameterSetName='Switches')]
        [switch]$AddDeleteSubfolders,

        [Parameter(ParameterSetName='Switches')]
        [switch]$Share,

        [Parameter(ParameterSetName='Switches')]
        [switch]$Admin,

        [Parameter(ParameterSetName='Switches')]
        [switch]$ListUsers
        
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

    # Build up the permissions hashtable from the switches. Use -Permissions to set share permissions.
    if ($PSCmdlet.ParameterSetName -eq 'Switches') {
        $Permissions = [ordered]@{
            readFiles           = "$ReadFiles"
            writeFiles          = "$WriteFiles"
            deleteFiles         = "$DeleteFiles"
            listFiles           = "$ListFiles"
            notify              = "$Notify"
            addDeleteSubfolders = "$AddDeleteSubfolders"
            share               = "$Share"
            admin               = "$Admin"
            listUsers           = "$ListUsers"
        }
    }
    
    # Build the body for this request.  
    $body = [ordered]@{
        type                = $Type
        id                  = $TypeId
        notificationMessage = $NotificationMessage
        permissions         = $Permissions
    }

    # Setup the params to splat to IRM
    $irmParams = @{
        Uri         = $uri
        Method      = 'Post'
        Headers     = $headers
        ContentType = 'application/json'
        Body        = ($body | ConvertTo-Json)
    }

    # Send the request and output the response
    try {
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -TypeName 'MITFolderAcl'
    }
    catch {
        $_
    }
}