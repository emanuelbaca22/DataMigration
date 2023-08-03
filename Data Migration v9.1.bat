 @echo off
setlocal enableextensions
REM Set color and current directory
color 74

REM Set our xcopy and robocopy attributes
REM set our C drive scan exempt list here

set src=C
set dst=D
set xcopyOP=/Q /E /V /C /I /Y /J
set roboOP=/E /R:2 /W:0 /IM /MIR /NFL /NDL /V /TS /FP
set cExempt=/XD "C:\Program Files (x86)" "C:\Program Files" "C:\Oracle11G" "C:\OneDriveTemp" "C:\PerfLogs" "C:\Users" "C:\Win-builds" "C:\Windows" "C:\boot" "C:\Intel" "C:\ProgramData" "C:\CheckPoint" "C:\Lotus" "C:\$Windows.~WS" "C:\$Recycle.Bin" "C:\Recovery" "C:\Documents and Settings" "C:\ESD" "C:\System Volume Information"   

echo.
echo   -----------------------------------------------------------------------------------------------------------------------------------------
echo   Program Created By: Emanuel Baca
echo   Date of last modification: 11/17/22
echo   Quality of Life additions such as listing User Profile Folders (Sorted by Most Recently Modified), Listing Free Disk Space of C and External
echo   Drives if applicable. Fixed an issue with the backupLog when selecting option 3, added hidden options 5 and 6. Option 5 Backup to User Specified Drive
echo   Option 6 Restores FROM User Specified Drive. These are hidden as they are only used on a rare occasion and should only be used when necessary
echo   -----------------------------------------------------------------------------------------------------------------------------------------
echo.
REM This uses both robocopy and Xcopy to backup data
echo   Please ensure that this bat file is ran as the User
echo   Lack of running as the user results in errors making new Directories and exporting User Specific Registries
echo.
echo   This is a Backup Program that grabs all data from the following Folders: Lotus(if Applicable), Desktop, Documents, 
echo   Favorites, Downloads, Pictures, Videos, Music, Google Bookmarks, Outlook Signatures, Pinned Applications, Quick Access and Mapped Network Drives
echo   It will also scan the C Drive and User Profile and copy folders that are not on the "Excluded List" or are Unique Folders 
echo   For indepth understanding on what Folders are skipped in C and User Profile please by the scanner, refer to the excludedList.txt or the Data Migration Documentation
echo.
echo   Options 1 and 2 utilize OneDrive
echo   Options 3 and 4 utilize an External Drive (D:)
echo.
echo.

REM Now we can choose to either backup or restore user data
echo   Program features are displayed below:
echo.
echo   1) Backup User Data (Onedrive)
echo   2) Restore User Data (Onedrive)
echo   3) Backup User Data (External (D:) Drive)
echo   4) Restore User Data (External (D:) Drive)
echo.
REM For SPECIAL CIRUMSTANCES, use hidden options 5 and 6 for a SPECIFIED DRIVE LETTER
echo.
echo   Please Enter the option number (1 through 4): 
echo.
REM Prompt for choice option
set /p choice=Option #

echo.
echo  Listing Available Profile Folders by Last Modification Date:
echo  (Typically the 1st Employee Number shown is the Desired User Profile)
echo. 
REM This shows the Tech the current folders from most recently modified in descending order
dir C:\Users\ /A:D /O:-D /B
REM Showing the Tech the amount of free space on the C Drive
echo  Free C Drive Disk Space:
dir C:\Users|find "bytes free"
REM Show available disk space on either D or E Drive if applicable 
REM Will only check for D and E as this is standard external drive lettering
if exist "D:\" (
echo  Free External D Drive Disk Space:
dir D:\|find "bytes free"
)
if exist "E:\" (
echo  Free External E Drive Disk Space:
dir E:\|find "bytes free"
)
echo.
set /p USERID=Enter the Employee Number of targeted User:
echo.

REM Set our variable to do a complete copy of the end user's profile data
set profileExempt=/XD "C:\Users\%USERID%\Desktop" "C:\Users\%USERID%\Documents" "C:\Users\%USERID%\Favorites" "C:\Users\%USERID%\Downloads" "C:\Users\%USERID%\Pictures" "C:\Users\%USERID%\Videos" "C:\Users\%USERID%\Music" "C:\Users\%USERID%\Contacts" "C:\Users\%USERID%\Saved Games" "C:\Users\%USERID%\Links" "C:\Users\%USERID%\OneDrive" "C:\Users\%USERID%\OneDrive - Underwriters Laboratories" "C:\Users\%USERID%\Underwriters Laboratories" "C:\Users\%USERID%\AppData" "C:\Users\%USERID%\Application Data" "C:\Users\%USERID%\Cookies" "C:\Users\%USERID%\IntelGraphicsProfile" "C:\Users\%USERID%\Local Settings" "C:\Users\%USERID%\My Documents" "C:\Users\%USERID%\NetHood" "C:\Users\%USERID%\PrintHood" "C:\Users\%USERID%\Recent" "C:\Users\%USERID%\SendTo" "C:\Users\%USERID%\Start Menu" "C:\Users\%USERID%\Templates"      

REM branch to the Restore label if needed
if %choice%==2 goto Restore

REM branch to external storage backup 
if %choice%==3 goto External_Backup

REM branch to external Restore
if %choice%==4 goto External_Restore

REM branch to hidden options if needed, these will be listed if asked for (for now just keep them hidden for ease of Technical Use)
REM branch to Specific Drive Letter Backup
if %choice%==5 goto Specific_Backup

REM branch to Specific Drive Letter Restore
if %choice%==6 goto Specific_Restore

echo   All the data will be stored under "DataBackup"
echo   Making SubDirectories in OneDrive......
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup"

REM Check C Drive for Lotus Folder, this way no need to prompt if Lotus Notes is needed
if exist "%src%:\Lotus\" (

REM Make directories and copy folder(s)
echo.
echo   Making Lotus Subdirectory in OneDrive...
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Lotus"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Lotus\Notes"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Lotus\Notes\Data"

echo   Copying Lotus Notes Files...
robocopy "%src%:\Lotus\Notes\Data" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Lotus\Notes\Data" %roboOP% /log:"%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Backup_Log.txt"

Xcopy "%src%:\Lotus\Notes\notes.ini" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Lotus\Notes" /Y
) else (
echo.
echo   No Lotus Folder Found, continuing to Desktop...
)

REM *********************************************************************************************************************************************************************
:Standard
set backupLog=/log+:"%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Backup_Log.txt"
 
echo   Beginning copy proccess, please wait till completed prompt is displayed
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\C_Drive"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Desktop"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Documents"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Favorites"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Downloads"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Pictures"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Videos"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Music"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Google Bookmarks"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Edge Bookmarks"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Quick Launch"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Registry"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Quick Access"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Profile Folders"
REM All below are APPDATA Requests
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\OneNote Local"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\OneNote Roaming"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Excel"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Outlook"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\PowerPoint"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Signatures"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Spelling"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Teams Backgrounds"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Word"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Windows Themes"
mkdir "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Templates"
echo.

REM This the beginning of the robocopy process
REM need to take account of either appending log file or overwriting, so see if the Lotus Folder exists again
echo   Copying Desktop.....
if exist "%src%:\Lotus\" (
goto append
)
robocopy "%src%:\Users\%USERID%\Desktop" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Desktop" %roboOP% /log:"%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Backup_Log.txt"
GOTO continue
:append
robocopy "%src%:\Users\%USERID%\Desktop" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Desktop" %roboOP% %backupLog%

:continue
echo.
echo  Copying Documents...
robocopy "%src%:\Users\%USERID%\Documents" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Documents" %roboOP% %backupLog%
echo.
echo  Copying Favorites...
robocopy "%src%:\Users\%USERID%\Favorites" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Favorites" %roboOP% %backupLog%
echo.
echo  Copying Downloads...
robocopy "%src%:\Users\%USERID%\Downloads" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Downloads" %roboOP% %backupLog%
echo.
echo  Copying Pictures...
robocopy "%src%:\Users\%USERID%\Pictures" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Pictures" %roboOP% %backupLog%
echo.
echo  Copying Videos...
robocopy "%src%:\Users\%USERID%\Videos" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Videos" %roboOP% %backupLog%
echo.
echo  Copying Music...
robocopy "%src%:\Users\%USERID%\Music" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Music" %roboOP% %backupLog%
echo.
echo  Copying Google Bookmarks...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Google Bookmarks" /Y /Q
echo.
echo  Copying Microsoft Edge Bookmarks...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Edge Bookmarks" /Y /Q

REM Copy process of AppData, we will use xcopy to ensure files are copied
echo.
echo  Copying OneNote AppData (Local and Roaming)...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Microsoft\OneNote" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\OneNote Local" %xcopyOP%
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\OneNote" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\OneNote Roaming" %xcopyOP%
echo.
echo  Copying Excel AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Excel" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Excel" %xcopyOP%
echo.
echo  Copying Outlook AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Outlook" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Outlook" %xcopyOP%
echo.
echo  Copying PowerPoint AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\PowerPoint" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\PowerPoint" %xcopyOP%
echo.
echo  Copying Outlook Signatures...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Signatures" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Signatures" %xcopyOP%
echo.
echo  Copying Spelling AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Spelling" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Spelling" %xcopyOP%
echo.
echo  Copying Teams Backgroud AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Teams\Backgrounds" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Teams Backgrounds" %xcopyOP%
echo.
echo  Copying Word AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Word" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Word" %xcopyOP%
echo.
echo  Copying Windows Themes AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\Themes" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Windows Themes" %xcopyOP%
echo.
echo  Copying Microsoft Templates AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Templates" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Templates" %xcopyOP%
echo.
echo  Copying Quick Access...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\recent" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Quick Access" %xcopyOP%

REM echo. 
REM echo   Copying Desktop Wallpaper...
REM robocopy "%src%:\Windows\Web" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Wallpaper" /E /R:2 /W:0 /MIR /NFL /NDL /V /TS /FP /log+:"%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Backup_Log.txt"

echo.
echo  Copying Pinned Applications...
robocopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Quick Launch" %roboOP% %backupLog%
REM Registry Exporting, Desktop Wallpaper registry is just not worth debuggin so removed 4/1/22
REM Testing Desktop Wallpaper registry again 4/14/22
echo.
echo  Exporting Task Bar Registry File...
reg export  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Registry\Taskbar_BackUp.reg" /y
echo.
echo  Exporting Mapped Network Drives File....
reg export "HKEY_CURRENT_USER\Network" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Registry\Network_Drives.reg" /y
echo.
echo  Exporting OneNote Registry File....
reg export "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\OneNote\OpenNotebooks" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Registry\OneNote.reg" /y

REM Add OneNote Registry Key Export here after it is working properly!

REM echo   Exporting Desktop Settings...
REM reg export  "HKEY_CURRENT_USER\Control Panel\Desktop" "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Registry\Desktop_Backup.reg" /y
REM echo.

REM echo.
REM echo  Copying C Drive folders
REM robocopy %src%:\ "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\C_Drive" %roboOP% /A-:SH %cExempt% %backupLog%
echo.
echo  Copying Profile folders
robocopy %src%:\Users\%USERID%\ "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Profile Folders" %roboOP% /A-:SH %profileExempt% %backupLog% 

REM Branch to our backup_end statement
GOTO backup_end

REM *********************************************************************************************************************************************************************
:Restore
REM Beginning Restore Process
set restoreLog=/log+:"%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Restore_Log.txt"

if exist "%src%:\Lotus\" (
echo.
echo  Restoring Lotus Notes....
Xcopy "%src%:\Users\%USERID%\" "%src%:\Lotus\Notes\Data" %xcopyOP%
Xcopy "%src%:\DataBackup\%USERID%\Lotus\Notes\notes.ini" "%src%:\Lotus\Notes" %xcopyOP%
) else (
echo.
echo  No Lotus Folder Found, continuing to Desktop...
)

echo.
echo  Restoring Desktop...
robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Desktop" "%src%:\Users\%USERID%\Desktop" %roboOP% %restoreLog%
echo.
echo  Restoring Documents...
robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Documents" "%src%:\Users\%USERID%\Documents" %roboOP% %restoreLog%
echo.
echo  Restoring Favorites...
robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Favorites" "%src%:\Users\%USERID%\Favorites" %roboOP% %restoreLog%
echo.
echo  Restoring Downloads...
robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Downloads" "%src%:\Users\%USERID%\Downloads" %roboOP% %restoreLog%
echo.
echo  Restoring Pictures...
robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Pictures" "%src%:\Users\%USERID%\Pictures" %roboOP% %restoreLog%
echo.
echo  Restoring Videos...
robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Videos" "%src%:\Users\%USERID%\Videos" %roboOP% %restoreLog%
echo.
echo  Restoring Music...
robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Music" "%src%:\Users\%USERID%\Music" %roboOP% %restoreLog%
echo.
echo  Restoring Google Bookmarks...
robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Google Bookmarks" "%src%:\Users\%USERID%\AppData\Local\Google\Chrome\User Data\Default"  %roboOP% %restoreLog%
echo.
echo  Restoring Microsoft Edge Bookmarks...
robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Edge Bookmarks" "%src%:\Users\%USERID%\AppData\Local\Microsoft\Edge\User Data\Default"  %roboOP% %restoreLog%

REM Restore Process of all AppData, implementing Xcopy downside is no log file is being created
echo.
echo  Restoring OneNote AppData (Local and Roaming)...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\OneNote Local" "%src%:\Users\%USERID%\AppData\Local\Microsoft\OneNote" %xcopyOP%
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\OneNote Roaming" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\OneNote" %xcopyOP%
echo.
echo  Restoring Excel AppData...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Excel" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Excel" %xcopyOP%
echo.
echo  Restoring Outlook AppData...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Outlook" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Outlook" %xcopyOP%
echo.
echo  Restoring PowerPoint AppData...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\PowerPoint" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\PowerPoint" %xcopyOP%
echo.
echo  Restoring Outlook Signatures...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Signatures" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Signatures" %xcopyOP%
echo.
echo  Restoring Spelling AppData...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Spelling" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Spelling" %xcopyOP%
echo.
echo  Restoring Teams Backgroud AppData...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Teams Backgrounds" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Teams\Backgrounds" %xcopyOP%
echo.
echo  Restoring Word AppData...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Word" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Word" %xcopyOP%
echo.
echo  Restoring Windows Themes AppData...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Windows Themes" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\Themes" %xcopyOP%
echo.
echo  Restoring Microsoft Templates AppData...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\AppData Folders\Templates" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Templates" %xcopyOP%
echo.
echo  Restoring Quick Access...
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Quick Access" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\recent" %xcopyOP%
echo.
REM echo  Restoring Profile Folders
REM robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Profile Folders" %src%:\Users\%USERID%\ %roboOP% %restoreLog%
REM echo.
REM Restoring registry files
REM OneDrive does not play nice with hidden or registry files
REM In order to restore these, you MUST copy these files somewhere on the local C drive
REM this should fix the issue with the OneDrive restore
REM need to make new temp directories in local C drive
echo  Creating temp directories for registers and needed files
mkdir "%src%:\Users\%USERID%\Temp_Quick Launch"
mkdir "%src%:\Users\%USERID%\Temp_Reg"
REM mkdir "%src%:\Users\%USERID%\Temp_Wallpaper"

REM next copy registry files to Temp_Reg folder
Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Quick Launch" "%src%:\Users\%USERID%\Temp_Quick Launch" %xcopyOP%

REM Xcopy /Q /E /V /C /I /Y "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Wallpaper" "%src%:\Users\%USERID%\Temp_Wallpaper"

Xcopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Registry" "%src%:\Users\%USERID%\Temp_Reg" %xcopyOP%

REM Now we can restore the system without OneDrive robocopy issues
REM using Xcopy to replace all existing files
echo.
echo  Importing Task Bar Registry File...
regedit /s "%src%:\Users\%USERID%\Temp_Reg\Taskbar_BackUp.reg"
echo.
echo  Importing Mapped Network Drived File...
regedit /s "%src%:\Users\%USERID%\Temp_Reg\Network_Drives.reg"
echo.
echo  Importing OneNote Registry File...
regedit /s "%src%:\Users\%USERID%\Temp_Reg\OneNote.reg"
echo.
echo  Restoring Pinned Applications...
Xcopy "%src%:\Users\%USERID%\Temp_Quick Launch" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch" %xcopyOP%
echo.

REM echo   Restoring Desktop Wallpaper...
REM Xcopy /Q /E /V /C /I /Y "%src%:\Users\%USERID%\Temp_Wallpaper" "%src%:\Windows\Web"
REM echo.
REM echo   Importing Desktop Settings...
REM regedit /s "%src%:\Users\%USERID%\Temp_Reg\Desktop_backup.reg"

REM Delete temporary directories : /s remove entire directory and subfolder, /q does not ask for permission
rmdir /S /Q "%src%:\Users\%USERID%\Temp_Quick Launch"
rmdir /S /Q "%src%:\Users\%USERID%\Temp_Reg"
REM rmdir /S /Q "%src%:\Users\%USERID%\Temp_Wallpaper"

REM echo   Restoring C Drive Folders
REM robocopy "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\C_Drive" %src%:\ %roboOP% %restoreLog%
REM echo.
REM Branch to restore_end
GOTO restore_end

REM *********************************************************************************************************************************************************************
:External_Backup
REM Check if there is more than one drive installed on the system
REM Logic behind this is to that E can only exist if there is already a D drive in play
REM This should cover most cases, IF requested I will create a hidden option to declare a new variable
if exist "E:\" (
REM Prompt Tech to Specify Drive Letter
echo.
echo  An E drive is detected, please confirm the drive letter of External Drive to avoid program failure...
echo.
set /p newDST=Enter External Drive Letter:
REM Unfortunatley we cannot reassign variables in batch, so we need to make a check to make another possability of
REM the drive letter changing, so we will use testDST to determine what path our program takes
REM set our testDST to true so we can implement new destination
set testDST=true
goto DriveCheckDone
)
REM No E drive detected so we are ASSUMING that the external drive is Letter D, continuing to default backup with dst being D
set testDST=false
goto DriveCheckDone

:DriveCheckDone
REM To help the ease of the program, add labels so we can just jump to set of commands
if %testDST%==true goto NEWDrive
if %testDST%==false goto SAMEDrive

REM *********************************************************************************************************************************************************************************************************
REM This takes care of both D and E drives being detected, can be easily modified to accomodate multiple drives detected and lets the Tech Specify
REM We are assuming that D and E are either external drives or the user could have two drives in their system so the program will detect this and prompt to specify destination Drive Letter
REM we will use the newDST variable here since we cannot redeclare variables
:NEWDrive
REM set our log variable
set externalBackupLog=/log+:"%newDST%:\DataBackup\%USERID%\Backup_Log.txt"

echo  All the data will be stored under "%newDST%:\DataBackup\%USERID%"
echo  Making SubDirectories in External Drive.....
mkdir "%newDST%:\DataBackup"
mkdir "%newDST%:\DataBackup\%USERID%"

REM Check C Drive for Lotus Folder
if exist "%src%:\Lotus\" (

REM Make directories and copy folder(s)
echo  Making Lotus Subdirectory...
mkdir "%newDST%:\DataBackup\%USERID%\Lotus"
mkdir "%newDST%:\DataBackup\%USERID%\Lotus\Notes"
mkdir "%newDST%:\DataBackup\%USERID%\Lotus\Notes\Data"

echo  Copying Lotus Notes Files...
robocopy "%src%:\Lotus\Notes\Data" "%newDST%:\DataBackup\%USERID%\Lotus\Notes\Data" %roboOP% /log:"%newDST%:\DataBackup\%USERID%\Backup_Log.txt"

Xcopy "%src%:\Lotus\Notes\notes.ini" "%newDST%:\DataBackup\%USERID%\Lotus\Notes" %xcopyOP%
) else (
echo.
echo   No Lotus Folder Found, continuing to Desktop...
)

:External_Standard
echo  Beginning copy proccess, please wait till completed prompt is displayed
REM Making all directories
mkdir "%newDST%:\DataBackup\%USERID%\C_Drive"
mkdir "%newDST%:\DataBackup\%USERID%\Desktop"
mkdir "%newDST%:\DataBackup\%USERID%\Documents"
mkdir "%newDST%:\DataBackup\%USERID%\Favorites"
mkdir "%newDST%:\DataBackup\%USERID%\Downloads"
mkdir "%newDST%:\DataBackup\%USERID%\Pictures"
mkdir "%newDST%:\DataBackup\%USERID%\Videos"
mkdir "%newDST%:\DataBackup\%USERID%\Music"
mkdir "%newDST%:\DataBackup\%USERID%\Google Bookmarks"
mkdir "%newDST%:\DataBackup\%USERID%\Edge Bookmarks"
mkdir "%newDST%:\DataBackup\%USERID%\Quick Launch"
mkdir "%newDST%:\DataBackup\%USERID%\Registry"
mkdir "%newDST%:\DataBackup\%USERID%\Quick Access"
mkdir "%newDST%:\DataBackup\%USERID%\Profile Folders"
REM All below are APPDATA Requests
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\OneNote Local"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\OneNote Roaming"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\Excel"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\Outlook"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\PowerPoint"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\Signatures"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\Spelling"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\Teams Backgrounds"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\Word"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\Windows Themes"
mkdir "%newDST%:\DataBackup\%USERID%\AppData Folders\Templates"
echo.

REM This the beginning of the robocopy process
REM need to take account of either appending log file or overwriting, so see if the Lotus Folder exists again
echo   Copying Desktop...
if exist "%src%:\Lotus\" (
goto append_external
)
robocopy "%src%:\Users\%USERID%\Desktop" "%newDST%:\DataBackup\%USERID%\Desktop" %roboOP% %externalBackupLog%

GOTO continue_ext

:append_external
robocopy "%src%:\Users\%USERID%\Desktop" "%newDST%:\DataBackup\%USERID%\Desktop" %roboOP% %externalBackupLog%

:continue_ext
echo.
echo  Copying Documents...
robocopy "%src%:\Users\%USERID%\Documents" "%newDST%:\DataBackup\%USERID%\Documents" %roboOP% %externalBackupLog%
echo.
echo  Copying Favorites...
robocopy "%src%:\Users\%USERID%\Favorites" "%newDST%:\DataBackup\%USERID%\Favorites" %roboOP% %externalBackupLog%
echo.
echo  Copying Downloads...
robocopy "%src%:\Users\%USERID%\Downloads" "%newDST%:\DataBackup\%USERID%\Downloads" %roboOP% %externalBackupLog%
echo.
echo  Copying Pictures...
robocopy "%src%:\Users\%USERID%\Pictures" "%newDST%:\DataBackup\%USERID%\Pictures" %roboOP% %externalBackupLog%
echo.
echo  Copying Videos...
robocopy "%src%:\Users\%USERID%\Videos" "%newDST%:\DataBackup\%USERID%\Videos" %roboOP% %externalBackupLog%
echo.
echo  Copying Music...
robocopy "%src%:\Users\%USERID%\Music" "%newDST%:\DataBackup\%USERID%\Music" %roboOP% %externalBackupLog%
echo.
echo  Copying Google Bookmarks...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" "%newDST%:\DataBackup\%USERID%\Google Bookmarks" /Y /Q /I
echo.
echo  Copying Microsoft Edge Bookmarks...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" "%newDST%:\DataBackup\%USERID%\Edge Bookmarks" /Y /Q /I

REM Copy process of AppData, we will use Xcopy since these are AppData and may have hidden files
echo.
echo  Copying OneNote AppData (Local and Roaming)...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Microsoft\OneNote" "%newDST%:\DataBackup\%USERID%\AppData Folders\OneNote Local" %xcopyOP%
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\OneNote" "%newDST%:\DataBackup\%USERID%\AppData Folders\OneNote Roaming" %xcopyOP%
echo.
echo  Copying Excel AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Excel" "%newDST%:\DataBackup\%USERID%\AppData Folders\Excel" %xcopyOP%
echo.
echo  Copying Outlook AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Outlook" "%newDST%:\DataBackup\%USERID%\AppData Folders\Outlook" %xcopyOP%
echo.
echo  Copying PowerPoint AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\PowerPoint" "%newDST%:\DataBackup\%USERID%\AppData Folders\PowerPoint" %xcopyOP%
echo.
echo  Copying Outlook Signatures...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Signatures" "%newDST%:\DataBackup\%USERID%\AppData Folders\Signatures" %xcopyOP%
echo.
echo  Copying Spelling AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Spelling" "%newDST%:\DataBackup\%USERID%\AppData Folders\Spelling" %xcopyOP%
echo.
echo  Copying Teams Backgroud AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Teams\Backgrounds" "%newDST%:\DataBackup\%USERID%\AppData Folders\Teams Backgrounds" %xcopyOP%
echo.
echo  Copying Word AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Word" "%newDST%:\DataBackup\%USERID%\AppData Folders\Word" %xcopyOP%
echo.
echo  Copying Windows Themes AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\Themes" "%newDST%:\DataBackup\%USERID%\AppData Folders\Windows Themes" %xcopyOP%
echo.
echo  Copying Microsoft Templates AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Templates" "%newDST%:\DataBackup\%USERID%\AppData Folders\Templates" %xcopyOP%
echo.
echo  Copying Quick Access...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\recent" "%newDST%:\DataBackup\%USERID%\Quick Access" %xcopyOP%

REM Skip for now, will look at later
REM echo. 
REM echo   Copying Desktop Wallpaper...
REM robocopy "%src%:\Windows\Web" "%newDST%:\DataBackup\%USERID%\Wallpaper" /E /R:2 /W:0 /MIR /NFL /NDL /V /TS /FP /log+:"%newDST%:\DataBackup\%USERID%\Backup_Log.txt"
echo.
echo  Copying Pinned Applications...
robocopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch" "%newDST%:\DataBackup\%USERID%\Quick Launch" %roboOP% %externalBackupLog%
echo.
REM Registry Importing
echo  Exporting Task Bar Registry File...
reg export  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" "%newDST%:\DataBackup\%USERID%\Registry\Taskbar_BackUp.reg" /y
echo.
echo  Exporting OneNote Registry File....
reg export "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\OneNote\OpenNotebooks" "%newDST%:\DataBackup\%USERID%\Registry\OneNote.reg" /y
echo.
echo  Exporting Mapped Network Drives File....
reg export "HKEY_CURRENT_USER\Network" "%newDST%:\DataBackup\%USERID%\Registry\Network_Drives.reg" /y

REM Still does not work, follow up when you have some free time 4/18/22
REM echo   Exporting Desktop Settings...
REM reg export  "HKEY_CURRENT_USER\Control Panel\Desktop" "%newDST%:\DataBackup\%USERID%\Registry\Desktop_Backup.reg" /y
REM echo.

echo.
echo  Copying C Drive folders
robocopy %src%:\ "%newDST%:\DataBackup\%USERID%\C_Drive" %roboOP% /A-:SH %cExempt% %externalBackupLog% 
echo.
echo  Copying Profile folders
robocopy %src%:\Users\%USERID%\ "%newDST%:\DataBackup\%USERID%\Profile Folders" %roboOP% /A-:SH %profileExempt% %externalBackupLog% 

GOTO external_backup_end

REM *******************************************************************************************************************************************************************************************************************
REM This will be our DEFAULT D drive backup case
:SAMEDrive
REM set our log variable
set externalBackupLog=/log+:"%dst%:\DataBackup\%USERID%\Backup_Log.txt"

echo  All the data will be stored under "%dst%:\DataBackup\%USERID%"
echo  Making SubDirectories in External Drive.....
mkdir "%dst%:\DataBackup"
mkdir "%dst%:\DataBackup\%USERID%"

REM Check C Drive for Lotus Folder
if exist "%src%:\Lotus\" (

REM Make directories and copy folder(s)
echo  Making Lotus Subdirectory...
mkdir "%dst%:\DataBackup\%USERID%\Lotus"
mkdir "%dst%:\DataBackup\%USERID%\Lotus\Notes"
mkdir "%dst%:\DataBackup\%USERID%\Lotus\Notes\Data"

echo  Copying Lotus Notes Files...
robocopy "%src%:\Lotus\Notes\Data" "%dst%:\DataBackup\%USERID%\Lotus\Notes\Data" %roboOP% /log:"%dst%:\DataBackup\%USERID%\Backup_Log.txt"

Xcopy "%src%:\Lotus\Notes\notes.ini" "%dst%:\DataBackup\%USERID%\Lotus\Notes" %xcopyOP%
) else (
echo.
echo  No Lotus Folder Found, continuing to Desktop...
)

:External_Standard
echo  Beginning copy proccess, please wait till completed prompt is displayed
REM Making all directories
mkdir "%dst%:\DataBackup\%USERID%\C_Drive"
mkdir "%dst%:\DataBackup\%USERID%\Desktop"
mkdir "%dst%:\DataBackup\%USERID%\Documents"
mkdir "%dst%:\DataBackup\%USERID%\Favorites"
mkdir "%dst%:\DataBackup\%USERID%\Downloads"
mkdir "%dst%:\DataBackup\%USERID%\Pictures"
mkdir "%dst%:\DataBackup\%USERID%\Videos"
mkdir "%dst%:\DataBackup\%USERID%\Music"
mkdir "%dst%:\DataBackup\%USERID%\Google Bookmarks"
mkdir "%dst%:\DataBackup\%USERID%\Edge Bookmarks"
mkdir "%dst%:\DataBackup\%USERID%\Quick Launch"
mkdir "%dst%:\DataBackup\%USERID%\Registry"
mkdir "%dst%:\DataBackup\%USERID%\Quick Access"
mkdir "%dst%:\DataBackup\%USERID%\Profile Folders"
REM All below are APPDATA Requests
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders"
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders\OneNote Local"
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders\OneNote Roaming"
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders\Excel"
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders\Outlook"
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders\PowerPoint"
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders\Signatures"
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders\Spelling"
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders\Teams Backgrounds"
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders\Word"
mkdir "%dst%:\DataBackup\%USERID%\AppData Folders\Windows Themes"
echo.

REM This the beginning of the robocopy process
REM need to take account of either appending log file or overwriting, so see if the Lotus Folder exists again
echo  Copying Desktop...
if exist "%src%:\Lotus\" (
goto append_external
)
robocopy "%src%:\Users\%USERID%\Desktop" "%dst%:\DataBackup\%USERID%\Desktop" %roboOP% %externalBackupLog%

GOTO continue_ext

:append_external
robocopy "%src%:\Users\%USERID%\Desktop" "%dst%:\DataBackup\%USERID%\Desktop" %roboOP% %externalBackupLog%

:continue_ext
echo.
echo  Copying Documents...
robocopy "%src%:\Users\%USERID%\Documents" "%dst%:\DataBackup\%USERID%\Documents" %roboOP% %externalBackupLog%
echo.
echo  Copying Favorites...
robocopy "%src%:\Users\%USERID%\Favorites" "%dst%:\DataBackup\%USERID%\Favorites" %roboOP% %externalBackupLog%
echo.
echo  Copying Downloads...
robocopy "%src%:\Users\%USERID%\Downloads" "%dst%:\DataBackup\%USERID%\Downloads" %roboOP% %externalBackupLog%
echo.
echo  Copying Pictures...
robocopy "%src%:\Users\%USERID%\Pictures" "%dst%:\DataBackup\%USERID%\Pictures" %roboOP% %externalBackupLog%
echo.
echo  Copying Videos...
robocopy "%src%:\Users\%USERID%\Videos" "%dst%:\DataBackup\%USERID%\Videos" %roboOP% %externalBackupLog%
echo.
echo  Copying Music...
robocopy "%src%:\Users\%USERID%\Music" "%dst%:\DataBackup\%USERID%\Music" %roboOP% %externalBackupLog%
echo.
echo  Copying Google Bookmarks...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" "%dst%:\DataBackup\%USERID%\Google Bookmarks" /Y /Q /I
echo.
echo  Copying Microsoft Edge Bookmarks...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" "%dst%:\DataBackup\%USERID%\Edge Bookmarks" /Y /Q /I

REM Beginning of AppData Copying Process
echo.
echo  Copying OneNote AppData (Local and Roaming)...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Microsoft\OneNote" "%dst%:\DataBackup\%USERID%\AppData Folders\OneNote Local" %xcopyOP%
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\OneNote" "%dst%:\DataBackup\%USERID%\AppData Folders\OneNote Roaming" %xcopyOP%
echo.
echo  Copying Excel AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Excel" "%dst%:\DataBackup\%USERID%\AppData Folders\Excel" %xcopyOP%
echo.
echo  Copying Outlook AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Outlook" "%dst%:\DataBackup\%USERID%\AppData Folders\Outlook" %xcopyOP%
echo.
echo  Copying PowerPoint AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\PowerPoint" "%dst%:\DataBackup\%USERID%\AppData Folders\PowerPoint" %xcopyOP%
echo.
echo  Copying Outlook Signatures...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Signatures" "%dst%:\DataBackup\%USERID%\AppData Folders\Signatures" %xcopyOP%
echo.
echo  Copying Spelling AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Spelling" "%dst%:\DataBackup\%USERID%\AppData Folders\Spelling" %xcopyOP%
echo.
echo  Copying Teams Backgroud AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Teams\Backgrounds" "%dst%:\DataBackup\%USERID%\AppData Folders\Teams Backgrounds" %xcopyOP%
echo.
echo  Copying Word AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Word" "%dst%:\DataBackup\%USERID%\AppData Folders\Word" %xcopyOP%
echo.
echo  Copying Windows Themes AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\Themes" "%dst%:\DataBackup\%USERID%\AppData Folders\Windows Themes" %xcopyOP%
echo.
echo  Copying Microsoft Templates AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Templates" "%dst%:\DataBackup\%USERID%\AppData Folders\Templates" %xcopyOP%
echo.
echo  Copying Quick Access...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\recent" "%dst%:\DataBackup\%USERID%\Quick Access" %xcopyOP%


REM Skip for now, will look at later
REM echo. 
REM echo   Copying Desktop Wallpaper...
REM robocopy "%src%:\Windows\Web" "%dst%:\DataBackup\%USERID%\Wallpaper" /E /R:2 /W:0 /MIR /NFL /NDL /V /TS /FP /log+:"%dst%:\DataBackup\%USERID%\Backup_Log.txt"

echo.
echo  Copying Pinned Applications...
robocopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch" "%dst%:\DataBackup\%USERID%\Quick Launch" %roboOP% %externalBackupLog%
REM Will try xcopy to see if it fixes blank edge issue as well as not pinning Google Chrome\User
REM Result: xcopy makes it even worse, 
REM Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch" "%dst%:\DataBackup\%USERID%\Quick Launch" %xcopyOP%

echo.
REM Registry Importing
echo   Exporting Task Bar Registry File...
reg export  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" "%dst%:\DataBackup\%USERID%\Registry\Taskbar_BackUp.reg" /y
echo.
echo   Exporting Mapped Network Drives File....
reg export "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\OneNote\OpenNotebooks" "%dst%:\DataBackup\%USERID%\Registry\OneNote.reg" /y
echo.
echo   Exporting Mapped Network Drives File....
reg export "HKEY_CURRENT_USER\Network" "%dst%:\DataBackup\%USERID%\Registry\Network_Drives.reg" /y

REM Still does not work, follow up when you have some free time 4/18/22
REM echo   Exporting Desktop Settings...
REM reg export  "HKEY_CURRENT_USER\Control Panel\Desktop" "%dst%:\DataBackup\%USERID%\Registry\Desktop_Backup.reg" /y
REM echo.

echo.
echo  Copying C Drive folders
robocopy %src%:\ "%dst%:\DataBackup\%USERID%\C_Drive" %roboOP% /A-:SH %cExempt% %externalBackupLog% 
echo.
echo  Copying Profile folders
robocopy %src%:\Users\%USERID%\ "%dst%:\DataBackup\%USERID%\Profile Folders" %roboOP% /A-:SH %profileExempt% %externalBackupLog% 
REM Branch to external_backup_end
GOTO external_backup_end

REM *********************************************************************************************************************************************************************
:External_Restore
REM Beginning Restore Process
REM set our restore log variable
set externalRestoreLog=/log+:"%dst%:\DataBackup\%USERID%\Restore_Log.txt" 

if exist "%src%:\Lotus\" (
echo.
echo  Restoring Lotus Notes....
Xcopy "%dst%:\DataBackup\%USERID%\Lotus\Notes\Data" "%src%:\Lotus\Notes\Data" %xcopyOP%
Xcopy "%dst%:\DataBackup\%USERID%\Lotus\Notes\notes.ini" "%src%:\Lotus\Notes" %xcopyOP%
) else (
echo.
echo  No Lotus Folder Found, continuing to Desktop...
)
echo.
echo  Restoring Desktop.....
robocopy "%dst%:\DataBackup\%USERID%\Desktop" "%src%:\Users\%USERID%\Desktop" %roboOP% /log:"%dst%:\DataBackup\%USERID%\Restore_Log.txt"
echo.
echo  Restoring Documents...
robocopy "%dst%:\DataBackup\%USERID%\Documents" "%src%:\Users\%USERID%\Documents" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Favorites...
robocopy "%dst%:\DataBackup\%USERID%\Favorites" "%src%:\Users\%USERID%\Favorites" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Downloads...
robocopy "%dst%:\DataBackup\%USERID%\Downloads" "%src%:\Users\%USERID%\Downloads" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Pictures...
robocopy "%dst%:\DataBackup\%USERID%\Pictures" "%src%:\Users\%USERID%\Pictures" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Videos...
robocopy "%dst%:\DataBackup\%USERID%\Videos" "%src%:\Users\%USERID%\Videos" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Music...
robocopy "%dst%:\DataBackup\%USERID%\Music" "%src%:\Users\%USERID%\Music" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Google Bookmarks...
robocopy "%dst%:\DataBackup\%USERID%\Google Bookmarks" "%src%:\Users\%USERID%\AppData\Local\Google\Chrome\User Data\Default" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Microsoft Edge Bookmarks...
robocopy "%dst%:\DataBackup\%USERID%\Edge Bookmarks" "%src%:\Users\%USERID%\AppData\Local\Microsoft\Edge\User Data\Default" %roboOP% %externalRestoreLog%
REM Beginning of Restoring AppData
echo.
echo  Restoring OneNote AppData (Local and Roaming)...
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\OneNote Local" "%src%:\Users\%USERID%\AppData\Local\Microsoft\OneNote" %xcopyOP%
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\OneNote Roaming" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\OneNote" %xcopyOP%
echo.
echo  Restoring Excel AppData...
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\Excel" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Excel" %xcopyOP%
echo.
echo  Restoring Outlook AppData...
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\Outlook" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Outlook" %xcopyOP%
echo.
echo  Restoring PowerPoint AppData...
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\PowerPoint" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\PowerPoint" %xcopyOP%
echo.
echo  Restoring Outlook Signatures...
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\Signatures" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Signatures" %xcopyOP%
echo.
echo  Restoring Spelling AppData...
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\Spelling" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Spelling" %xcopyOP%
echo.
echo  Restoring Teams Backgroud AppData...
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\Teams Backgrounds" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Teams\Backgrounds" %xcopyOP%
echo.
echo  Restoring Word AppData...
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\Word" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Word" %xcopyOP%
echo.
echo  Restoring Windows Themes AppData...
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\Windows Themes" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\Themes" %xcopyOP%
echo.
echo  Restoring Microsoft Templates AppData...
Xcopy "%dst%:\DataBackup\%USERID%\AppData Folders\Templates" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Templates" %xcopyOP%
echo.
echo  Restoring Quick Access...
Xcopy "%dst%:\DataBackup\%USERID%\Quick Access" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\recent" %xcopyOP%
echo.
echo  Restoring Profile Folders
echo  (If you see Access denied prompts, please ignore this as it is skipping unnecessary Admin program files)
Xcopy "%dst%:\DataBackup\%USERID%\Profile Folders" %src%:\Users\%USERID%\ %xcopyOP%
echo.
REM Due to local credential issues, only option it to restore this manually
REM echo   Restoring C Drive Folders...
REM Xcopy "%dst%:\DataBackup\%USERID%\C_Drive" %src%:\ %xcopyOP%
REM echo.
echo  Restoring Registry Files
echo.
echo  Importing Task Bar Registry File...
regedit /s "%dst%:\DataBackup\%USERID%\Registry\Taskbar_BackUp.reg"
echo.
echo  Importing Mapped Network Drived File...
regedit /s "%dst%:\DataBackup\%USERID%\Registry\OneNote.reg"
echo.
echo  Importing Mapped Network Drived File...
regedit /s "%dst%:\DataBackup\%USERID%\Registry\Network_Drives.reg"
echo.
echo  Restoring Pinned Applications...
robocopy "%dst%:\DataBackup\%USERID%\Quick Launch" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch" %roboOP% %externalRestoreLog%
REM Testing xcopy to see if it gets rid of Edge and Google Chrome not being pinned
REM xcopy "%dst%:\DataBackup\%USERID%\Quick Launch" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch" %xcopyOP%

REM Still does not work, follow up when you have some free time 4/18/22
REM echo.
REM echo   Restoring Desktop Wallpaper...
REM Xcopy /Q /E /V /C /I /Y "%dst%:\DataBackup\%USERID%\Wallpaper" "%src%:\Windows\Web"
REM echo.
REM echo   Importing Desktop Settings...
REM regedit /s "%dst%:\DataBackup\%USERID%\Registry\Desktop_backup.reg"

REM Branch to external_restore_end
GOTO external_restore_end
REM *********************************************************************************************************************************************************************
:Specific_Backup
REM This is Hidden Feature Number 5
REM This is in place in case that the drive letter is not D OR E, this way you can set it manually and not panic
echo.
echo  This is a Hidden Option that should be used when needed to backup to a Specific Drive
echo  Please confirm the Specified Drive Letter to avoid program failure...
echo.
set /p spDST=Enter Drive Letter:
REM set our log variable
set externalBackupLog=/log+:"%spDST%:\DataBackup\%USERID%\Backup_Log.txt"

echo  All the data will be stored under "%spDST%:\DataBackup\%USERID%"
echo  Making SubDirectories in External Drive.....
mkdir "%spDST%:\DataBackup"
mkdir "%spDST%:\DataBackup\%USERID%"

REM Check C Drive for Lotus Folder
if exist "%src%:\Lotus\" (

REM Make directories and copy folder(s)
echo  Making Lotus Subdirectory...
mkdir "%spDST%:\DataBackup\%USERID%\Lotus"
mkdir "%spDST%:\DataBackup\%USERID%\Lotus\Notes"
mkdir "%spDST%:\DataBackup\%USERID%\Lotus\Notes\Data"

echo  Copying Lotus Notes Files...
robocopy "%src%:\Lotus\Notes\Data" "%spDST%:\DataBackup\%USERID%\Lotus\Notes\Data" %roboOP% /log:"%spDST%:\DataBackup\%USERID%\Backup_Log.txt"

Xcopy "%src%:\Lotus\Notes\notes.ini" "%spDST%:\DataBackup\%USERID%\Lotus\Notes" %xcopyOP%
) else (
echo.
echo   No Lotus Folder Found, continuing to Desktop...
)

:External_Standard
echo  Beginning copy proccess, please wait till completed prompt is displayed
REM Making all directories
mkdir "%spDST%:\DataBackup\%USERID%\C_Drive"
mkdir "%spDST%:\DataBackup\%USERID%\Desktop"
mkdir "%spDST%:\DataBackup\%USERID%\Documents"
mkdir "%spDST%:\DataBackup\%USERID%\Favorites"
mkdir "%spDST%:\DataBackup\%USERID%\Downloads"
mkdir "%spDST%:\DataBackup\%USERID%\Pictures"
mkdir "%spDST%:\DataBackup\%USERID%\Videos"
mkdir "%spDST%:\DataBackup\%USERID%\Music"
mkdir "%spDST%:\DataBackup\%USERID%\Google Bookmarks"
mkdir "%spDST%:\DataBackup\%USERID%\Edge Bookmarks"
mkdir "%spDST%:\DataBackup\%USERID%\Quick Launch"
mkdir "%spDST%:\DataBackup\%USERID%\Registry"
mkdir "%spDST%:\DataBackup\%USERID%\Quick Access"
mkdir "%spDST%:\DataBackup\%USERID%\Profile Folders"
REM All below are APPDATA Requests
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\OneNote Local"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\OneNote Roaming"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\Excel"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\Outlook"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\PowerPoint"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\Signatures"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\Spelling"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\Teams Backgrounds"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\Word"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\Windows Themes"
mkdir "%spDST%:\DataBackup\%USERID%\AppData Folders\Templates"
echo.

REM This the beginning of the robocopy process
REM need to take account of either appending log file or overwriting, so see if the Lotus Folder exists again
echo   Copying Desktop...
if exist "%src%:\Lotus\" (
goto append_external
)
robocopy "%src%:\Users\%USERID%\Desktop" "%spDST%:\DataBackup\%USERID%\Desktop" %roboOP% %externalBackupLog%

GOTO continue_ext

:append_external
robocopy "%src%:\Users\%USERID%\Desktop" "%spDST%:\DataBackup\%USERID%\Desktop" %roboOP% %externalBackupLog%

:continue_ext
echo.
echo  Copying Documents...
robocopy "%src%:\Users\%USERID%\Documents" "%spDST%:\DataBackup\%USERID%\Documents" %roboOP% %externalBackupLog%
echo.
echo  Copying Favorites...
robocopy "%src%:\Users\%USERID%\Favorites" "%spDST%:\DataBackup\%USERID%\Favorites" %roboOP% %externalBackupLog%
echo.
echo  Copying Downloads...
robocopy "%src%:\Users\%USERID%\Downloads" "%spDST%:\DataBackup\%USERID%\Downloads" %roboOP% %externalBackupLog%
echo.
echo  Copying Pictures...
robocopy "%src%:\Users\%USERID%\Pictures" "%spDST%:\DataBackup\%USERID%\Pictures" %roboOP% %externalBackupLog%
echo.
echo  Copying Videos...
robocopy "%src%:\Users\%USERID%\Videos" "%spDST%:\DataBackup\%USERID%\Videos" %roboOP% %externalBackupLog%
echo.
echo  Copying Music...
robocopy "%src%:\Users\%USERID%\Music" "%spDST%:\DataBackup\%USERID%\Music" %roboOP% %externalBackupLog%
echo.
echo  Copying Google Bookmarks...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" "%spDST%:\DataBackup\%USERID%\Google Bookmarks" /Y /Q /I
echo.
echo  Copying Microsoft Edge Bookmarks...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" "%spDST%:\DataBackup\%USERID%\Edge Bookmarks" /Y /Q /I

REM Copy process of AppData, we will use Xcopy since these are AppData and may have hidden files
echo.
echo  Copying OneNote AppData (Local and Roaming)...
Xcopy "%src%:\Users\%USERID%\AppData\Local\Microsoft\OneNote" "%spDST%:\DataBackup\%USERID%\AppData Folders\OneNote Local" %xcopyOP%
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\OneNote" "%spDST%:\DataBackup\%USERID%\AppData Folders\OneNote Roaming" %xcopyOP%
echo.
echo  Copying Excel AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Excel" "%spDST%:\DataBackup\%USERID%\AppData Folders\Excel" %xcopyOP%
echo.
echo  Copying Outlook AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Outlook" "%spDST%:\DataBackup\%USERID%\AppData Folders\Outlook" %xcopyOP%
echo.
echo  Copying PowerPoint AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\PowerPoint" "%spDST%:\DataBackup\%USERID%\AppData Folders\PowerPoint" %xcopyOP%
echo.
echo  Copying Outlook Signatures...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Signatures" "%spDST%:\DataBackup\%USERID%\AppData Folders\Signatures" %xcopyOP%
echo.
echo  Copying Spelling AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Spelling" "%spDST%:\DataBackup\%USERID%\AppData Folders\Spelling" %xcopyOP%
echo.
echo  Copying Teams Backgroud AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Teams\Backgrounds" "%spDST%:\DataBackup\%USERID%\AppData Folders\Teams Backgrounds" %xcopyOP%
echo.
echo  Copying Word AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Word" "%spDST%:\DataBackup\%USERID%\AppData Folders\Word" %xcopyOP%
echo.
echo  Copying Windows Themes AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\Themes" "%spDST%:\DataBackup\%USERID%\AppData Folders\Windows Themes" %xcopyOP%
echo.
echo  Copying Microsoft Templates AppData...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Templates" "%spDST%:\DataBackup\%USERID%\AppData Folders\Templates" %xcopyOP%
echo.
echo  Copying Quick Access...
Xcopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\recent" "%spDST%:\DataBackup\%USERID%\Quick Access" %xcopyOP%
echo.
echo  Copying Pinned Applications...
robocopy "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch" "%spDST%:\DataBackup\%USERID%\Quick Launch" %roboOP% %externalBackupLog%
echo.
REM Registry Importing
echo  Exporting Task Bar Registry File...
reg export  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" "%spDST%:\DataBackup\%USERID%\Registry\Taskbar_BackUp.reg" /y
echo.
echo  Exporting OneNote Registry File....
reg export "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\OneNote\OpenNotebooks" "%spDST%:\DataBackup\%USERID%\Registry\OneNote.reg" /y
echo.
echo  Exporting Mapped Network Drives File....
reg export "HKEY_CURRENT_USER\Network" "%spDST%:\DataBackup\%USERID%\Registry\Network_Drives.reg" /y

echo.
echo  Copying C Drive folders
robocopy %src%:\ "%spDST%:\DataBackup\%USERID%\C_Drive" %roboOP% /A-:SH %cExempt% %externalBackupLog% 
echo.
echo  Copying Profile folders
robocopy %src%:\Users\%USERID%\ "%spDST%:\DataBackup\%USERID%\Profile Folders" %roboOP% /A-:SH %profileExempt% %externalBackupLog% 
REM enable an indicator so we can know what drive to navigate to open log file
GOTO specific_backup_end

REM *********************************************************************************************************************************************************************
:Specific_Restore
REM Issue with this Restore, specifically Pinned Applications are restoring but not populating
REM In addition to this, the backup to a Specified External Drive works fine when ran with D drive
REM So this means that the issue lies here in this restore since the backup is not the issue
REM 11/21/22 Issue is resolved, xcopy to a temp directory then copy from there
REM This is Hidden Feature Number 6
REM This is in place in case that the drive letter is not D OR E, this way you can set it manually and not panic
echo.
echo  This is a Hidden Option that should be used when needed to Restore Data from a Specific Drive
echo  Please confirm the Specified Drive Letter to avoid program failure...
echo.
set /p sprDST=Enter Drive Letter:
REM set our restore log variable
set externalRestoreLog=/log+:"%sprDST%:\DataBackup\%USERID%\Restore_Log.txt" 

if exist "%src%:\Lotus\" (
echo.
echo  Restoring Lotus Notes....
Xcopy "%sprDST%:\DataBackup\%USERID%\Lotus\Notes\Data" "%src%:\Lotus\Notes\Data" %xcopyOP%
Xcopy "%sprDST%:\DataBackup\%USERID%\Lotus\Notes\notes.ini" "%src%:\Lotus\Notes" %xcopyOP%
) else (
echo.
echo  No Lotus Folder Found, continuing to Desktop...
)
echo.
echo  Restoring Desktop.....
robocopy "%sprDST%:\DataBackup\%USERID%\Desktop" "%src%:\Users\%USERID%\Desktop" %roboOP% /log:"%sprDST%:\DataBackup\%USERID%\Restore_Log.txt"
echo.
echo  Restoring Documents...
robocopy "%sprDST%:\DataBackup\%USERID%\Documents" "%src%:\Users\%USERID%\Documents" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Favorites...
robocopy "%sprDST%:\DataBackup\%USERID%\Favorites" "%src%:\Users\%USERID%\Favorites" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Downloads...
robocopy "%sprDST%:\DataBackup\%USERID%\Downloads" "%src%:\Users\%USERID%\Downloads" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Pictures...
robocopy "%sprDST%:\DataBackup\%USERID%\Pictures" "%src%:\Users\%USERID%\Pictures" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Videos...
robocopy "%sprDST%:\DataBackup\%USERID%\Videos" "%src%:\Users\%USERID%\Videos" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Music...
robocopy "%sprDST%:\DataBackup\%USERID%\Music" "%src%:\Users\%USERID%\Music" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Google Bookmarks...
robocopy "%sprDST%:\DataBackup\%USERID%\Google Bookmarks" "%src%:\Users\%USERID%\AppData\Local\Google\Chrome\User Data\Default" %roboOP% %externalRestoreLog%
echo.
echo  Restoring Microsoft Edge Bookmarks...
robocopy "%sprDST%:\DataBackup\%USERID%\Edge Bookmarks" "%src%:\Users\%USERID%\AppData\Local\Microsoft\Edge\User Data\Default" %roboOP% %externalRestoreLog%
REM Beginning of Restoring AppData
echo.
echo  Restoring OneNote AppData (Local and Roaming)...
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\OneNote Local" "%src%:\Users\%USERID%\AppData\Local\Microsoft\OneNote" %xcopyOP%
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\OneNote Roaming" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\OneNote" %xcopyOP%
echo.
echo  Restoring Excel AppData...
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\Excel" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Excel" %xcopyOP%
echo.
echo  Restoring Outlook AppData...
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\Outlook" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Outlook" %xcopyOP%
echo.
echo  Restoring PowerPoint AppData...
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\PowerPoint" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\PowerPoint" %xcopyOP%
echo.
echo  Restoring Outlook Signatures...
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\Signatures" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Signatures" %xcopyOP%
echo.
echo  Restoring Spelling AppData...
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\Spelling" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Spelling" %xcopyOP%
echo.
echo  Restoring Teams Backgroud AppData...
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\Teams Backgrounds" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Teams\Backgrounds" %xcopyOP%
echo.
echo  Restoring Word AppData...
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\Word" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Word" %xcopyOP%
echo.
echo  Restoring Windows Themes AppData...
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\Windows Themes" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\Themes" %xcopyOP%
echo.
echo  Restoring Microsoft Templates AppData...
Xcopy "%sprDST%:\DataBackup\%USERID%\AppData Folders\Templates" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Templates" %xcopyOP%
echo.
echo  Restoring Quick Access...
Xcopy "%sprDST%:\DataBackup\%USERID%\Quick Access" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Windows\recent" %xcopyOP%
echo.
echo  Restoring Profile Folders
echo  (If you see Access denied prompts, please ignore this as it is skipping unnecessary Admin program files)
Xcopy "%sprDST%:\DataBackup\%USERID%\Profile Folders" %src%:\Users\%USERID%\ %xcopyOP%
echo.
echo  Restoring Registry Files
echo.
REM echo  Importing Task Bar Registry File...
REM regedit /s "%sprDST%:\DataBackup\%USERID%\Registry\Taskbar_BackUp.reg"
REM echo.
REM echo  Importing Mapped Network Drived File...
REM regedit /s "%sprDST%:\DataBackup\%USERID%\Registry\OneNote.reg"
REM echo.
REM echo  Importing Mapped Network Drived File...
REM regedit /s "%sprDST%:\DataBackup\%USERID%\Registry\Network_Drives.reg"
REM echo.
REM Issue might be the same as OneDrive since it is copying over the network, attempting to copy using xcopy to a temp directory
REM then using robocopy to restore the data
REM logic is to first create a temp folder, copy over files, restore files, delete temp folder
echo  Creating temp directories for registers and needed files
mkdir "%src%:\Users\%USERID%\Temp_Quick Launch"
mkdir "%src%:\Users\%USERID%\Temp_Reg"

REM next copy registry files to Temp_Reg folder
Xcopy "%sprDST%:\DataBackup\%USERID%\Quick Launch" "%src%:\Users\%USERID%\Temp_Quick Launch" %xcopyOP%
Xcopy "%sprDST%:\DataBackup\%USERID%\Registry" "%src%:\Users\%USERID%\Temp_Reg" %xcopyOP%
REM Now we can restore the system without OneDrive robocopy issues
REM using Xcopy to replace all existing files
echo.
echo  Importing Task Bar Registry File...
regedit /s "%src%:\Users\%USERID%\Temp_Reg\Taskbar_BackUp.reg"
echo.
echo  Importing Mapped Network Drived File...
regedit /s "%src%:\Users\%USERID%\Temp_Reg\Network_Drives.reg"
echo.
echo  Importing OneNote Registry File...
regedit /s "%src%:\Users\%USERID%\Temp_Reg\OneNote.reg"
echo.
echo  Restoring Pinned Applications...
Xcopy "%src%:\Users\%USERID%\Temp_Quick Launch" "%src%:\Users\%USERID%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch" %xcopyOP%
echo.
REM I discovered that on old laptops, Google is under Program Files (x86) while on new systems it is under Program Files
REM attempting to manually add the shortcut and restoring this way
REM attemp did not work, looks like no work around possible at this moment
REM Delete temporary directories
rmdir /S /Q "%src%:\Users\%USERID%\Temp_Quick Launch"
rmdir /S /Q "%src%:\Users\%USERID%\Temp_Reg"
REM Branch to restore_end
GOTO specific_restore_end

REM *********************************************************************************************************************************************************************
REM Back up log here
:backup_end
echo.
echo   Copying of the following Folders were complete: Desktop, Documents, Favorites, Downloads, Pictures, Videos, 
echo   Music, Google Bookmarks, Outlook Signatures, Task Bar Pinned Apps, Quick Access, Mapped Network Drives,
echo   Microsoft AppData,and Unique User Profile Folders
echo.
echo   Please make sure to double check a couple of folders to make sure everything copied over
echo   Due to potential OneDrive file conflicts, copy any files and folders in %src%:\ manually and save them in OneDrive under DataBackup\C_Drive
echo. 

echo   Opening "Backup_Log.txt" Please check to make sure all data was copied!
start %SystemRoot%\explorer.exe "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Backup_Log.txt"

REM Branch to end
GOTO End

REM ********************************************************************************************************************************************************************
REM Restore log here, edit changed to Xcopy so no log generated
:restore_end
echo   Restoration was complete
echo.
echo   Restarting Taskbar...
taskkill /f /im explorer.exe
start %SystemRoot%\explorer.exe
echo.
TIMEOUT /T 10
echo   Opening "Restore_Log.txt" Please check to make sure all data was copied:
start %SystemRoot%\explorer.exe "%src%:\Users\%USERID%\OneDrive - Underwriters Laboratories\DataBackup\Restore_Log.txt"
echo   Due to Local User Permission issues, please copy files from OneDrive DataBackup\C_Drive AND DataBackup\Profile to %src%:\Users\%USERID%\ and drive manually
REM Branch to end
GOTO End

REM *********************************************************************************************************************************************************************
:external_backup_end
echo.
echo   Copying of the following Folders were complete: Desktop, Documents, Favorites, Downloads, Pictures, Videos, 
echo   Music, Google Bookmarks, Outlook Signatures, Task Bar Pinned Apps, Quick Access, Mapped Network Drives,
echo   Microsoft AppData, Unique User Profile Folders and Unique Folders under C:\
echo.
echo   Please make sure to double check a couple of folders to make sure everything copied over
echo.  
REM Since the addition of the multiple drive scan, adjust opening the log file here
echo   Opening "Backup_Log.txt" Please check to make sure all data was copied!
if %testDST%==true (
start %SystemRoot%\explorer.exe "%newDST%:\DataBackup\%USERID%\Backup_Log.txt"
)
if %testDST%==false (
start %SystemRoot%\explorer.exe "%dst%:\DataBackup\%USERID%\Backup_Log.txt"
)
REM Branch to end
GOTO End
REM **********************************************************************************************************************************************************************
:external_restore_end
REM Restore log for external process
echo   Restoration was complete
echo.
echo   Restarting Taskbar...
taskkill /f /im explorer.exe
start %SystemRoot%\explorer.exe
echo.
TIMEOUT /T 10
echo   Opening "Restore_Log.txt" Please check to make sure all data was copied!
start %SystemRoot%\explorer.exe "%dst%:\DataBackup\%USERID%\Restore_Log.txt" 

echo   When Restoring Profile Folders, it's OKAY if "Access denied" appears, this is because of profile settings, just double check on the machine to make sure it was restored properly
echo   Due to Local User Permission, please copy files from %dst%:\DataBackup\%USERID%\C_Drive to %src%:\ drive manually (will most likely prompt for admin rights)
REM Branch to end
GOTO End

REM **********************************************************************************************************************************************************************
:specific_backup_end
echo.
echo   Copying of the following Folders were complete: Desktop, Documents, Favorites, Downloads, Pictures, Videos, 
echo   Music, Google Bookmarks, Outlook Signatures, Task Bar Pinned Apps, Quick Access, Mapped Network Drives,
echo   Microsoft AppData, Unique User Profile Folders and Unique Folders under C:\
echo.
echo   Please make sure to double check a couple of folders to make sure everything copied over
echo.  
REM Since the addition of the multiple drive scan, adjust opening the log file here
echo   Opening "Backup_Log.txt" Please check to make sure all data was copied!
start %SystemRoot%\explorer.exe "%SPdst%:\DataBackup\%USERID%\Backup_Log.txt"
GOTO End

REM **********************************************************************************************************************************************************************
:specific_restore_end
echo   Restoration was complete
echo.
echo   Restarting Taskbar...
taskkill /f /im explorer.exe
start %SystemRoot%\explorer.exe
echo.
TIMEOUT /T 10
echo   Opening "Restore_Log.txt" Please check to make sure all data was copied!
start %SystemRoot%\explorer.exe "%sprDST%:\DataBackup\%USERID%\Restore_Log.txt" 

echo   When Restoring Profile Folders, it's OKAY if "Access denied" appears, this is because of profile settings, just double check on the machine to make sure it was restored properly
echo   Due to Local User Permission, please copy files from %sprDST%:\DataBackup\%USERID%\C_Drive to %src%:\ drive manually (will most likely prompt for admin rights)
GOTO End

REM **********************************************************************************************************************************************************************
:End
echo.
echo   Program has been completed, please check log files or command prompt for any errors
echo.
echo.
pause

endlocal