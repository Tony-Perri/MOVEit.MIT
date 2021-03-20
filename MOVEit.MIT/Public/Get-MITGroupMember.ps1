function Get-MITGroupMember {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Group Member(s)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]                    
        [string]$GroupId,

        [Parameter()]
        [int32]$Page,

        [Parameter()]
        [int32]$PerPage,

        [Parameter()]
        [switch]$IncludePaging
    )  
    
    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/groups/$GroupId/members"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        } 
        
        # Build the query parameters.
        $query = @{}
        switch ($PSBoundParameters.Keys) {
            Page { $query['page'] = $Page }
            PerPage { $query['perPage'] = $PerPage }
        }

        # Send the request and write out the response
        $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query
        $response | Write-MITResponse -Typename 'MITUserSimple' -IncludePaging:$IncludePaging
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}