function Get-MITFile {
    <#
    .SYNOPSIS
        Get MOVEit Transfer File(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='Detail')]
        [Alias('Id')]                    
        [string]$FileId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [switch]$NewOnly,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                ParameterSetName='List')]
        [int32]$PerPage,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('name', 'size', 'datetime', 'uploadstamp', 'path')]
        [string]$SortField,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('ascending', 'descending')]
        [string]$SortDirection,
        
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]        
        [switch]$IncludePaging
    )
    try {
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/files"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        } 
        
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName)
        {
            'Detail' {
                $response = Invoke-RestMethod -Uri "$uri/$FileId" -Headers $headers
                $response | Write-MITResponse -Typename 'MITFileDetail'
            }
            'List' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    NewOnly { $query['newOnly'] = $NewOnly}
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                    SortField { $query['sortField'] = $SortField }
                    SortDirection { $query['sortDirection'] = $SortDirection }
                }
                $response = Invoke-RestMethod -Uri $uri -Headers $headers -Body $query
                $response | Write-MITResponse -Typename 'MITFileSimple' -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}