#!/bin/bash
set -e

SOURCE="$HOME/Downloads/Unreal Tournament v451wx2 (Intel).zip"
TARGET="$HOME/Programs/UnrealTournament"
INSTALL=

function install_download {
	cd "$TARGET/drive_c/"
	unzip "$SOURCE" "Unreal Tournament (Intel)/Unreal Tournament OS X.app/Contents/Resources/drive_c/UnrealTournament/*"
	mv Unreal\ Tournament\ \(Intel\)/Unreal\ Tournament\ OS\ X.app/Contents/Resources/drive_c/UnrealTournament/ ./
	rm -rf Unreal\ Tournament\ \(Intel\)/
	find UnrealTournament -type d -exec chmod 755 {} \;
}

function install_cd {
	# don't need to install DirectX or whatever stats tracking, and don't install s3tc textures from disk 2
	wine "$SOURCE"
	wget -N "https://ut.rushbase.net/beyondunreal/official/ut/utpatch436nodelta.exe"
	wine utpatch436nodelta.exe
	wget -N "http://www.utpg.org/patches/UTPGPatch451b.exe"
	wine UTPGPatch451b.exe
	wget -N "http://www.cwdohnal.com/utglr/utglr36.zip"
	unzip utglr36.zip -d "$TARGET/drive_c/UnrealTournament/System"
	mv "$TARGET/drive_c/UnrealTournament/System/OpenGLDrv.dll" "$TARGET/drive_c/UnrealTournament/System/OpenGlDrv.dll"
	# may need to set RenderDevice=OpenGLDrv.OpenGLRenderDevice, FullscreenViewportX=1920, FullscreenViewportY=1200, FullscreenColorBits=32
	# wget -N "http://www.uttexture.com/UT/Downloads/Textures/Normal/MasterFiles/Server/Windows/UT_S3TC_Server_Packages.7z"
}

while [[ $# > 0 ]]; do
	arg="$1"
	case "$arg" in
		--target)
			TARGET="`realpath "$2"`"
			shift
			;;
		--download)
			INSTALL="install_download"
			SOURCE="$2" # $HOME/Downloads/Unreal Tournament v451wx2 (Intel).zip
			shift
			;;
		--cd)
			INSTALL="install_cd"
			SOURCE="$2" # /media/$USER/UT_GOTY_CD1/Setup.exe
			shift
			;;
		*)
			echo "unknown option $arg"
			exit 1
			;;
	esac
	shift
done

export WINEPREFIX="$TARGET"
export WINEARCH=win32
wineboot --init

$INSTALL

cd "$TARGET"
echo '#!/bin/bash' > start.sh
echo "WINEPREFIX=\"$TARGET\" wine c:\\\\UnrealTournament\\\\System\\\\UnrealTournament.exe" >> start.sh 
chmod +x start.sh
