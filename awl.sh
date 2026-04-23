#!/bin/bash

ERROR_LOG="\e[1;31m"
NC="\033[0m"
PROJECT_HEADER="awl"
PROJECT_VERSION=""
AWL_LOCATION=""
TEKNO_LOCATION=""
UMU_LOCATION=""
PREFIX_LOCATION=""
PREFIX_UMU_LOCATION=""

#EMPTY_TREE:
#PROJECT_VERSION=""
#AWL_LOCATION=""
#EKNO_LOCATION=""
#UMU_LOCATION=""
#PREFIX_LOCATION=""
#PREFIX_UMU_LOCATION=""

playRunWrapper(){
    FLATPAK_DIR=$(flatpak --installations)
    PLAY_ROM_DIR="$HOME/.var/app/org.purei.Play/config/Play Data Files/arcaderoms"
    [[ ! -d "$FLATPAK_DIR"/app/org.purei.Play ]] && printf "$ERROR_LOG * Emulator not found (Play!). $NC\n" && exit
    [[ ! -d "$AWL_LOCATION"/play ]] && ln -s "$PLAY_ROM_DIR" "$AWL_LOCATION"/play
    printf " wait...\n"
    PLAY_ROM_SELECTION=$(zenity --file-selection --directory --title="Select the desired ROM (Folder only):")
    PLAY_ROM=$(basename $PLAY_ROM_SELECTION)
    flatpak run org.purei.Play --arcade "$PLAY_ROM" &> /dev/null
    printf " done!\n"
}

dolphinRunWrapper(){
    FLATPAK_DIR=$(flatpak --installations)
    [[ ! -d "$FLATPAK_DIR"/app/org.DolphinEmu.dolphin-emu ]] && printf "$ERROR_LOG * Emulator not found (Dolphin). $NC\n" && exit
    printf " wait...\n"
    DOLPHIN_ROM=$(zenity --file-selection --title="Select the desired ROM:" )
    flatpak run org.DolphinEmu.dolphin-emu "$DOLPHIN_ROM" &> /dev/null
    printf " done!\n"
}

teknoRunWrapper(){
    printf " wait...\n"
    LC_ALL=en_US.UTF-8
    LC_NUMERIC=en_US.UTF-8
    LANG=en_US.UTF-8
    if [[ $RUNNER == "wine" ]]; then
        WINEPREFIX=$PREFIX_LOCATION wine $AWL_LOCATION/bin/TeknoParrotUi.exe &>> /dev/null
    elif [[ $RUNNER == "umu" ]]; then
        PROTONPATH="$UMU_LOCATION" WINEPREFIX=$PREFIX_UMU_LOCATION umu-run $AWL_LOCATION/bin/TeknoParrotUi.exe &>> /dev/null
    fi
    printf " done!\n"
}

clear
printf "$PROJECT_HEADER $PROJECT_VERSION (type: help)\n"
while true; do
	read -p "$ " mainIO
    case $mainIO in
        "help")
            printf "\e[1m[@system]:$NC\nhelp\t\t\tshow this message.\nclear\t\t\tclear the screen.\nexit\t\t\tkill the process.\n\e[1m[@wrapper]:$NC\nplay\t\t\tOpens the emulator compatible with Namco System [147/246].\ndolphin\t\t\tOpens the emulator compatible with Sega Triforce.\ntekno-wine\t\tOpens the wine-wrapper compatible with TeknoParrot/OpenParrot and their respective platforms.\ntekno-umu\t\tOpens the umu-wrapper compatible with TeknoParrot/OpenParrot and their respective platforms.\n"
        ;;
        "clear")
            clear
            printf "$PROJECT_HEADER $PROJECT_VERSION (type: help)\n"
        ;;
        "exit")
            break
        ;;
        "play")
            playRunWrapper
        ;;
        "dolphin")
            dolphinRunWrapper
        ;;
        "tekno-wine")
            RUNNER=wine
            teknoRunWrapper
        ;;
        "tekno-umu")
            RUNNER=umu
            teknoRunWrapper
        ;;
        *)
            printf "$ERROR_LOG invalid option. $NC\n"
        ;;
    esac
done
