#!/bin/bash

hostDependencyChecker(){
    dependencies=(wine winetricks bash wget unzip tar zenity)
    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            printf "$NORMAL_LOG $cmd not found. $ERROR_LOG\n" && exit 1
        fi
    done
}

atomicTree(){
    TMP=${TREE}/TMP
    PROGRAM=${TREE}/PROGRAM
    PREFIX=${TREE}/PREFIX
    [ -f "$TREE"/TeknoParrot ] && rm -rf "$TREE"/TeknoParrot
    [ -d "$PROGRAM" ] && rm -rf "$PROGRAM"
    [ -d "$PREFIX" ] && rm -rf "$PREFIX"
    [ -d "$TMP" ] && rm -rf "$TMP"
    mv "$TREE" "$TREE".old
    mkdir -p "$TREE"/{TMP,PROGRAM}
}

dependencyInstall(){
    clear
    export WINEPREFIX=${PREFIX}
    printf "$NORMAL_LOG Wineboot. ($PREFIX)" && wineboot -u &> $ARL_LOG
        if [ -d "$PREFIX"/drive_c ]; then
            printf " $DONE_LOG\n$NORMAL_LOG Downloading dependencies."
            wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe --directory-prefix="$TMP" &>> $ARL_LOG
            wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe --directory-prefix="$TMP" &>> $ARL_LOG
            [[ -f "$TMP"/dotnet-runtime-win-x64.exe ]] && dNETR_PRESENT=1
            [[ -f "$TMP"/windowsdesktop-runtime-win-x64.exe ]] && dNETW_PRESENT=1
            if [[ $dNETR_PRESENT == 1 || $dNETW_PRESENT == 1 ]]; then
                printf " $DONE_LOG\n$NORMAL_LOG Installing dependencies."
                wine "$TMP"/dotnet-runtime-win-x64.exe /install /quiet /norestart &>> $ARL_LOG
                wine "$TMP"/windowsdesktop-runtime-win-x64.exe /install /quiet /norestart &>> $ARL_LOG
            else
                printf " $ERROR_LOG\n" && exit
            fi
            winetricks dxvk &>> $ARL_LOG
            printf " $DONE_LOG\n$NORMAL_LOG Downloading TeknoParrot (Web-Installer)."
            wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip --directory-prefix="$TMP" &>> $ARL_LOG
            if [ -f "$TMP"/TPBootstrapper.zip ]; then
                (
                unzip "$TMP"/TPBootstrapper.zip -d "$PROGRAM" &>> $ARL_LOG
                cd "$PROGRAM"
                wine TPBootstrapper.exe &>> $ARL_LOG
                [ -f "$PROGRAM"/TeknoParrotUi.exe ] && printf " $DONE_LOG\n"
                [ ! -f "$PROGRAM"/TeknoParrotUi.exe ] && printf " $ERROR_LOG\n" && exit
                )
            else
                printf "$ERROR_LOG\n" && exit
            fi
            ls $TREE &>> $ARL_LOG && ls $TREE/* &>> $ARL_LOG
            rm -rf "$PROGRAM"/TPBootstrapper*
            rm -rf "$TMP" && printf "$NORMAL_LOG Temporary files cleared. $DONE_LOG\n"
       else
            printf " $ERROR_LOG\n" && exit
       fi
}

executableCreation(){
    (
        cd "$TREE"
        HEADER="#!/bin/bash"
        FLAGS="LC_ALL=C LC_NUMERIC=C LANG=en_US.UTF-8 WINEPREFIX=$PREFIX wine $PROGRAM/TeknoParrotUi.exe"
        echo $HEADER > TeknoParrot
        echo $FLAGS >> TeknoParrot
        chmod +x TeknoParrot
    )
}

ARL_NAME="Arcade Wrapper Linux/Unix-like"
ARL_VERSION="3.1-8"
ARL_LOG="/dev/null"
DONE_LOG="\e[1;32mOK\033[0m"
NORMAL_LOG="\e[1;34m*\033[0m"
ERROR_LOG="\e[1;31mERROR\033[0m"
TREE=${HOME}/TeknoParrot

case $1 in
    "--help")
        echo -e "\n$ARL_NAME $ARL_VERSION\n\n--help\t\tShow this message.\n--version\tShow wrapper version.\n--custom-dir\tWith this flag you can choose a custom installation directory.\n--debug \tThis executes the script and generates a log file (ARL.LOG) in $HOME.\n"
        exit
    ;;
    "--custom-dir")
        TREE=$(zenity --file-selection --directory --title "Select your desired directory:")/TeknoParrot
        [[ $2 == "--debug" ]] && ARL_LOG=$HOME/AR.LOG
    ;;
    "--debug")
        ARL_LOG=$HOME/AR.LOG
    ;;
    "--version")
        echo -e "$ARL_NAME $ARL_VERSION"
        exit
    ;;
esac

hostDependencyChecker
clear
atomicTree
dependencyInstall
executableCreation
