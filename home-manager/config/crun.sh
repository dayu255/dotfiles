#!/bin/bash -e

TEMP_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/crun/"
CACHE_AMOUNT=30

if [ "$#" -lt 1 ]; then
  echo "Argument not found."
  echo -e "Format: crun \033[4mfile\033[24m"
  exit 1
fi

# 入力ファイルの存在確認
if [ ! -f "$1" ]; then
  echo "File not found."
  exit 1
fi

# キャッシュディレクトリを作成
mkdir -p "${TEMP_DIR}"

# SHA256計算
HASH=$(sha256sum "$1" | cut -d' ' -f1)

# キャッシュがなければビルド
if [ ! -f  "${TEMP_DIR}${HASH}" ]; then
  SRC_FILE=$(realpath "$1")
  WORK_DIR="/tmp/crun-${HASH}"

  mkdir -p "${WORK_DIR}"
  trap 'rm -rf "${WORK_DIR}"' EXIT

  (
    cd "${WORK_DIR}"
    case "$1" in
      *.c)
        gcc -ansi -Wall -pedantic -o "${TEMP_DIR}${HASH}" "${SRC_FILE}"
        ;;
      *.cpp)
        g++ -std=c++23 -o "${TEMP_DIR}${HASH}" "${SRC_FILE}"
        ;;
      *.rs)
        rustc -o "${TEMP_DIR}${HASH}" "${SRC_FILE}"
        ;;
      *.hs)
        ghc -outputdir . -o "${TEMP_DIR}${HASH}" "${SRC_FILE}"
        ;;
      *)
        echo "File extension is not compatible."
        echo "Extension should be: .c .cpp .rs .hs"
        exit 1
    esac
  )
fi

touch "${TEMP_DIR}${HASH}"

# 古いファイルを消す
# shellcheck disable=SC2012
# shellcheck disable=SC2004
ls -1t "${TEMP_DIR}" | tail -n +$(($CACHE_AMOUNT + 1)) | xargs -r -I{} rm -- "${TEMP_DIR}{}"

# バイナリ実行
"${TEMP_DIR}${HASH}" "${@:2}"

