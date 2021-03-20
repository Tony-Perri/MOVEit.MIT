function New-MITGroup{
    <#
    .SYNOPSIS
        Create a MOVEit Transfer Group
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [string]$Description
    )

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/groups"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

        # Build the request body.
        $body = @{}
        switch ($PSBoundParameters.Keys) {
            Name { $body['name'] = $Name }
            Description { $body['description'] = $Description }
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
        $response | Write-MITResponse -TypeName 'MITGroupSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}