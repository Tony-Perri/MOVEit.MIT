function Get-MITGroup {
    <#
    .SYNOPSIS
        Get MOVEit Transfer Group(s)
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [int32]$Page,

        [Parameter()]
        [int32]$PerPage,

        [Parameter()]
        [switch]$IncludePaging
    )  

    # Check to see if Connect-MITServer has been called and exit with an error
    # if it hasn't.
    if (-not $script:BaseUri) {
        Write-Error "BaseUri is invalid.  Try calling Connect-MITServer first."
        return        
    }

    # Set the Uri for this request
    $uri = "$script:BaseUri/groups"
                
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

    try {
        $response = Invoke-RestMethod -Uri "$uri" -Headers $headers -Body $query
        $response | Write-MITResponse -Typename 'MITGroupSimple' -IncludePaging:$IncludePaging
    }
    catch {
        $_
    }
}