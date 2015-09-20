set -e

TARGET="$HOME/Programs/UnrealTournament"
if [ -d "$TARGET/drive_c/UnrealTournament" ]; then
	TARGET="$TARGET/drive_c/UnrealTournament"
fi

function do_install {
	local ARCHIVE=$(basename $1)
	local WORK=$(mktemp -d umod.XXXXXX)
	unzip -q "$1" -d "$WORK"
	find "$WORK" -type f | while read FILE; do
		case "${FILE##*.}" in
			unr)
				echo "copy      $ARCHIVE/${FILE#$WORK/}"
				cp "$FILE" "$TARGET/Maps"
				;;
			utx)
				echo "copy      $ARCHIVE/${FILE#$WORK/}"
				cp "$FILE" "$TARGET/Textures"
				;;
			umx)
				echo "copy      $ARCHIVE/${FILE#$WORK/}"
				cp "$FILE" "$TARGET/Music"
				;;
			uax)
				echo "copy      $ARCHIVE/${FILE#$WORK/}"
				cp "$FILE" "$TARGET/Sounds"
				;;
			u|int|ini)
				echo "copy      $ARCHIVE/${FILE#$WORK/}"
				cp "$FILE" "$TARGET/System"
				;;
			umod)
				echo "$(tput setaf 6)umod$(tput sgr0)      $ARCHIVE/${FILE#$WORK/}"
				umod -b "$TARGET" -i "$FILE"
				;;
			txt|htm|html|jpg)
				echo "$(tput setaf 8)skipping$(tput sgr0)  $ARCHIVE/${FILE#$WORK/}"
				;;
			*)
				echo "$(tput setaf 1)unhandled$(tput sgr0) $ARCHIVE/${FILE#$WORK/}"
				;;
		esac
	done
	rm -rf "$WORK"
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
