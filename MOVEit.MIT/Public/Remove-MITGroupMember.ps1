function Remove-MITGroupMember {
    <#
    .SYNOPSIS
        Remove MOVEit Transfer Group Member
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]                    
        [string]$GroupId,

        [Parameter(Mandatory)]
        [string]$UserId
    )

    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/groups/$GroupId/members/$UserId"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Uri         = $uri
            Method      = 'Delete'
            Headers     = $headers
        }

        # Send the request and output the response
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse -TypeName 'MITUserSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
    
}