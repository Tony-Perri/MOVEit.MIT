function Set-MITFolderNotification {
    <#
    .SYNOPSIS
        Change a MOVEit Transfer Folder Notification Setting(s)
    .LINK
        Change folder update notifications
        https://docs.ipswitch.com/MOVEit/Transfer2021/Api/Rest/#operation/PATCHapi/v1/folders/{Id}/notifications-1.0        
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
        [switch]$ApplyToSubfolders,

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
        # Confirm the token, refreshing if necessary
        Confirm-MITToken

        # Set the Uri for this request
        $uri = "$script:BaseUri/folders/$FolderId/notifications"
                    
        # Set the request headers
        $headers = @{
            Accept = "application/json"
            Authorization = "Bearer $($script:Token.AccessToken)"        
        }

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
            Uri = $uri
            Method = 'Patch'
            Headers = $headers
            ContentType = 'application/json'
            Body = ($body | ConvertTo-Json)
        }

        # Send the request and output the response
        $response = Invoke-RestMethod @irmParams
        $response | Write-MITResponse # -TypeName 'MITFolderSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }    
}