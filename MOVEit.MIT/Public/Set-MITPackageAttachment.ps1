function Set-MITPackageAttachment {
    <#
    .SYNOPSIS
        Set (upload) an attachment for a MOVEit Transfer package
    .LINK
        Upload attachment
        https://docs.ipswitch.com/MOVEit/Transfer2023/Api/Rest/#operation/POSTapi/v1/packages/attachments-1.0         
    #>
    [CmdletBinding()]
    param (
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
        [string]$Path
    )

    try {
        # This function will only work on version 6 or later.
        if ($PSVersionTable.PSVersion.Major -lt 6) {
            Write-Error "Write-MITPackageAttachment requires PowerShell 6 or later" -ErrorAction Stop
        }

        # Get the fileinfo
        $fileinfo = Get-Item -Path $Path
        Write-Verbose "File to upload: $($fileinfo.FullName)"
        $filehash = Get-FileHash -Algorithm SHA256 -Path $fileinfo.FullName
        Write-Verbose "File hash: $($filehash.Algorithm) $($filehash.Hash)"
              
        # Build the request form
        $form = @{
            comments = $Comments
            hashtype = $filehash.Algorithm -replace 'SHA', 'SHA-' #Add the dash
            hash = $filehash.Hash
            file = $fileinfo
        }

        # Setup the params to splat to IRM
        $irmParams = @{
            Resource = "packages/attachments"
            Method = 'Post'
            Form = $form
        }

        # If the file 20MB or larger switch to chunked
        if ($fileinfo.Length -ge 20MB) {
            Write-Verbose 'Using Transfer-Encoding: chunked'
            $irmParams['TransferEncoding'] = 'chunked'
        }

        Invoke-MITRequest @irmParams |
            Write-MITResponse
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($PSItem)
    }
}