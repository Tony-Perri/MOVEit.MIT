# BaseUri for the MOVEit Transfer server
# Will be set by Connect-MITServer
$script:BaseUri = ''

# Variable to hold the current Auth Token.
# Will be set by Connect-MITServer
$script:Token = @()

# User-Agent string to use
$script:UserAgent = "MOVEit API"

# Flag to SkipCertificateCheck.
# Only supported in PowerShell v6 and later.
# Will be set by Connect-MITServer
$script:SkipCertificateCheck = $false