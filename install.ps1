<# 
.SYNOPSIS
This script setting up Chef environment for automation on your local machine

.DESCRIPTION
You can install it from ready files, saved on your local machine or download from internet any valid version.
Default Installation is by local files:
$webDownload = 1

If you wish to install from Internet, just set:
$webDownload = 0

Any valid version, you can find on the next links:

* Git: 'https://github.com/git-for-windows/git/releases/tag/v2.7.4.windows.1'
* Chef: 'https://downloads.chef.io/chef-client/windows/'
* Ruby & DevKit: 'http://dl.bintray.com/oneclick/rubyinstaller/'

.EXAMPLE
Just set your file/version, for example:

* $gitFile = "Git-2.7.4-64-bit.exe"
* $chefClientFile = "chef-client-12.7.2-1-x86.msi"
* $rubyFile = "rubyinstaller-2.2.4.exe"
* $installRubyPath = "C:\Ruby22"
* $devKitFile = "DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe"	
#>

# Pre-configurations
Import-Module BitsTransfer

$webDownload = 0 # Set "1" for ready installation files or "0" for internet downloading and installation

$srcDir = "ChefEnv\Packages"
$srcPath = "$env:HOMEPATH\Downloads"

$gitFile = "Git-2.7.4-64-bit.exe"
$chefClientFile = "chef-client-12.7.2-1-x86.msi"
$rubyFile = "rubyinstaller-2.2.4.exe"
$installRubyPath = "C:\Ruby22"
$devKitFile = "DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe"	

$errorFlag = 0
$logFile = "$srcPath\InstChefEnv.log"

Function LogWrite # Log writing function
{
	Param ([string]$logstring)
	Add-content $logFile -value $logstring 
}

Function DownloadFile # Downloading files function
{	
	Param ([string]$source, [string]$destination)	
	Start-BitsTransfer -Source $source -Destination $destination -Description "Downloading $source"
}

Write-Host ------------------------------------------------------------
Write-Host ----                        Git                         ----
Write-Host ------------------------------------------------------------

$destination = $gitFile
$source = "https://github.com/git-for-windows/git/releases/download/v2.7.4.windows.1/Git-2.7.4-64-bit.exe"
$installGitPath = "$env:programfiles\Git"

Function InstallGit
{
	Try{
		If(!(Test-Path $installGitPath)){			
			Write-Host "Installing $destination... Please wait."
    
            # This if statememnt is to overcome bug wist path to file on Win 8.1
            If($webDownload){
                Start-process "$srcPath\$srcDir\$destination" "/silent" -Wait #/log=$env:HOMEPATH\Downloads\GitInstall.log 
            }else{
                Start-process "$srcPath\$destination" "/silent" -Wait #/log=$env:HOMEPATH\Downloads\GitInstall.log
	        }

			Write-Host "Configure GIT environment variable."
			$env:Path+=";$installGitPath\cmd"
			[environment]::SetEnvironmentVariable('path',$env:Path,'User')
			Write-Host "$destination installed successfully!"
		}else{
			Write-Host "$destination is installed"
		}
	}Catch{
		Write-Host "Error installing $destination!"
		$errorFlag = 1
	}
}

If($webDownload){
	Set-Location "$srcPath\$srcDir\"
	InstallGit
}else{
    Set-Location $srcPath
	If(!(Test-Path $installGitPath)){
		
        If(!(Test-Path $gitFile)){	
            Write-Host "Downloading $gitFile... Please wait."		
		    Invoke-WebRequest $source -OutFile $destination #Changed download way to overcome bug of non downloading in regular way
        }
		InstallGit
		Remove-Item $destination
	}else{
		Write-Host "$gitFile is installed!"
	}
}

	
Write-Host ------------------------------------------------------------
Write-Host ----                     Chef Client                    ----
Write-Host ------------------------------------------------------------

$destination = $chefClientFile
$install_path = "C:\opscode\chef"
$source = "https://opscode-omnibus-packages.s3.amazonaws.com/windows/2012r2/i386/$chefClientFile"

Function InstallChefClient
{
	Try{
		If(!(Test-Path $install_path)){		
			Write-Host "Installing $destination... Please wait."
			Start-process $destination "/qb!" -Wait #/lv $env:HOMEPATH\Downloads\Chef-Client-Install.log
			Write-Host "$destination installed successfully!"
		}else{
			Write-Host "$destination is installed!"
			LogWrite "$destination is installed!"
		}
	}Catch{
		Write-Host "Error installing $destination!"
		$errorFlag = 1
	}
}

If($webDownload){
	Set-Location "$srcPath\$srcDir"
	InstallChefClient
}else{	
    Set-Location $srcPath
	If(!(Test-Path $install_path)){	 
		Write-Host "Downloading $chefClientFile... Please wait."
		DownloadFile $source $destination
		InstallChefClient
		Remove-Item $destination
	}else{
		Write-Host "$chefClientFile is installed!"
	}
}


Write-Host ------------------------------------------------------------
Write-Host ----                      Ruby                          ----
Write-Host ------------------------------------------------------------

$destination = $rubyFile
$source = "http://dl.bintray.com/oneclick/rubyinstaller/$rubyFile"

Function InstallRuby
{
	Try{
		$webDownload = 0
		If(!(Test-Path "$installRubyPath\bin")){			
			Write-Host "Installing $rubyFile... Please wait."
			Start-process $destination "/silent /tasks=assocfiles,modpath" -Wait
			Write-Host "$rubyFile installed successfully!"
		}else{
			Write-Host "$rubyFile is installed"
		}
	}Catch{
		Write-Host "Error installing $rubyFile!"
		$errorFlag = 1
	}
}

If($webDownload){
	Set-Location "$srcPath\$srcDir"
	InstallRuby
}else{	
    Set-Location $srcPath
	If(!(Test-Path "$installRubyPath\bin")){	 
		Write-Host "Downloading $rubyFile... Please wait."
		DownloadFile $source $destination
		InstallRuby
		Remove-Item $destination
	}else{
		Write-Host "$rubyFile is installed!"
	}
}

Write-Host "Downoads a Configuration"
Set-Location "C:\chef"
git clone https://github.com/goldver/my_configuration.git

Write-Host ------------------------------------------------------------


# Error handling
If($errorFlag = 0){
	Write-Host "Setup has encountered an error`nRefer to setup log: $srcPath"
    LogWrite "Setup has encountered an error`nRefer to setup log: $srcPath"
}else{
    Write-Host "Setup completed successfully`
Machine is now configured for Automation!"
}
Read-Host -Prompt "Press Enter to exit"


