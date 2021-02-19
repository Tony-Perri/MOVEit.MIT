function New-MITUser {
    <#
    .SYNOPSIS
        Create a MOVEit Transfer User
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Username,    
    
        [Parameter()]
        [string]$FullName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Password,

        [Parameter()]
        [string]$Email,

        [Parameter()]
        [string]$SourceUserId,

        [Parameter()]
        [ValidateSet('TemporaryUser', 'User', 'FileAdmin', 'Admin', 'SysAdmin')]
        [string]$Permission,

        [Parameter()]
        [switch]$ForceChangePassword,

        [Parameter()]
        [int32]$OrgID,

        [Parameter()]
        [string]$Notes,

        [Parameter()]
        [string]$HomeFolderPath,

        [Parameter()]
        [ValidateSet('AllowIfExists', 'DenyIfExists')]
        [string]$HomeFolderInUseOption
    )
    
    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/users"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
        Authorization = "Bearer $($script:Token.AccessToken)"        
    }

    # Build the request body.
    $body = @{}
    switch ($PSBoundParameters.Keys) {
        Username { $body['username'] = $Username }    
        FullName { $body['fullName'] = $FullName }
        Password { $body['password'] = $Password }
        Email { $body['email'] = $Email }
        SourceUserId { $body['sourceUserId'] = $SourceUserId }
        Permission { $body['permission'] = $Permission }
        ForceChangePassword { $body['forceChangePassword'] = $ForceChangePassword }
        OrgID { $body['orgID'] = $OrgID }
        Notes { $body['notes'] = $Notes }
        HomeFolderPath { $body['homeFolderPath'] = $HomeFolderPath }
        HomeFolderInUseOption { $body['HomeFolderInUseOption'] = $HomeFolderInUseOption }
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
    try {
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -TypeName 'MITUserSimple'
    }
    catch {
        $_
    }
}