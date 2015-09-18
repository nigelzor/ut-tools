#!/bin/bash
DOWNLOAD="$HOME/Downloads/Unreal Tournament v451wx2 (Intel).zip"
TARGET="$HOME/Programs/UnrealTournament"

while [[ $# > 0 ]]; do
	arg="$1"
	case "$arg" in
		--download)
			DOWNLOAD="$2"
			shift
			;;
		--target)
			TARGET="`realpath "$2"`"
			shift
			;;
		*)
			echo "unknown option $arg"
			exit 1
			;;
	esac
	shift
done

mkdir -p "$TARGET"
WINEPREFIX="$TARGET" WINEARCH=win32 wineboot
cd "$TARGET/drive_c/"

unzip "$DOWNLOAD" "Unreal Tournament (Intel)/Unreal Tournament OS X.app/Contents/Resources/drive_c/UnrealTournament/*"
mv Unreal\ Tournament\ \(Intel\)/Unreal\ Tournament\ OS\ X.app/Contents/Resources/drive_c/UnrealTournament/ ./
rm -rf Unreal\ Tournament\ \(Intel\)/
find UnrealTournament -type d -exec chmod 755 {} \;

cd ..
echo '#!/bin/bash' > start.sh
echo "WINEPREFIX=\"$TARGET\" wine c:\\\\UnrealTournament\\\\System\\\\UnrealTournament.exe" >> start.sh 
chmod +x start.sh
