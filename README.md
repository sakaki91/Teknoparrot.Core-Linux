__Arcade Wrapper Linux.  
(formerly Teknoparrot.Core-Linux).__

This project is 100% free and open source, and aims to help preserve arcade game emulation in a way that is compatible with the Linux kernel, attempting to decouple it as much as possible from the Windows NT kernel, essentially serving as a Linux wrapper that translates the NT wrapper (TeknoParrot), we do NOT use illegal dumps or proprietary code from the original projects.  

And it doesn't cover __APM3 games__ or games that run with __ElfLdr2__ *[(see why)](https://github.com/sakaki91/Arcade.Wrapper-Linux/wiki/1.-About-the-Project#why-is-there-no-support-for-apm3-and-elfldr2)*, it is merely an alternative method to make something that already exists work on other kernels (use your legal dumps).  

Please be patient if something doesn't work (this is quite common), most problems are "mapped in the dark" precisely because of the absence of the source code. I'm doing this myself and trying my best.  

__If you would like to support the project's development (This is entirely optional, but it would make me happy):__  

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sakaki91)  

Did you encounter problems? *[Read this](https://github.com/sakaki91/Arcade.Runtime-Linux/wiki/1.-About-the-Project#how-does-the-error-report-work).*

#### Getting Started: 
First, [check the compatibility list](https://www.github.com/sakaki91/Arcade.Runtime-Linux/wiki/2.-Currently-supported-games) (as some games require different settings and may not work efficiently with my wrapper, since there are better native options).  
* [[ Auto install ]](#auto-install)
* [[ Manual install ]](#manual-install)
* [[ Extra Tweaks]](#extra-tweaks)
* [[ Wiki ]](https://github.com/sakaki91/Arcade.Runtime-Linux/wiki)

#### Auto Install:
__Script Dependencies:__ *[Check this out](https://github.com/sakaki91/Arcade.Runtime-Linux/wiki/3.-Dependencies-and-Distros-Hardware-tested.).*

Installation:

    $ cd ~/
    $ git clone https://github.com/sakaki91/Arcade.Wrapper-Linux
    $ cd Arcade.Wrapper-Linux
    $ chmod +x install.sh
    $ ./install.sh
	$ awl

#### Manual Install:
First, we will create a basic folder structure in your user folder:

    $ cd ~
    $ mkdir -p TeknoParrot/{bin,pfx,tmp}
    $ cd TeknoParrot/tmp

Let's start by defining the Environment Variables:

    $ export WINEPREFIX=$HOME/TeknoParrot/pfx
	$ export LC_ALL=en_US.UTF-8
	$ export LC_NUMERIC=en_US.UTF-8
	$ export LANG=en_US.UTF-8

Now we will download and install the dependencies in the prefix:

	$ wineboot -u
    $ wget -c https://aka.ms/dotnet/8.0/dotnet-runtime-win-x64.exe
    $ wget -c https://aka.ms/dotnet/8.0/windowsdesktop-runtime-win-x64.exe
    $ wget -c https://github.com/nzgamer41/TPBootstrapper/releases/latest/download/TPBootstrapper.zip
    $ wine dotnet-runtime-win-x64.exe
    $ wine windowsdesktop-runtime-win-x64.exe
    $ unzip TPBootstrapper.zip -d ~/TeknoParrot/bin
    $ wine ~/TeknoParrot/bin/TPBootstrapper.exe

Following this, you should be able to use TeknoParrot normally. 

Below is an example of how the program would run:

    $ LC_ALL=en_US.UTF-8 LC_NUMERIC=en_US.UTF-8 LANG=en_US.UTF-8 WINEPREFIX=$HOME/TeknoParrot/pfx wine $HOME/TeknoParrot/bin/TeknoParrotUi.exe

Inconvenient, isn't it? You can [download awl](https://github.com/sakaki91/Arcade.Wrapper-Linux/blob/main/awl.sh), a small initializer that already manages all of this, to automate this code "bible." You would only need to add the paths manually to the script using a text editor, in the following lines:

	AWL_LOCATION="" # project tree folder (normally: ~/.local/share/awl)  
	TEKNO_LOCATION="" # bin folder  
	PREFIX_LOCATION="" # pfx folder  

Next, you can move this file to your local binaries folder and add it to your PATH (if it's not already there):

	$ mv awl.sh ~/.local/bin/awl
	$ nano ~/.bashrc

Next, add and save:

	export PATH="$HOME/.local/bin:$PATH"

Next, you can run the script with:

	$ awl

#### Extra Tweaks:
We'll use some paths like absolute-paths as examples, don't forget to adapt them to your directories!  
There are some optional tweaks you can make to improve your experience, which are listed below:  
* Does your GPU not support Vulkan or has limited support?
  * If you have partial support, you can try installing an older version of DXVK (eg: dxvk2010) compatible with your GPU.
  * If you have no Vulkan support at all, you can open `winecfg` within the prefix and remove the following dlls: `d3d10core, d3d11, d3d8, d3d9, dxgi`(this will affect performance).  
* Are you experiencing graphical bugs in the TeknoParrot UI? `Disable Hardware Acceleration in the launcher settings.`
* Would you like Discord to detect TeknoParrotUI and games opened through it? [Download this](https://github.com/EnderIce2/rpc-bridge/releases/latest/download/bridge.zip).  

and run it below:  

    $ unzip path-to-archive/bridge.zip
	$ WINEPREFIX=path-to-prefix wine path-to-archive/bridge.exe --install
