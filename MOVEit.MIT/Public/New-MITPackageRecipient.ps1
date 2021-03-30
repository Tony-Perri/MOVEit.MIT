function New-MITPackageRecipient {
    <#
        .SYNOPSIS
        Helper function to create a new recipient for the
        Send-MITPackage function
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('To', 'CC', 'BCC')]
        [string]$Role,

        [Parameter(Mandatory)]
        [ValidateSet('User', 'Group', 'Unreg', 'Unverified')]
        [string]$Type,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Identifier
    )

    # Output the parameters
    [PSCustomObject]@{
        role = $Role
        type = $Type
        identifier = $Identifier
    }
}