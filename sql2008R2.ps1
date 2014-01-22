# Set the AppD properties

# If no sysadmin account provided, use the local machine administrators group
if ($sql_sysadmin_accounts -eq "")
{ $sysadmin_accounts = $env:COMPUTERNAME + "\Administrators" }
Else
{ $sysadmin_accounts = $sql_sysadmin_accounts }
$sql_instance_id = "SQL01"
$sql_instance_name = "SQL12"
$sa_pw = convertTo-Securestring “TenB33rs!” –AsPlainText –Force

# Create setup directory
$files_path = "$Env:TEMP\SQL2012Install" 
mkdir $files_path

# Download setup files from repo
$client = new-object System.Net.WebClient
$client.DownloadFile("http://10.115.56.113/SQL2012/SQLFULL_x64_ENU_Install.exe","$($files_path)\SQLFULL_x64_ENU_Install.exe")
$client.DownloadFile("http://10.115.56.113/SQL2012/SQLFULL_x64_ENU_Core.box","$($files_path)\SQLFULL_x64_ENU_Core.box")
$client.DownloadFile("http://10.115.56.113/SQL2012/SQLFULL_x64_ENU_Lang.box","$($files_path)\SQLFULL_x64_ENU_Lang.box")

# Extract the files_path
powershell "$($files_path)\SQLFULL_x64_ENU_Install.exe"

# Set the installation variables
$instance_id = $sql_instance_id
$instance_name = $sql_instance_name

$startup_type = "Automatic"

# Run the SQL Server 2012 installer
$sql_install = "$($files_path)\SQLFULL_x64_ENU\SETUP.exe /Q /ACTION=install /INSTANCEID=$($instance_id) /INSTANCENAME=$($instance_name) /IACCEPTSQLSERVERLICENSETERMS=1 /FEATURES=SQL,Tools /SQLSYSADMINACCOUNTS=$($sysadmin_accounts) /BROWSERSVCSTARTUPTYPE=AUTOMATIC /SECURITYMODE=SQL /SAPWD=$($sa_pw) /INDICATEPROGRESS /TCPENABLED=1 /AGTSVCSTARTUPTYPE=$($startup_type)"

powershell.exe -Command $sql_install