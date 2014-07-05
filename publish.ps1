# =================================================
# Run this script to publish all versions of Common.Logging.Serilog.StructuredText
#
# JSNLog has a dependency on this package. It will always log strings. Those strings may
# contain JSON objects, which are log in a structured way with this package.
#
# DO NOT send this file to github! It has secret codes.
# =================================================

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1, HelpMessage="Version number of new version. Format: <Major Version>.<Minor Version>.<Bug Fix>.<Build Number>")]
  [string]$version,
)

# ---------------
# Constants

$versionPlaceholder = "__Version__"

# ---------------
# Update version numbers

Function ApplyVersion([string]$templatePath)
{
	# Get file path without the ".template" extension  
	$filePath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($_.FullName), [System.IO.Path]::GetFileNameWithoutExtension($_.FullName))

	# Copy template file to file with same name but without ".template"
	# Whilst coying, replace __Version__ placeholder with version
	# Must use encoding ascii. bower register (used further below) does not understand other encodings, such as utf 8.
	(Get-Content $templatePath) | Foreach-Object {$_ -replace $versionPlaceholder, $version} | Out-File -encoding ascii $filePath

    Write-Host "Updated version in : $filePath"
}

# Visit all files in current directory and its sub directories that end in ".template", and call ApplyVersion on them.
get-childitem '.' -recurse -force | ?{$_.extension -eq ".template"} | ForEach-Object { ApplyVersion $_.FullName }

# ---------------

cd src

# Upload Nuget package for .Net version
nuget pack Common.Logging.Serilog.StructuredText.csproj -Prop Configuration=Release -Build -OutputDirectory NuGet\GeneratedPackages
nuget push NuGet\GeneratedPackages\Common.Logging.Serilog.StructuredText.$version.0.nupkg 5f7175ef-b808-47a3-84c5-a4ab801d74c6 

cd ..

# Commit any changes and deletions (but not additions) to Github
git commit -a -m "$version"
		
# Push to Github		
git tag $version
git push https://github.com/mperdeck/Common.Logging.Serilog.StructuredText.git --tags

git branch $version
git push https://github.com/mperdeck/Common.Logging.Serilog.StructuredText.git --all

Exit

		

