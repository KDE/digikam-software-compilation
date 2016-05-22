;; ============================================================
 ;
 ; This file is a part of digiKam project
 ; http://www.digikam.org
 ;
 ; Date        : 2010-11-08
 ; Description : Null Soft windows installer based for digiKam
 ;
 ; Copyright (C) 2010      by Julien Narboux <julien at narboux dot fr>
 ; Copyright (C) 2010-2014 by Gilles Caulier <caulier dot gilles at gmail dot com>
 ; Copyright (C) 2011-2014 by Ananta Palani <anantapalani at gmail dot com>
 ;
 ; Script arguments:
 ; VERSION  : the digiKam version string.
 ; KDE4PATH : the path where whole KDE4 + digiKam & co is installed.
 ;
 ; Example: C:\NSIS\makensis.exe /DVERSION=4.1.0 /DKDE4PATH=C:\KDE digikam.nsi
 ;
 ; Extra NSIS plugins to install in order to run this script :
 ;
 ; Registry   : http://nsis.sourceforge.net/Registry_plug-in
 ; LockedList : http://nsis.sourceforge.net/LockedList_plug-in
 ;
 ; NSIS script reference can be found at this url:
 ; http://nsis.sourceforge.net/Docs/Chapter4.html
 ;
 ; This program is free software; you can redistribute it
 ; and/or modify it under the terms of the GNU General
 ; Public License as published by the Free Software Foundation;
 ; either version 2, or (at your option)
 ; any later version.
 ;
 ; This program is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ; GNU General Public License for more details.
 ;
 ; ============================================================ ;;

;-------------------------------------------------------------------------------
; Compression rules optimizations
; We will use LZMA compression as 7Zip, with a dictionary size of 96Mb (to reproduce 7Zip Ultra compression mode)

SetCompress force
SetCompressor /SOLID lzma
SetDatablockOptimize on
SetCompressorDictSize 96

;-------------------------------------------------------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !define MY_PRODUCT "digiKam"
  !define PRODUCT_HOMEPAGE "http://www.digikam.org"
  !define SUPPORT_HOMEPAGE "http://www.digikam.org/support"
  !define ABOUT_HOMEPAGE "http://www.digikam.org/about"
  !define OUTFILE "${MY_PRODUCT}-installer-${VERSION}-win32.exe"
  !define MSVCRuntimePath "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\redist\x86\Microsoft.VC100.CRT"
  !define MSVCOpenMPPath "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\redist\x86\Microsoft.VC100.OPENMP"
  ;The libraries in the system folder are often outdated. It is better to use the
  ;   the latest redistributable instead
  ;!define MSVCRuntimePath "C:\Windows\System32"
  ;!define MSVCOpenMPPath "C:\Windows\System32"

;-------------------------------------------------------------------------------
;General

  ;Name and file
  Name "${MY_PRODUCT} ${VERSION}"
  Icon "digikam-installer.ico"
  UninstallIcon "digikam-uninstaller.ico"
  OutFile "${OUTFILE}"

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

  ;Default installation folder
  InstallDir "$PROGRAMFILES\${MY_PRODUCT}"

  ;Get installation folder from registry if available
  InstallDirRegKey HKLM "Software\${MY_PRODUCT}" ""

  !include "LogicLib.nsh"
  !include "StrFunc.nsh"
  ${StrRep}
  ${StrStr}
  ${StrStrAdv}

  ;Requires Registry plugin :
  ;http://nsis.sourceforge.net/Registry_plug-in
  !include "Registry.nsh"

  Function .onInit
    Push $0
    UserInfo::GetAccountType
    Pop $0
    ${If} $0 != "admin" ; Require admin rights on NT4+
      MessageBox MB_OK|MB_ICONSTOP|MB_TOPMOST|MB_SETFOREGROUND "Administrator privileges required!$\r$\n$\r$\nPlease restart the installer using an administrator account."
      SetErrorLevel 740 ; ERROR_ELEVATION_REQUIRED
      Quit
    ${EndIf}
    Pop $0

    Push $R0
    Push $R1
    Push $R2

    checkUninstallRequired:
      ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "UninstallString"
      ${StrRep} $R0 $R0 '"' "" ; Remove double-quotes so Delete and RMDir work properly and we can extract the path
      StrCmp $R0 "" done

      ${IfNot} ${FileExists} $R0
        DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}"
        Goto checkUninstallRequired
      ${EndIf}

      ;Get path
      ${StrStrAdv} $R1 $R0 "\" "<" "<" "0" "0" "0"

      ReadRegStr $R2 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "DisplayName" ; DisplayName contains version

      #TODO: need to internationalize string (see VLC / clementine / etc)
      MessageBox MB_YESNO|MB_ICONEXCLAMATION|MB_TOPMOST|MB_SETFOREGROUND "$R2 is currently installed but only a single instance of ${MY_PRODUCT} can be installed at any time.$\r$\n$\r$\n\
        Do you want to uninstall the current instance of ${MY_PRODUCT} and continue installing ${MY_PRODUCT} ${VERSION}?" /SD IDYES IDNO noInstall

    ;Run the uninstaller
    ;uninst:
      ClearErrors

      IfSilent 0 notSilent
        ExecWait '"$R0" /S _?=$R1' ; Do not copy the uninstaller to a temp file
        Goto uninstDone
      notSilent:
        ExecWait '"$R0" _?=$R1' ; Do not copy the uninstaller to a temp file

      uninstDone:
        IfErrors checkUninstallRequired
        Delete "$R0" ; If uninstall successfule, remove uninstaller
        RMDir "$R1" ; remove previous install directory
        Goto checkUninstallRequired

    noInstall:
      Abort

    done:
      Pop $R2
      Pop $R1
      Pop $R0

    FunctionEnd

;-------------------------------------------------------------------------------
;Interface Configuration

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "digikam_header.bmp" 
  !define MUI_WELCOMEFINISHPAGE_BITMAP "digikam_welcome.bmp"
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP "digikam_welcome.bmp"
  !define MUI_ABORTWARNING
  !define MUI_ICON "digikam-installer.ico"
  !define MUI_UNICON "digikam-uninstaller.ico"
  !define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\RELEASENOTES.txt"

  ;Variable for the folder of the start menu
  Var StartMenuFolder

;-------------------------------------------------------------------------------
;Functions and Macros

  ; Sets up a variable to indicate to LockedListShow that it was arrived at from the previous page rather than the next
  !macro LeavePageBeforeLockedListShow un
    Function ${un}LeavePageBeforeLockedListShow
      StrCpy $R9 0
    FunctionEnd
  !macroend
  !insertmacro LeavePageBeforeLockedListShow ""
  !insertmacro LeavePageBeforeLockedListShow "un."

  ;Requires LockedList plugin :
  ;http://nsis.sourceforge.net/LockedList_plug-in
  #TODO: internationalize MUI_HEADER_TEXT and possibly columns (see LameXP)
  !macro LockedListShow un
    Function ${un}LockedListShow
      ;Check if we are coming from the previous page or the next.
      ;If the next page, abort.
      ;This prevents autonext from never allowing the Back button to work.
      ${If} $R9 == 1
        Abort
      ${EndIf}
      StrCpy $R9 1
      !insertmacro MUI_HEADER_TEXT "Close Conflicting Programs" "Ensure no programs are using the install location"
      LockedList::AddFolder $INSTDIR
      LockedList::Dialog /autonext /autoclose
      Pop $R0
    FunctionEnd
  !macroend
  !insertmacro LockedListShow ""
  !insertmacro LockedListShow "un."

  Function DirectoryLeave
    Call NotifyIfRebootRequired
    Call LeavePageBeforeLockedListShow
  FunctionEnd

  Function NotifyIfRebootRequired
    Call IsRebootRequired
    Exch $0

    ${If} $0 == 1
      #TODO: consider adding a RunOnce entry for the installer to HKCU instead of telling the user they need to run the installer themselves (can't add to HKLM because basic user wouldn't have access, only admins do) - this would require using the UAC plugin to handle elevation by starting as a normal user, elevating, and then dropping back to normal when writing to HKCU
      #TODO: need to internationalize string (see VLC / clementine / etc)
      MessageBox MB_YESNO|MB_ICONSTOP|MB_TOPMOST|MB_SETFOREGROUND "You must reboot to complete uninstallation of a previous install of ${MY_PRODUCT} before ${MY_PRODUCT} ${VERSION} can be installed.$\r$\n$\r$\n\
        Would you like to reboot now?$\r$\n$\r$\n\
        (You will have to run the installer again after reboot to continue setup)" /SD IDNO IDNO noInstall
        Reboot
    ${Else}
      Goto done
    ${EndIf}

    noInstall:
      Abort

    done:
      Pop $0
  FunctionEnd

  Function IsRebootRequired
    Push $0
    Push $1
    Push $2
    Push $3

    ${registry::Read} "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" "PendingFileRenameOperations" $0 $1
    ${registry::Unload}

    ${If} $0 != ""
      StrLen $2 "$INSTDIR"
      ${StrStr} $1 "$0" "$INSTDIR"
      StrCpy $3 $1 $2
    ${AndIf} $3 == "$INSTDIR"
      StrCpy $0 1
    ${Else}
      StrCpy $0 0
    ${EndIf}

    Pop $3
    Pop $2
    Pop $1
    Exch $0
  FunctionEnd

;-------------------------------------------------------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "COPYING"
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE DirectoryLeave
  !insertmacro MUI_PAGE_DIRECTORY
  Page Custom LockedListShow

  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${MY_PRODUCT}"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

  !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE un.LeavePageBeforeLockedListShow
  !insertmacro MUI_UNPAGE_CONFIRM
  UninstPage Custom un.LockedListShow
  !insertmacro MUI_UNPAGE_INSTFILES

;-------------------------------------------------------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "German"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "SpanishInternational"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "TradChinese"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "NorwegianNynorsk"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Ukrainian"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Croatian"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Thai"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Latvian"
  !insertmacro MUI_LANGUAGE "Macedonian"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SerbianLatin"
  !insertmacro MUI_LANGUAGE "Arabic"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Mongolian"
  !insertmacro MUI_LANGUAGE "Luxembourgish"
  !insertmacro MUI_LANGUAGE "Albanian"
  !insertmacro MUI_LANGUAGE "Breton"
  !insertmacro MUI_LANGUAGE "Belarusian"
  !insertmacro MUI_LANGUAGE "Icelandic"
  !insertmacro MUI_LANGUAGE "Malay"
  !insertmacro MUI_LANGUAGE "Bosnian"
  !insertmacro MUI_LANGUAGE "Kurdish"
  !insertmacro MUI_LANGUAGE "Irish"
  !insertmacro MUI_LANGUAGE "Uzbek"
  !insertmacro MUI_LANGUAGE "Galician"
  !insertmacro MUI_LANGUAGE "Afrikaans"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "Esperanto"

;-------------------------------------------------------------------------------
;Installer Sections

Section "digiKam" SecDigiKam

  #No longer killing running processes prior to install since we are using LockedList to let the user have control over this

  SetOutPath "$INSTDIR"

  File "RELEASENOTES.txt"
  File "digikam-uninstaller.ico"

  ;Copy only required directories
  ;The SetOutPath is required because otherwise NSIS will assume all files are
  ;  in the same folder even though they are sourced from different folders
  ;The \*.* is required for File /r because without it, NSIS would add every 
  ;  folder with the name 'bin' in all subdirectories of ${KDE4PATH}
  SetOutPath "$INSTDIR\bin"
  ;Microsoft does not allow debug libraries to be redistributed, so compile
  ;  using one of the release modes to ensure the *d.dll are not required
  File "${MSVCRuntimePath}\msvcp100.dll"
  File "${MSVCRuntimePath}\msvcr100.dll"
  File "${MSVCOpenMPPath}\vcomp100.dll"
  ;File "${MSVCRuntimePath}\msvcp100d.dll"
  ;File "${MSVCRuntimePath}\msvcr100d.dll"
  ;File "${MSVCOpenMPPath}\vcomp100d.dll"
  File /r "${KDE4PATH}\bin\*.*"
  ;SetOutPath "$INSTDIR\certs"
  ;File /r "${KDE4PATH}\certs\*.*"
  ;SetOutPath "$INSTDIR\data"
  ;File /r "${KDE4PATH}\data\*.*"
  ;SetOutPath "$INSTDIR\database"
  ;File /r "${KDE4PATH}\database\*.*"
  ;SetOutPath "$INSTDIR\doc"
  ;File /r "${KDE4PATH}\doc\*.*"
  SetOutPath "$INSTDIR\etc"
  File /r /x kdesettings.bat /x portage "${KDE4PATH}\etc\*.*"
  ;SetOutPath "$INSTDIR\hosting"
  ;File /r "${KDE4PATH}\hosting\*.*"
  ;SetOutPath "$INSTDIR\imports"
  ;File /r "${KDE4PATH}\imports\*.*"
  SetOutPath "$INSTDIR\include"
  File /r "${KDE4PATH}\include\*.*"
  SetOutPath "$INSTDIR\lib"
  File /r "${KDE4PATH}\lib\*.*"
  ;SetOutPath "$INSTDIR\manifest"
  ;File /r "${KDE4PATH}\manifest\*.*"
  SetOutPath "$INSTDIR\phrasebooks"
  File /r "${KDE4PATH}\phrasebooks\*.*"
  SetOutPath "$INSTDIR\plugins"
  File /r "${KDE4PATH}\plugins\*.*"
  ;SetOutPath "$INSTDIR\scripts"
  ;File /r "${KDE4PATH}\scripts\*.*"
  SetOutPath "$INSTDIR\share"
  File /r "${KDE4PATH}\share\*.*"
  SetOutPath "$INSTDIR\translations"
  File /r "${KDE4PATH}\translations\*.*"
  ;SetOutPath "$INSTDIR\vad"
  ;File /r "${KDE4PATH}\vad\*.*"
  ;SetOutPath "$INSTDIR\vsp"
  ;File /r "${KDE4PATH}\vsp\*.*"
  ;SetOutPath "$INSTDIR\xdg"
  ;File /r "${KDE4PATH}\xdg\*.*"

  ;Store installation folder
  WriteRegStr HKLM "Software\${MY_PRODUCT}" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ;Register uninstaller in windows registery with only the option to uninstall (no repair nor modify)
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "Comments" "${MY_PRODUCT} ${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "DisplayIcon" '"$INSTDIR\bin\digikam.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "DisplayName" "${MY_PRODUCT} ${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "HelpLink" "${SUPPORT_HOMEPAGE}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "Publisher" "The digiKam team"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "Readme" '"$INSTDIR\RELEASENOTES.txt"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "URLInfoAbout" "${ABOUT_HOMEPAGE}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "URLUpdateInfo" "${PRODUCT_HOMEPAGE}"
  ;Calculate the install size so that it can be shown in the uninstall interface in Windows
  ;see http://nsis.sourceforge.net/Add_uninstall_information_to_Add/Remove_Programs
  ;this isn't the most accurate method but it is very fast and is accurate enough for an estimate
  push $0
  SectionGetSize SecDigiKam $0
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "EstimatedSize" "$0"
  pop $0
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "NoModify" "1"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "NoRepair" "1"
  ;WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "VersionMajor" "2"
  ;WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}" "VersionMinor" "2"

  ;Add start menu items to All Users
  SetShellVarContext all
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

    ;Create shortcuts
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    SetOutPath "$INSTDIR"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
    SetOutPath "$INSTDIR\bin"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\${MY_PRODUCT}.lnk" "$INSTDIR\bin\digikam.exe"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Showfoto.lnk" "$INSTDIR\bin\showfoto.exe"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\DNGConverter.lnk" "$INSTDIR\bin\dngconverter.exe"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\ExpoBlending.lnk" "$INSTDIR\bin\expoblending.exe"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Panorama.lnk" "$INSTDIR\bin\panoramagui.exe"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Scan.lnk" "$INSTDIR\bin\scangui.exe"
    CreateShortCut "$SMPROGRAMS\$StartMenuFolder\SystemSettings.lnk" "$INSTDIR\bin\systemsettings.exe"
    WriteINIStr "$SMPROGRAMS\$StartMenuFolder\The ${MY_PRODUCT} HomePage.url" "InternetShortcut" "URL" "${PRODUCT_HOMEPAGE}"

  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd

;-------------------------------------------------------------------------------
;Uninstaller Section

Section "Uninstall"

  ;No longer adding /REBOOTOK to Delete and RMDir since using LockedList and also potentially uninstalling from the installer

  Delete "$INSTDIR\Uninstall.exe"
  Delete "$INSTDIR\RELEASENOTES.txt"
  Delete "$INSTDIR\digikam-uninstaller.ico"

  RMDir /r "$INSTDIR\kde4" ;remove any old installs
  RMDir /r "$INSTDIR\bin"
  RMDir /r "$INSTDIR\certs"
  ;RMDir /r "$INSTDIR\data"
  ;RMDir /r "$INSTDIR\database"
  ;RMDir /r "$INSTDIR\doc"
  RMDir /r "$INSTDIR\etc"
  RMDir /r "$INSTDIR\hosting"
  RMDir /r "$INSTDIR\imports"
  RMDir /r "$INSTDIR\include"
  RMDir /r "$INSTDIR\lib"
  ;RMDir /r "$INSTDIR\manifest"
  RMDir /r "$INSTDIR\phrasebooks"
  RMDir /r "$INSTDIR\plugins"
  ;RMDir /r "$INSTDIR\scripts"
  RMDir /r "$INSTDIR\share"
  RMDir /r "$INSTDIR\translations"
  ;RMDir /r "$INSTDIR\vad"
  ;RMDir /r "$INSTDIR\vsp"
  RMDir /r "$INSTDIR\xdg"

  ;Do not do a recursive removal of $INSTDIR because user may have accidentally installed into system critical directory!
  RMDir "$INSTDIR"

  ;Remove start menu items
  SetShellVarContext all
  !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder

  Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\${MY_PRODUCT}.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\Showfoto.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\DNGConverter.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\ExpoBlending.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\Panorama.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\Scan.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\SystemSettings.lnk"
  Delete "$SMPROGRAMS\$StartMenuFolder\The ${MY_PRODUCT} HomePage.url"
  RMDir /r "$SMPROGRAMS\$StartMenuFolder"

  ;Remove registry entries
  DeleteRegKey /ifempty HKLM "Software\${MY_PRODUCT}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MY_PRODUCT}"

SectionEnd
