set -e

TARGET="$HOME/Programs/UnrealTournament"
if [ -d "$TARGET/drive_c/UnrealTournament" ]; then
	TARGET="$TARGET/drive_c/UnrealTournament"
fi

UNZIP="unzip -q -u"

function do_install {
	zipinfo -1 "$1" | while read line; do
		case "${line##*.}" in
			unr)
				echo "unzip     $1/$line"
				$UNZIP "$1" "$line" -d "$TARGET/Maps"
				;;
			utx)
				echo "unzip     $1/$line"
				$UNZIP "$1" "$line" -d "$TARGET/Textures"
				;;
			umx)
				echo "unzip     $1/$line"
				$UNZIP "$1" "$line" -d "$TARGET/Music"
				;;
			uax)
				echo "unzip     $1/$line"
				$UNZIP "$1" "$line" -d "$TARGET/Sounds"
				;;
			umod)
				echo "$(tput setaf 6)umod$(tput sgr0)      $1/$line"
				WORK=$(mktemp -d umod.XXXXXX)
				$UNZIP "$1" "$line" -d "$WORK"
				umod -b "$TARGET" -i "$WORK/$line"
				rm -rf "$WORK"
				;;
			txt|htm|html|jpg|*/)
				echo "$(tput setaf 8)skipping$(tput sgr0)  $1/$line"
				;;
			*)
				echo "$(tput setaf 1)unhandled$(tput sgr0) $1/$line"
				;;
		esac
	done
}

while [[ $# > 0 ]]; do
	arg="$1"
	case "$arg" in
		--target)
			TARGET="`realpath "$2"`"
			shift
			;;
		*)
			do_install "$arg"
			;;
	esac
	shift
done
