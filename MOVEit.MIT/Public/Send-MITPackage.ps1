function Send-MITPackage {
    <#
    .SYNOPSIS
        Send a MOVEit Transfer package
    .LINK
        Save or send package
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/POSTapi/v1/packages-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [bool]$DeliveryReceipts,

        [Parameter(Mandatory)]
        [PSObject[]]$Recipients,

        [Parameter(Mandatory=$false)]
        [string]$Subject,

        [Parameter(Mandatory=$false)]
        [int32]$ExpirationHours,

        [Parameter(Mandatory=$false)]
        [PSObject[]]$Attachments,
        
        [Parameter(Mandatory=$false)]
        [int32]$PackageClassificationTypeId,

        [Parameter(Mandatory=$false)]
        [ValidateSet('General','Draft','Template')]
        [string]$Type = 'General',
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('AllowAll','DenyReplyAll','DenyAllReplies')]
        [string]$NoReply,

        [Parameter(Mandatory=$false)]
        [string]$Body,

        [Parameter(Mandatory=$false)]
        [bool]$IsSecureBody,

        [Parameter(Mandatory=$false)]
        [int32]$MaxAttachDownloads,

        [Parameter(Mandatory=$false)]
        [string]$ParentId,

        [Parameter(Mandatory=$false)]
        [ValidateSet('General','Request')]
        [string]$ComposerType = 'General'
    )
       
    try {
        # Build the request body.
        $requestBody = @{}
        switch ($PSBoundParameters.Keys) {
            DeliveryReceipts { $requestBody['deliveryReceipts'] = $DeliveryReceipts }
            Recipients { $requestBody['recipients'] = @($Recipients) }
            Subject { $requestBody['subject'] = $Subject }
            ExpirationHours { $requestBody['expirationHours'] = $ExpirationHours }
            Attachments { $requestBody['attachments'] = @($Attachments | Select-Object -Property id)}
            PackageClassificationTypeId { $requestBody['packageClassificationTypeId'] = $PackageClassificationTypeId }
            Type { $requestBody['type'] = $Type }
            NoReply { $requestBody['noReply'] = $NoReply}
            Body { $requestBody['body'] = $Body }
            IsSecureBody { $requestBody['isSecureBody'] = $IsSecureBody }
            MaxAttachDownloads { $requestBody['maxAttachDownloads'] = $MaxAttachDownloads }
            ParentId { $requestBody['parentId'] = $parentId }
            ComposerType { $requestBody['composerType'] = $ComposerType }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "packages"
            Method = 'Post'
            ContentType = 'application/json'
            Body = ($requestBody | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse -TypeName 'MITPackageDetail'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}