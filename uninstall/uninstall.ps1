<# 
Readme: this script completely removes Chef environment from your machine
#>

Write-Host ------------------------------------------------------------
Write-Host ----           Uninstalling Chef Enviroment             ----
Write-Host ------------------------------------------------------------
$errorFlag = 0
Where-Object { $_.Name -eq "Chef" } | Select-Object -First 1 | Stop-Process

Write-Host ------------------------------------------------------------
Write-Host ----                      Chef                          ----
Write-Host ------------------------------------------------------------

$destination = "C:\opscode\chef\bin"

Try{
	If(Test-Path $destination){	
		$app = Get-WmiObject -Class win32_product -Filter "Name like '%Chef%'"
		$app.Uninstall()
		Write-Host "$removeApp succesfully removed from your machine."	
	}else{
		Write-Host "$removeApp already removed from your machine."
	}
}Catch{
	Write-Host "Error uninstalling $removeApp!"
	$errorFlag = 1
}

Write-Host ------------------------------------------------------------
Write-Host ----                      Git                           ----
Write-Host ------------------------------------------------------------

$destination = "C:\Program Files\Git\unins000.exe"
 
Try{
	If(Test-Path $destination){	
		Start-process -FilePath "$destination" -ArgumentList "/SILENT" -Wait
		Write-Host "$destination succesfully removed from your machine."
	}else{
		Write-Host "$destination already removed from your machine."
	}
}Catch{
	Write-Host "Error uninstalling Git!"
	$errorFlag = 1
}

Write-Host ------------------------------------------------------------
Write-Host ----                      Ruby                          ----
Write-Host ------------------------------------------------------------

$destination = "C:\Ruby22\unins000.exe"

Try{
	If(Test-Path $destination){	
		Start-process -FilePath "$destination" -ArgumentList "/silent" -Wait
		Write-Host "$destination succesfully removed from your machine."
	}else{
		Write-Host "$destination already removed from your machine."
	}
}Catch{
	Write-Host "Error uninstalling Ruby!"
	$errorFlag = 1
}

Write-Host ------------------------------------------------------------
Write-Host ----                Remove Directories                  ----
Write-Host ------------------------------------------------------------

$destination = @("C:\chef", "C:\opscode", "C:\Ruby22")

Foreach ($dir IN $destination)
{
	Try{
		If(Test-Path $dir){
			Remove-Item $dir -Force -Recurse
			Write-Host "$dir succesfully removed from your machine."
		}else{
			Write-Host "$dir directory already removed from your machine."
		}
		}Catch{
			Write-Host "Can't remove directories!"
			$errorFlag = 1
	}
}

Write-Host ------------------------------------------------------------

# Error handling
If($errorFlag){
	Write-Host "Script has encountered an error"
}else{
    Write-Host "Script completed successfully, 
	`nAll files were removed from your machine"
}
Read-Host -Prompt "Press Enter to exit"
