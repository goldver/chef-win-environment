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

$webDownload = 1 # Set "1" for ready installation files or "0" for internet downloading and installation

$srcDir = "ChefEnv"
$srcPath = "$env:HOMEPATH\Desktop\$srcDir"

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

$destination = "$gitFile"
$source = "https://github.com/git-for-windows/git/releases/download/v2.7.4.windows.1/Git-2.7.4-64-bit.exe"
$installGitPath = "C:\Program Files\Git"

Function InstallGit
{
	Try{
		If(!(Test-Path $installGitPath)){			
			Write-Host "Installing $destination... Please wait."
			Start-process $destination "/silent" -Wait #/log=$env:HOMEPATH\Downloads\GitInstall.log 
			
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
	Set-Location "$srcPath\Packages"
	InstallGit
}else{
	If(!(Test-Path $installGitPath)){
		Set-Location $srcPath
		Write-Host "Downloading $gitFile... Please wait."			
		Invoke-WebRequest $source -OutFile $destination #Changed download way to overcome bug of non downloading in regular way
		InstallGit
		Remove-Item $destination
	}else{
		Write-Host "$gitFile is installed!"
	}
}

	
Write-Host ------------------------------------------------------------
Write-Host ----                     Chef Client                    ----
Write-Host ------------------------------------------------------------

$destination = "$chefClientFile"
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
	Set-Location "$srcPath\Packages"
	InstallChefClient
}else{	
	If(!(Test-Path $install_path)){	 
		Set-Location $srcPath
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

$destination = "$rubyFile"
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
	Set-Location "$srcPath\Packages"
	InstallRuby
}else{	
	If(!(Test-Path "$installRubyPath\bin")){	 
		Set-Location $srcPath
		Write-Host "Downloading $rubyFile... Please wait."
		DownloadFile $source $destination
		InstallRuby
		Remove-Item $destination
	}else{
		Write-Host "$rubyFile is installed!"
	}
}


Write-Host ------------------------------------------------------------
Write-Host ----                    Ruby DevKit                     ----
Write-Host ------------------------------------------------------------

$extractDir = "$installRubyPath\DevKit"
$source = "$devKitFile" 
$destination = "$extractDir\$devKitFile"

If(!(Test-Path $extractDir)){
	New-Item $extractDir -type directory # Creates Directory for DevKit
	Start-Sleep -s 5 # Waiting for previous action
}else{
	Write-Host "Directory $extractDir exists"
	LogWrite "Directory $extractDir exists"
}

Function ExtractDevKit
{
	Try{
		If(!(Test-Path "$extractDir\bin")){
			Write-Host "Extracting $devKitFile... Please wait."		
			Start-process $destination " -s -y" -Wait # Unzip 7zip archive
			Write-Host "$devKitFile successfully uxtracted to $extractDir"
			Remove-Item $destination
		}else{
			Write-Host "$devKitFile already was unzipped"
			LogWrite "$devKitFile already was unzipped"
		}
	}Catch{
		Write-Host "Error extracting DevKit!"
		$errorFlag = 1
	}
}

If($webDownload){
	If(!(Test-Path "$extractDir\bin")){
		Copy-Item "$srcPath\Packages\$devKitFile" $destination -force -Recurse
		Write-Host "Copying $devKitFile file...please wait..."
		ExtractDevKit
	}else{
		Write-Host "$devKitFile already was copied"
		LogWrite "$devKitFile already was copied"
	}
}else{	
	$source = "http://dl.bintray.com/oneclick/rubyinstaller/$devKitFile"
	If(!(Test-Path "$extractDir\bin")){
		Write-Host "Downloading $devKitFile... Please wait."
		DownloadFile $source $destination
		ExtractDevKit
	}else{
		Write-Host "$devKitFile already was unzipped"
		LogWrite "$devKitFile already was unzipped"
	}
}


Write-Host ------------------------------------------------------------
Write-Host ----                 Ruby Configuration                 ----
Write-Host ------------------------------------------------------------

Try{
	Set-Location $extractDir
	ruby dk.rb init
	ruby dk.rb review
	ruby dk.rb install
	Start-Sleep -s 10 # Waiting for previous action
	gem install ohai -v 7.4.0 --no-rdoc --no-ri
}Catch{
	Write-Host "Error Ruby Configuration!"
	LogWrite "Error Ruby Configuration!"
	$errorFlag = 1
}


Write-Host ------------------------------------------------------------
Write-Host ----                 Chef Configuration                 ----
Write-Host ------------------------------------------------------------

$chefFolder = "C:\chef"

Try{
	If(Test-Path $chefFolder){
		If(!(Test-Path "$chefFolder\cookbooks")){
			Write-Host "Copying $chefFolder files"
			Copy-Item "$srcPath\chef\*" $chefFolder -force -Recurse
			Write-Host "$chefFolder files succesfuly copied"
		}else{
			Write-Host "$chefFolder\cookbooks exist"
	    }
	}else{
		Write-Host "$chefFolder isn't exists"
		LogWrite "$chefFolder isn't exists"
	}
}Catch{
	Write-Host "Error copying chef folder!"
	LogWrite "Error copying chef folder!"
	$errorFlag = 1
}

$chefOpsCodeFolder = "C:\opscode"

Try{
	If(!(Test-Path "$chefOpsCodeFolder\chef\bin")){
		Write-Host "Copying $chefOpsCodeFolder files...please wait..."
		Copy-Item "$srcPath\opscode\*" $chefOpsCodeFolder -force -Recurse
		Write-Host "$chefOpsCodeFolder files successfully copied"
	}else{
		Write-Host "$chefOpsCodeFolder exists"
		LogWrite "$chefOpsCodeFolder exists"
	}
}Catch{
	Write-Host "Error copying chef folder!"
	LogWrite "Error copying chef folder!"
	$errorFlag = 1
}

Write-Host ------------------------------------------------------------
Write-Host ----                 Run Test Cookbook                  ----
Write-Host ------------------------------------------------------------

Set-Location $chefFolder
#Start-Sleep -s 10 # Waiting for previous action

Try{	
	chef-solo -c solo.rb -j solo.json -L c:\chef\chef.log -l info
}Catch{
	Write-Host "Error running chef!"
	LogWrite "Error running chef!"
	$errorFlag = 1
}


Write-Host ------------------------------------------------------------


# Error handling
If($errorFlag){
	Write-Host "Setup has encountered an error`nRefer to setup log: $srcPath"
    LogWrite "Setup has encountered an error`nRefer to setup log: $srcPath"
}else{
    Write-Host "Setup completed successfully`
Machine is now configured for Automation!"
    LogWrite "Setup completed successfully`
Machine is now configured for Automation!"
}
Read-Host -Prompt "Press Enter to exit"


