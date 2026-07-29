#!/bin/bash -e

TEMP_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/qrun/"
CACHE_AMOUNT=30

if [ "$#" -lt 1 ]; then
  echo "Argument not found."
  echo -e "Format: qrun \033[4mfile\033[24m"
  exit 1
fi

# 入力ファイルの存在確認
if [ ! -f "$1" ]; then
  echo "File not found."
  exit 1
fi

# インタープリタ言語
case "$1" in
*.rb)
  exec ruby "$1" "${@:2}"
  ;;
*.py)
  exec uv run "$1" "${@:2}"
  ;;
*.go)
  exec go run "$1" "${@:2}"
  ;;
*.js)
  exec node "$1" "${@:2}"
  ;;
*.ts)
  exec bun "$1" "${@:2}"
  # exec npx tsx "$1" "${@:2}"
  ;;
*.exs)
  exec elixir "$1" "${@:2}"
  ;;
esac

# キャッシュディレクトリを作成
mkdir -p "${TEMP_DIR}"

# SHA256計算
HASH=$(sha256sum "$1" | cut -d' ' -f1)

# キャッシュがなければビルド
if [ ! -f "${TEMP_DIR}${HASH}" ]; then
  SRC_FILE=$(realpath "$1")
  WORK_DIR="/tmp/qrun-${HASH}"

  mkdir -p "${WORK_DIR}"
  trap 'rm -rf "${WORK_DIR}"' EXIT

  if ! (
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
      echo "Extension should be: .c .cpp .rs .hs .rb .py .go"
      exit 1
      ;;
    esac
  ) then
    exit 1
  fi
fi

touch "${TEMP_DIR}${HASH}"

# 古いファイルを消す
# shellcheck disable=SC2012,SC2004
ls -1t "${TEMP_DIR}" | tail -n +$(($CACHE_AMOUNT + 1)) | xargs -r -I{} rm -- "${TEMP_DIR}{}"

# バイナリ実行
"${TEMP_DIR}${HASH}" "${@:2}"
