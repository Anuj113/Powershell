# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will update the ant.install.properties files with the customized values in XSTORE/Xenvironment/Genkeys
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

$hostname = hostname
cd "C:\setup\scripts"
.\generateMasterConfig.ps1
$masterConfig = "C:\setup\config\generate\master-config." + $hostname + ".env" 
#Load master-config.env into hash table
#$masterConfig = "C:\setup\config\master-config.env"
$MasterProps = convertfrom-stringdata ([IO.file]::ReadAllText($masterConfig))

#Load all template files into hash table
$xstore_ant = "C:\setup\config\template\xstore_ant.install.template"
$xenv_ant = "C:\setup\config\template\xenv_ant.install.template"

$xstoreProps = convertfrom-stringdata ([IO.file]::ReadAllText($xstore_ant))
$xenvProps = convertfrom-stringdata ([IO.file]::ReadAllText($xenv_ant))

function replace()
	{
		$configFiles = Get-ChildItem $filename -rec
		foreach ($file in $configFiles)
			{
				(Get-Content $file.PSPath) |
				Foreach-Object { $_ -replace "c\:", "c\:\" } |
				Set-Content $file.PSPath
			}
	}
	
$xstoreInstallBasedir = "C:\xstoreinstall\software"

#Filename for ant-install.properties
Set-Variable -Name "filename" 
#Common variable for value loading
Set-Variable -Name "val"

#Generate ant-install.properties for XStore

$point = Get-ChildItem -name -include "xstore-*pos*jar" -path "$xstoreInstallBasedir" -recurse | % {Split-Path -Path "$xstoreInstallBasedir\$_.FullName"}
#$ver = Get-ChildItem -name -include "15*" -path $pointdir
#$pointver = $pointdir + "\" + $ver

if (-NOT ([string]::IsNullOrEmpty($point)))
{

	$filename = $point + "\ant.install.properties"
	#Delete existing ant-install.properties to keep backup
	clear-content $filename

	foreach ($prop in $xstoreProps.Keys) {
		#Get default value from template file
		$val = $xstoreProps.$prop
		#Check if this property is overridden in master-config.env
		if ($MasterProps.ContainsKey($prop)) {
			#Use overridden value for this key
			$val=$MasterProps.$prop
		} 
		#Write to ant-install.properties
		$prop + " = " + $val >> xstore.txt
		get-content xstore.txt | set-content $filename
		
	}
	replace

	remove-item xstore.txt

}

#Generate ant-install.properties for XEnv
$xenv = Get-ChildItem -name -include "xenvironment-*jar" -path "$xstoreInstallBasedir" -recurse | % {Split-Path -Path "$xstoreInstallBasedir\$_.FullName"}
#$ver = Get-ChildItem -name -include "15*" -path $pointdir
#$pointver = $pointdir + "\" + $ver

if (-NOT ([string]::IsNullOrEmpty($xenv)))
{
	$filename = $xenv + "\ant.install.properties"
	#Delete existing ant-install.properties to keep backup
	clear-content $filename

	foreach ($prop in $xenvProps.Keys) {
		#Get default value from template file
		$val = $xenvProps.$prop
		#Check if this property is overridden in master-config.env
		if ($MasterProps.ContainsKey($prop)) {
			#Use overridden value for this key
			$val=$MasterProps.$prop
		} 
		#Write to ant-install.properties
		$prop + " = " + $val >> xenv.txt
		get-content xenv.txt | set-content $filename
	}
	replace
	
	remove-item xenv.txt
}

