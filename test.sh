#!/bin/bash

# Path ke direktori root project (sesuaikan jika script tidak di root)
PROJECT_ROOT=$(pwd) # Ini akan menjadi /c/Users/admba/Downloads/a199-flutter-expert-project-main/ditonton

# Daftar modul dan path relatif mereka (dari PROJECT_ROOT)
MODULE_PATHS=(
    "core"
    "features/movies"
    "features/tv"
    "about" # Tambahkan modul lain jika ada
)

# Direktori untuk menyimpan semua file lcov.info sementara
ALL_LCOV_DIR="$PROJECT_ROOT/coverage_all"
mkdir -p "$ALL_LCOV_DIR"

# Direktori output untuk laporan HTML gabungan
HTML_REPORT_DIR="$PROJECT_ROOT/coverage_report_html"

# Path ke genhtml (pastikan ini sama)
GENHTML_PATH="/c/ProgramData/chocolatey/lib/lcov/tools/bin/genhtml"


echo "Memulai pengujian dan pengumpulan cakupan untuk semua modul..."

for REL_PATH in "${MODULE_PATHS[@]}"
do
    MODULE_FULL_PATH="$PROJECT_ROOT/$REL_PATH"
    MODULE_NAME=$(basename "$REL_PATH")

    echo "--------------------------------------------------------"
    echo "Menguji modul: $MODULE_NAME di $MODULE_FULL_PATH"
    echo "--------------------------------------------------------"

    if [ -d "$MODULE_FULL_PATH" ]; then
        cd "$MODULE_FULL_PATH" || { echo "Gagal masuk ke $MODULE_FULL_PATH"; exit 1; }

        rm -rf coverage

        flutter test --coverage

        if [ -f "coverage/lcov.info" ]; then
            echo "File lcov.info ditemukan untuk $MODULE_NAME. Menyesuaikan dan menyalin..."
            # Baca file lcov.info, konversi path SF: menjadi absolut Unix-style
            # dan simpan ke file sementara
            # Gunakan realpath untuk mendapatkan path absolut
            # Gunakan sed untuk memastikan semua backslash dikonversi ke forward slash
            # Hati-hati dengan path yang sudah absolut dan yang relatif
            cat coverage/lcov.info | while IFS= read -r line; do
                if [[ "$line" =~ ^SF:(.*)$ ]]; then
                    # Tangkap bagian setelah SF:
                    FILE_PATH_LCOV="${BASH_REMATCH[1]}"
                    # Konversi path relatif/Windows ke path absolut Unix-style
                    # Ini akan menghasilkan something like /c/Users/.../ditonton/features/tv/lib/data/datasources/tv_remote_data_source.dart
                    ABSOLUTE_UNIX_PATH=$(cd "$(dirname "$FILE_PATH_LCOV")" && pwd -P)/$(basename "$FILE_PATH_LCOV")
                    echo "SF:$ABSOLUTE_UNIX_PATH"
                else
                    echo "$line"
                fi
            done > "$ALL_LCOV_DIR/${MODULE_NAME}_lcov.info"
        else
            echo "Peringatan: File lcov.info tidak ditemukan untuk $MODULE_NAME."
        fi

        cd "$PROJECT_ROOT" || { echo "Gagal kembali ke $PROJECT_ROOT"; exit 1; }
    else
        echo "Peringatan: Direktori modul '$MODULE_FULL_PATH' tidak ditemukan. Melewati."
    fi
done

echo "--------------------------------------------------------"
echo "Menggabungkan file cakupan..."
echo "--------------------------------------------------------"

# Gabungkan semua file lcov.info yang sudah disesuaikan menjadi satu
COMBINED_LCOV_FILE="$ALL_LCOV_DIR/combined_lcov.info"
> "$COMBINED_LCOV_FILE"

for LCOV_FILE in "$ALL_LCOV_DIR"/*.info
do
    cat "$LCOV_FILE" >> "$COMBINED_LCOV_FILE"
done

rm -rf "$HTML_REPORT_DIR"
mkdir -p "$HTML_REPORT_DIR"

echo "--------------------------------------------------------"
echo "Menghasilkan laporan HTML cakupan..."
echo "--------------------------------------------------------"

if [ -f "$COMBINED_LCOV_FILE" ]; then
    "$GENHTML_PATH" "$COMBINED_LCOV_FILE" \
    --output-directory "$HTML_REPORT_DIR" \
    --prefix "$PROJECT_ROOT/" \
    --rc lcov_branch_coverage=1 \
    --rc lcov_function_coverage=1 \
    --rc lcov_hide_timestamp=1 \
    --title "Laporan Cakupan Kode Ditonton"

    echo "Laporan HTML cakupan berhasil dibuat di: $HTML_REPORT_DIR/index.html"
    echo "Membuka laporan di browser..."

    WINDOWS_HTML_PATH=$(cygpath -w "$HTML_REPORT_DIR/index.html")
    start "" "$WINDOWS_HTML_PATH"

else
    echo "Error: File cakupan gabungan ($COMBINED_LCOV_FILE) tidak ditemukan. Laporan tidak dapat dihasilkan."
    exit 1
fi

echo "Selesai!"