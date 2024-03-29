function Get-MITPackage {
    <#
    .SYNOPSIS
        Get MOVEit Transfer package(s)
    .LINK
        Get all packages current user can view
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/GETapi/v1/packages-1.0
    .LINK
        Get package info
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/GETapi/v1/packages/{Id}?Action={Action}&MailboxId={MailboxId}-1.0
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
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]                    
        [string]$MailboxId,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [switch]$NewOnly,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [string]$SentTo,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [string]$ReceivedFrom,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$Page,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [int32]$PerPage,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [ValidateSet('sourceStamp')]
        [string]$SortField,

        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]
        [Parameter(Mandatory=$false,
                    ParameterSetName='ListAll')]
        [ValidateSet('ascending', 'descending')]
        [string]$SortDirection,
        
        [Parameter(Mandatory=$false,
                    ParameterSetName='List')]        
        [switch]$IncludePaging,

        [Parameter(Mandatory, ParameterSetName='ListAll')]
        [switch]$All
    )

    try { 
        # Set the resource for this request
        $resource = "packages"
        
        # Send the request and write the response
        switch ($PSCmdlet.ParameterSetName) {
            'Detail' {
                $query = @{}
                switch ($PSBoundParameters.Keys) {
                    Action { $query['action'] = $Action }
                    MailboxId { $query['mailboxId'] = $MailboxId }
                }
                Invoke-MITRequest -Resource "$resource/$PackageId" -Body $query |
                    Write-MITResponse -Typename 'MITPackageDetail'
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
                Invoke-MITRequest -Resource $resource -Body $query |
                    Write-MITResponse -Typename 'MITPackageSimple' -IncludePaging:$IncludePaging
            }
            'ListAll' {
                Invoke-MITGetAll -Scriptblock ${function:Get-MITPackage} -BoundParameters $PSBoundParameters
            }
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}