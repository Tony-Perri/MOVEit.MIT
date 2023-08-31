function Set-MITFileContent {
    <#
    .SYNOPSIS
        Write (upload) a file to a MOVEit Transfer folder
    .LINK
        Upload file into folder
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/POSTapi/v1/folders/{Id}/files?UploadType={UploadType}-1.0        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [string]$FolderId,

        [Parameter(Mandatory)]
        [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist"
            }
            if(-Not ($_ | Test-Path -PathType Leaf) ){
                throw "The Path argument must be a file. Folder paths are not allowed."
            }
            return $true 
        })]
        [string]$Path,

        [Parameter(Mandatory=$false)]
        [ValidateSet('SHA-1', 'SHA-256', 'SHA-384', 'SHA-512')]
        [string]$HashType,

        [Parameter(Mandatory=$false)]
        [string]$Comments
    )

    try {
        # This function will only work on version 6 or later.
        if ($PSVersionTable.PSVersion.Major -lt 6) {
            Write-Error "Write-MITPackageAttachment requires PowerShell 6 or later" -ErrorAction Stop
        }

        # Get the fileinfo
        $fileinfo = Get-Item -Path $Path
        Write-Verbose "File to upload: $($fileinfo.FullName)"
              
        # Build the request form
        $form = @{
            file = $fileinfo
        }
        
        # Process optional parameters if present
        switch ($PSBoundParameters.Keys) {
            Comments { $form['comments'] = $Comments }
            HashType {
                # Compute the hash
                $filehash = Get-FileHash -Path $fileinfo.FullName -Algorithm ($HashType -replace '-', '')
                Write-Verbose "File hash: $($filehash.Algorithm) $($filehash.Hash)"
                $form['hashtype'] = $HashType
                $form['hash'] = $filehash.Hash
            }
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "folders/$FolderId/files"
            Method = 'Post'
            ContentType = 'multipart/form-data'
            Form = $form            
        }

        # If the file 20MB or larger switch to chunked
        if ($fileinfo.Length -ge 20MB) {
            Write-Verbose 'Using Transfer-Encoding: chunked'
            $irmParams['TransferEncoding'] = 'chunked'
        }

        Invoke-MITRequest @irmParams |
            Write-MITResponse -Typename 'MITFileSimple'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}