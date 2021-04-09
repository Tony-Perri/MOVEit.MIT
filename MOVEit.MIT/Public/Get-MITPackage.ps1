function Get-MITPackage {
    <#
        .SYNOPSIS
            Get MOVEit Transfer package(s)
    #>
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(Mandatory,
                    Position=0,
                    ValueFromPipelineByPropertyName=$true,
                    ParameterSetName='Detail')]
        [Alias('Id')]                    
        [string]$PackageId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='Detail')]
        [ValidateSet('Reply', 'ReplyAll', 'Forward', 'Resend')]                    
        [string]$Action,

        [Parameter(Mandatory=$false,
                    ParameterSetName='Detail')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]                    
        [string]$MailboxId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [switch]$NewOnly,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [string]$SentTo,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [string]$ReceivedFrom,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$PerPage,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [ValidateSet('sourceStamp')]
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
        $uri = "$script:BaseUri/packages"
                
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"
        }
        
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Action { $query['action'] = $Action }
                    MailboxId { $query['mailboxId'] = $MailboxId }
                }
                $response = Invoke-RestMethod -Uri "$uri/$PackageId" -Headers $headers -Body $query
                $response | Write-MITResponse -Typename 'MITPackageDetail'
            }
            'List' {            
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    NewOnly { $query['newOnly'] = $NewOnly }
                    SentTo { $query['sentTo'] = $SentTo }
                    ReceivedFrom { $query['receivedFrom'] = $ReceivedFrom }
                    MailboxId { $query['mailboxId'] = $MailboxId }
                    Page { $query['page'] = $Page }
                    PerPage { $query['perPage'] = $PerPage }
                    SortField { $query['sortField'] = $SortField }
                    SortDirection { $query['sortDirection'] = $SortDirection }
                }
                $response = Invoke-RestMethod -Uri $uri -Headers $headers -Body $query
                $response | Write-MITResponse -Typename 'MITPackageSimple' -IncludePaging:$IncludePaging
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}