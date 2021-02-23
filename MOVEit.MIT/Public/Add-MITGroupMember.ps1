function Add-MITGroupMember{
    <#
    .SYNOPSIS
        Add MOVEit Transfer Group Member(s)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]                    
        [string]$GroupId,

        [Parameter(Mandatory)]
        [string[]]$UserIds
    )

    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/groups/$GroupId/members"
                
    # Set the request headers
    $headers = @{
        Accept = "application/json"
        Authorization = "Bearer $($script:Token.AccessToken)"        
    }

    # Build the request body.
    $body = @{}
    switch ($PSBoundParameters.Keys) {
        GroupId { $body['id'] = $GroupId }
        UserIds { $body['userIds'] = $UserIds }
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