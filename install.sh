#!/bin/bash

SCRIPT_VERSION="3.2-9"
DXVK_VERSION="2.7.1"
UMU_VERSION="10.0-4"
UMU_MONO_VERSION="10.0.0"
UMU_PRESENT=1
TREE=${HOME}/.local/share/awl

primaryDependencyChecker(){
    dependencies=(wine bash wget unzip tar zenity)
    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            printf "$cmd not found.\n" && exit 1
        fi
    done
}

atomicTree(){
    PROGRAM=${TREE}/bin
    TMP=${TREE}/tmp
    PREFIX=${TREE}/pfx
    PREFIX_UMU=${TREE}/pfx_umu
    [ -f "$TREE"/awl ] && rm -r "$TREE"/awl
    [ -d "$TREE"/umu ] && rm -r umu
    [ -d "$PROGRAM" ] && rm -r "$PROGRAM"
    [ -d "$TMP" ] && rm -r "$TMP"
    [ -d "$PREFIX" ] && rm -r "$PREFIX"
    [ -d "$PREFIX_UMU" ] && rm -r "$PREFIX_UMU"
    mkdir -p "$TREE"/{bin,pfx,tmp}
}

dependencyInstall(){
#wine-dependencies (download + extract) ==>
    wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe --directory-prefix="$TMP"
    wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe --directory-prefix="$TMP"
    wget -c https://download.microsoft.com/download/8/4/a/84a35bf1-dafe-4ae8-82af-ad2ae20b6b14/directx_Jun2010_redist.exe --directory-prefix="$TMP"
    wget -c https://github.com/doitsujin/dxvk/releases/download/v$DXVK_VERSION/dxvk-$DXVK_VERSION.tar.gz --directory-prefix="$TMP"
    [ ! -f "$TMP"/dotnet-runtime-win-x64.exe ] && exit
    [ ! -f "$TMP"/windowsdesktop-runtime-win-x64.exe ] && exit
    [ ! -f "$TMP"/directx_Jun2010_redist.exe ] && exit
    [ ! -f "$TMP"/dxvk-$DXVK_VERSION.tar.gz ] && exit
    tar -xvf "$TMP"/dxvk-$DXVK_VERSION.tar.gz --directory "$TMP"
#wine ==>
    export WINEPREFIX=${PREFIX}
    wineboot -u
    wine "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart
    wine "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart
    wine "$TMP"/directx_Jun2010_redist.exe /Q /C /T:"C:\tmp"
    wine "$PREFIX"/drive_c/tmp/DXSETUP.exe /silent
    mv "$TMP"/dxvk-$DXVK_VERSION/x32/*.dll "$PREFIX"/drive_c/windows/syswow64
    mv "$TMP"/dxvk-$DXVK_VERSION/x64/*.dll "$PREFIX"/drive_c/windows/system32
    wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d10core /d native,builtin /f
    wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d11 /d native,builtin /f
    wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d8 /d native,builtin /f
    wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v d3d9 /d native,builtin /f
    wine reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v dxgi /d native,builtin /f
    if [ $UMU_PRESENT == 1 ]; then
        [[ ! -f "$HOME"/.local/bin/umu-run ]] && printf "\e[1;31mumu-run not found\e[0m - (https://github.com/Open-Wine-Components/umu-launcher#installing-as-user).\n" && exit
        mkdir -p "$TREE"/pfx_umu
        #umu-dependencies (download + extract) ==>
        wget -c https://github.com/Open-Wine-Components/umu-proton/releases/download/UMU-Proton-$UMU_VERSION/UMU-Proton-$UMU_VERSION.tar.gz --directory-prefix="$TMP"
        wget -c https://github.com/wine-mono/wine-mono/releases/download/wine-mono-$UMU_MONO_VERSION/wine-mono-$UMU_MONO_VERSION-x86.msi --directory-prefix="$TMP"
        [ ! -f "$TMP"/wine-mono-$UMU_MONO_VERSION-x86.msi ] && exit
        tar -xvf "$TMP"/UMU-Proton-$UMU_VERSION.tar.gz --directory "$TMP"
        mv "$TMP"/UMU-Proton-$UMU_VERSION -T "$TREE"/umu
        #umu ==>
        export GAMEID=0
        export PROTONPATH="$TREE"/umu
        export WINEPREFIX=${PREFIX_UMU}
        umu-run wineboot -u
        umu-run msiexec /i "$TMP"/wine-mono-$UMU_MONO_VERSION-x86.msi
        umu-run "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart
        umu-run "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart
        umu-run "$TMP"/directx_Jun2010_redist.exe /Q /C /T:"C:\tmp"
        umu-run "$PREFIX_UMU"/drive_c/tmp/DXSETUP.exe /silent
    fi
#tekno ==>
    (
    wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip --directory-prefix="$TMP"
    unzip "$TMP"/TPBootstrapper.zip -d "$PROGRAM"
    cd "$PROGRAM"
    wine TPBootstrapper.exe
    rm -rf "$PROGRAM"/TPBootstrapper* "$TMP"
    )
    rm -rf "$PREFIX"/drive_c/tmp "$PREFIX_UMU"/drive_c/tmp
    chmod +x awl
    cp awl "$TREE"/awl
    ln -sf "$TREE"/awl "$HOME"/.local/bin/awl
}

case $1 in
    "--help")
        echo -e "--help\t\tShow this message.\n--version\tShow wrapper version.\n--ignore-umu\tthis flag is usually the default in installations, as umu is only used for isolated titles like the wmmt-series."
        exit
    ;;
    "--version")
        printf "awl $SCRIPT_VERSION\n"
        exit
    ;;
    "--ignore-umu")
        UMU_PRESENT=0
    ;;
esac

primaryDependencyChecker
atomicTree
dependencyInstall
