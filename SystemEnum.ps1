######################################################################
#   Author: Daniel Brown
#   Date: 17 July 2022
#   Purpose: To enumerate a system and display relevant information
#
######################################################################
#File to store output
$logfile = 'logfile'

# Return current date
$date = get-date;

# Return hostname 
$currenthost = hostname;

# Stores each name in an array named 'users' 
$users = (get-wmiobject win32_useraccount).name;
# Iterate over 'users' and for each user perform the following:
function User-Groups {
foreach ($element in $users) {
    ("==================================")                                                  # Make it pretty
    ("User ") + $element                                                                    # Print User + username
    (net user $element).split('^')[22] + [environment]::newline +                           # Print the 22 line in the array with group info
    (net user $element).split('^')[23] + [environment]::newline + [environment]::newline    # Print the 23 line in the array with group info
    }
}

# Currently logged in users
$linusers = query user /server:$SERVER;
#stackoverflow.com/questions/23219718/powershell-script-to-see-currently-logged-in-users-domain-and-machine-status

$runprocesses = get-process | format-table ProcessName, Id;

# Services and their states:
$servicestate = get-service | format-table name,status;


#Network Information
function Net-Info {
$netinfo = (get-NetIPConfiguration).NetAdapter
$netinfo
$morenet = get-NetIPConfiguration 
$tcpservices = Get-NetTCPConnection | format-table LocalAddress, RemoteAddress, OwningProcess;
}

#TCP/UDP port info
$tcpudpinfo = netstat -a;

#systeminfo
function Sys-Info {
$os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName . | Select-Object `
-Property BuildNumber,BuildType,OSType,ServicePackMajorVersion,ServicePackMinorVersion
$compmanmodel = Get-WmiObject -Class Win32_ComputerSystem
#-Property [a-z]*
$proctype = Get-WmiObject -Class Win32_ComputerSystem -ComputerName . | Select-Object `
-Property SystemType
$os
$compmanmodel
$proctype
}
#Currently mapped drives

$curmapdrive = get-PSDrive | format-table Name,Provider,Root,CurrentLocation;
#currently configured devices
function Cur-Drive {
$configdevices = gwmi Win32_SystemDriver | 
select name, @{n="version"; e={( get-item $_.pathname).VersionInfo.FileVersion}};
$configdevices
}
$cursharefile = Get-WmiObject -class Win32_Share | format-table Name,Path,Description;

# List Currently scheduled tasks
$schedtasks = get-scheduledtask;

function Enum-System {
"
     _____            __                    ______                    
    / ___/__  _______/ /____  ____ ___     / ____/___  __  ______ ___ 
    \__ \/ / / / ___/ __/ _ \/ __ `__  \   / __/ / __ \/ / / / __ `__  \
   ___/ / /_/ (__  ) /_/  __/ / / / / /  / /___/ / / / /_/ / / / / / /
  /____/\__, /____/\__/\___/_/ /_/ /_/  /_____/_/ /_/\__,_/_/ /_/ /_/ 
       /____/                                                         
"                                                                                                                                                                                                                                                                                                    
"`n"
"==================================================================="
"Beginning Current date"
$date
"`n"
"End of Current date"
"==================================================================="
"`n"
"==================================================================="
"Beginning Hostname"
$currenthost
"`n"
"End of Hostname"
"==================================================================="
"`n"
"==================================================================="
"Beginning Current Users and Groups"

User-Groups
"`n"
"End of Current Users and Groups"
"==================================================================="
"`n"
"==================================================================="
"Beginning Current logged in users"

$linusers
"`n"
"End of Current logged in users"
"==================================================================="
"`n"
"==================================================================="
"Beginning Current running processes"

$runprocesses
"`n"
"End of Current running processes"
"==================================================================="
"`n"
"==================================================================="
"Beginning Services and their states"

$servicestate
"`n"
"End of Services and their states"
"==================================================================="
"`n"
"==================================================================="
"Beginning Network Information and Adapter Information"

Net-Info
"`n"
"End of Network Information and Adapter Information"
"==================================================================="
"`n"
"==================================================================="
"Beginning TCP/UDP Ports"

$tcpudpinfo
"`n"
"End of TCP/UDP Ports"
"==================================================================="
"`n"
"==================================================================="
"Beginning System Information"

Sys-Info
"`n"
"End of System Information"
"==================================================================="
"`n"
"==================================================================="
"Beginning Current Mapped Drives"

$curmapdrive
"`n"
"End of Current Mapped Drives"
"==================================================================="
"`n"
"==================================================================="
"Beginning Currently Configured Devices"

Cur-Drive
"`n"
"End of Currently Configured Devices"
"==================================================================="
"`n"
"==================================================================="
"Beginning Currently Shared Files"

$cursharefile
"`n"
"End of Currently Shared Files"
"==================================================================="
"`n"
"==================================================================="
"Beginning Scheduled Tasks"
$schedtasks
"`n"
"End of Scheduled Tasks"
"==================================================================="
}

function Check-File{
    
    $FileExists = Test-Path $logfile
    if($FileExists -eq $False){
    $date = get-date
    $secdate = (($date.month).ToString()+"_"+($date.day).ToString()+"_"+ `
    ($date.year).ToString()+"_"+($date.hour).ToString()+"_"+ `
    ($date.minute).ToString()+"_"+($date.second).ToString())
    $fileversion = $logfile+"_"+$secdate+".txt"
    Enum-System >> $fileversion
    "Command Completed Succesfully"
    "File logged to: " + $fileversion
    }else {
    $date = get-date
    $secdate = (($date.month).ToString()+"_"+($date.day).ToString()+"_"+ `
    ($date.year).ToString()+"_"+($date.hour).ToString()+"_"+ `
    ($date.minute).ToString()+"_"+($date.second).ToString())
    $fileversion = $logfile+"_"+$secdate+".txt"
    Enum-System >> $fileversion
    "Command Completed Succesfully"
    "File logged to: " + $fileversion}
}
Enum-System
Check-File

# Tac format of getting the date format 
#get-date -format "yyyy_mm_dd_hhmmss"