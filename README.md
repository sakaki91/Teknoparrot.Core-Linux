# Teknoparrot.Core-Linux

This project is 100% free and open source, and aims to help preserve arcade game emulation in a way that is compatible with the Linux kernel, trying to decouple it as much as possible from the Windows NT kernel.  
We also __DO NOT USE illegal dumps__ (always use your *legal dumps!*), and we __DO NOT USE proprietary code__ from the __[Teknoparrot](https://teknoparrot.com/en/)__ project, And this works like a translator, a __Linux-Wrapper__ that translates an __NT-Wrapper__.

__Be patient if something doesn't work (this is quite common), I'm doing this on my own, and I'm really trying.__

#### If you would like to support the development of the project:
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sakaki91)  

### Getting Started: 
- [[ Setup ]](#setup)
- [[ Auto-install ]](#auto-install)
- [[ Currently supported games ]](currently-supported-games.md)
- [[ About the Project ]](#about-the-project)

## Setup:
In this guide we will use the following tools:  
`wine, winetricks, WineGE/UMU-Proton`

First, we will create a basic folder structure in your user folder:

    $ cd ~
    $ mkdir -p Teknoparrot/{PROGRAM,PREFIX,TMP}
    $ cd Teknoparrot/TMP
    
Let's start preparing the prefix and installing the dependencies:

    $ export WINEPREFIX=$HOME/Teknoparrot/PREFIX
    $ wineboot
    $ wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe
    $ wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe
    $ wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip
    $ winetricks dxvk
    $ wine dotnet-runtime-win-x64.exe
    $ wine windowsdesktop-runtime-win-x64.exe
    $ unzip TPBootstrapper.zip -d ~/Teknoparrot/PROGRAM
    $ wine ~/Teknoparrot/PROGRAM/TPBootstrapper.exe

Following this, you should be able to use Teknoparrot normally. However, if you encounter compatibility issues with Wine errors, you can use [WineGE](https://github.com/GloriousEggroll/wine-ge-custom/releases) or [UMU-Proton](https://github.com/Open-Wine-Components/umu-proton/releases) to run the program instead of regular Wine.  

Below is an example of how the program would run, both with UMU and WineGE:

__WineGE__:

    $ LC_ALL=C WINEPREFIX=$HOME/Teknoparrot/PREFIX PATHTOWINE/bin/wine $HOME/Teknoparrot/PROGRAM/TeknoparrotUi.exe

__UMUProton__ (Local Installed):

    $ LC_ALL=C WINEPREFIX=$HOME/Teknoparrot/PREFIX $HOME/.local/bin/umu-run $HOME/Teknoparrot/PROGRAM/TeknoparrotUi.exe

## Auto Install:
Script dependencies: `git, bash, zenity, wget, wine, winetricks`

    $ cd ~/
    $ git clone https://github.com/sakaki91/Teknoparrot.Core-Linux/
    $ cd Teknoparrot.Core-Linux/
    $ chmod +x install.sh
    $ ./install.sh
 
## About the Project:

#### __What is the GPL license and why does the project have it?__  
It is present in the project precisely to protect the wrapper from any "destructive" intentions on the part of private companies, it is there to protect the code from being transformed into a "closed box" or something similar to a paywall, as we have seen happen with some projects in the past.  
The culture must be FREE and ACCESSIBLE to everyone, regardless of their financial condition or level of support, with security, transparency and, above all, respect for both the user's machine and the person behind the screen.
