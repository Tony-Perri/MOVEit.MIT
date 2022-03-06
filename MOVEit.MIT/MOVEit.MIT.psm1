$PublicFunctions = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$PrivateFunctions = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

#Dot source the files
Foreach($file in @($PublicFunctions + $PrivateFunctions)) {
    Try {
        . $file.FullName
    }
    Catch {
        Write-Error -Message "Failed to import $($file.FullName): $_"
    }
}

# Add aliases
Set-Alias -Name Read-MITFile -Value Get-MITFileContent
Set-Alias -Name Write-MITFile -Value Set-MITFileContent
Set-Alias -Name Write-MITPackageAttachment -Value Set-MITPackageAttachment

Export-ModuleMember -Function $PublicFunctions.Basename -Alias @('Read-MITFile','Write-MITFile','Write-MITPackageAttachment')