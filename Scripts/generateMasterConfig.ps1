$installDir = (Split-Path $MyInvocation.MyCommand.Definition)

$configFolder = "$installDir"+"\..\config"
$generateFolder = "$configFolder"+"\generate"

#Create the generate folder if it does not exist
if (-Not $(Try { Test-Path $generateFolder } Catch { $false }) ) {New-Item $generateFolder -type directory}


#Remove all master-config files from generate folder
Remove-Item ($generateFolder + "\master-config*.env") -Recurse

#Position for StoreId,Store-Controller Ip & Terminal ID columns
$rowStoreId,$colStoreId = 5,3
$rowStoreCntrlIp,$colStoreCntrlIp = 5,4
$rowRegisterId,$colRegisterId = 5,5
$regStart = 2

#Load register-config.csv
$registerConfigfile = $configFolder + "\register-config.csv"
$registerConfig = Import-Csv $registerConfigfile

#For each reg config in spreadsheet, generate a master-config.env
foreach ($i in $registerConfig)
{
	$storeId = $($i.StoreId) 
	$storeController = $($i.{Store-Controller Ip}) 
	$regId = $($i.{Register ID}) 
	$regIp = $($i.{IP address})
	$listener = $($i.listener)
	$env = $($i.Environment)
	$computerName = $($i.Hostname)
	$chainName = $($i.{Chain Name})
	$chainStoreId = $($i.ChainStoreId)
	$xohs = $($i.XOHS)
	$xadmin = $($i.XAdmin)
	$xcenter = $($i.XCenter)

    #Pick the base master-config file for register based on environment it belongs to
    #Check if the base master-config was found matching register's environment, else default to master-config.env
    if (Test-Path ($configFolder + "\master-config." + $env + ".env")){
        Write-Host "Register $computerName belongs to $env Environment, picking master-config.$env.env as base for this register" -ForegroundColor Green
        $masterConfig = $configFolder + "\master-config." + $env + ".env"
    }else
    {
        Write-Host "Register $computerName belongs to $env Environment, but master-config.$env.env not found, picking master-config.env as base for this register" -ForegroundColor Yellow
        $masterConfig = $configFolder + "\master-config.env"
    }

    #Load master-config.env into hash table
    $MasterProps = convertfrom-stringdata ([IO.file]::ReadAllText($masterConfig))

	#Update master-config hashTable with these values
	$MasterProps."rtlLocId" = $ChainStoreId 
	$MasterProps."terminalId" = $regId
	$MasterProps."storeprimary.host" = $chainName+$storeId+"00" 
	$MasterProps."leadreg" = $MasterProps."storeprimary.host" 
	$MasterProps."storeControllerIp" = $storeController 
	$MasterProps."storeName" = "TJX HomeGoods " + $env
	$MasterProps."role" = "nonlead"
	$MasterProps."uploadHttpServerURL" = $xohs
	$MasterProps."xcenter.host" = $xcenter
	$MasterProps."ListenerPort" = $listener
	$MasterProps."db.xcenter" = "true"
	$MasterProps."path.config" = "\:version1\:region/ntam\:country/us\:brand/HomeGoods\:regtype/other\:profile/regspecialization/register\:hardware/register\:version1/patch"
	$regHostName = $computerName

	#Check if this register is a store controller
	if ($regIp.Equals($storeController)){
	#Lead register
	$MasterProps."role" = "lead" 
	$regHostName = $chainName+$storeId+"00" 
	#$MasterProps."path.config" = "\:version1\:region/ntam\:country/us\:brand/HomeGoods\:regtype/other\:version1/patch"
	$MasterProps."path.config" = "\:version1\:region/ntam\:country\:/us\:brand/HomeGoods\:regtype/primary\:hardware/storecontroller\:version1/patch"
	}

	#cd $installDir
	cd $configFolder
    if (Test-Path master-config.txt){
	    Remove-Item master-config.txt
    }
	#Writ values of MasterProps to .env file
	foreach ($prop in $MasterProps.Keys) {
		#Get default value from template file
		$val = $MasterProps.$prop
		#Write to master-config.txt
		$prop + " = " + $val >>master-config.txt
	}
	$filename = $generateFolder + "\master-config." + $computerName + ".env"
	get-content master-config.txt | set-content $filename
}

#Cleanup temp files
cd $configFolder
    if (Test-Path master-config.txt){
	    Remove-Item master-config.txt
    }
cd C:\setup\scripts

#Generate master-config.env based on hostname
echo "Pick correct master-config.env based on hostname for this register & place at c:\setup\config..."
$hostname = Hostname
$filename = $generateFolder + "\master-config." + $hostname + ".env"
if (Test-Path $masterConfig){
 Remove-item $configFolder\master-config.env
 Copy-Item $filename $configFolder\master-config.env
 Write-Host "Replaced master-config.env with $filename"
}else{
    echo "No master-config matching hostname found in C:\setup\config\Generate folder, continuing without replacing"
}


#Logic when excel file was used
#Open register-config spreadsheet
#$objExcel = New-Object -ComObject Excel.Application
#$objExcel.visible = $false
#$file = "C:\setup\config\register-config.xlsx"
#$sheetName = "Sheet1"
#$workbook = $objExcel.Workbooks.Open($file)
#$sheet = $workbook.Worksheets.Item($sheetName)

	# Read storeId, controllerIp, RegisterId, listener port 
	#$storeId = $sheet.Cells.Item($regRow,$colStoreId).text 
	#$storeController = $sheet.Cells.Item($regRow,$colStoreCntrlIp).text 
	#$regId = $sheet.Cells.Item($regRow,$colRegisterId).text 
	#$regIp = $sheet.Cells.Item($regRow,2).text

#$objExcel.quit()
