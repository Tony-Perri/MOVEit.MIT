function Set-MITFolderNotification {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer Folder Notification Setting(s)
    .LINK
        Change folder update notifications
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/PATCHapi/v1/folders/{Id}/notifications-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                    Position=0,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FolderId,
        
        [Parameter()]
        [ValidateSet('None', 'Immediately')]
        [string]$DeliveryReceiptToSender,

        [Parameter()]
        [bool]$ApplyToSubfolders,

        [Parameter()]
        [ValidateSet('Normal', 'InboxOutbox')]
        [string]$NotificationStyle,

        [Parameter()]
        [ValidateSet('Hours', 'Days', 'Minutes')]
        [string]$AlertSenderFileIsNotDownloadedTimeType,

        [Parameter()]
        [int32]$NewFileAlertToRecipientTime,

        [Parameter()]
        [int32]$UploadConfirmationToSenderTime,

        [Parameter()]
        [int32]$AlertSenderFileIsNotDownloadedTime
    )

    try {
        # Build the request body
        $body = @{}

        switch ($PSBoundParameters.Keys) {
            DeliveryReceiptToSender { $body['deliveryReceiptToSender'] = $DeliveryReceiptToSender }
            ApplyToSubfolders { $body['applyToSubfolders'] = $ApplyToSubfolders }
            NotificationStyle { $body['notificationStyle'] = $NotificationStyle }
            AlertSenderFileIsNotDownloadedTimeType { $body['alertSenderFileIsNotDownloadedTimeType'] = $AlertSenderFileIsNotDownloadedTimeType }
            NewFileAlertToRecipientTime { $body['newFileAlertToRecipientTime'] = $NewFileAlertToRecipientTime }
            UploadConfirmationToSenderTime { $body['uploadConfirmationToSenderTime'] = $UploadConfirmationToSenderTime }
            AlertSenderFileIsNotDownloadedTime { $body['alertSenderFileIsNotDownloadedTime'] = $AlertSenderFileIsNotDownloadedTime }
        }
                
        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "folders/$FolderId/notifications"
            Method = 'Patch'
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        Invoke-MITRequest @irmParams |
            Write-MITResponse # -TypeName 'MITFolderSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}