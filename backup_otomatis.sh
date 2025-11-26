SOURCE="./sumber"
BACKUP="./backup"
LOG_FILE="$BACKUP/backup.log"

echo "menacri file sesuai kriteria..."

FILES=$(find "$SOURCE" -type f \( -name "*.txt" -o -mtime -7 \))

if [ -z "%FILES" ]; then
	echo"tidak ada file yang memenuhi kriteria>"
	echo"[$(date)] - gagal - tidak ada file yang sesuai" >> "$LOG_FILE"
	exit 1
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILELIST="/tmp/filelist_$TIMESTAMP.txt"

echo "$FILES" > "$FILELIST"

BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"

echo "mengompresi file.."

tar -czf "$BACKUP/$BACKUP_NAME" -T "$FILELIST"

if [ $? -ne 0 ]; then
	echo "proses kompresi gagal."
	echo "[$(date)] - gagal - kompresi gagal" >> "$LOG_FILE"
	rm "$FILELIST"
	exit 1
fi

echo "[$(date)] - berhasil - backup dibuat: $BACKUP_NAME" >> "$LOG_FILE"
echo "backup selesai: $BACKUP_NAME"
rm "$FILELIST"
