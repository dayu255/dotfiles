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

# ソースコードのSHA256計算
HASH=$(sha256sum "$1" | cut -d' ' -f1)

# 今回実行するバイナリのパスを入れる変数
EXEC_BIN="${TEMP_DIR}${HASH}"

# キャッシュがなければビルド
if [ ! -f "${TEMP_DIR}${HASH}" ]; then
  SRC_FILE=$(realpath "$1")
  WORK_DIR="/tmp/qrun-${HASH}"

  mkdir -p "${WORK_DIR}"
  # スクリプト終了時にWORK_DIRを削除
  trap 'rm -rf "${WORK_DIR}"' EXIT

  TMP_BIN="${WORK_DIR}/out_bin"
  ERR_LOG="${WORK_DIR}/err.log"

  COMP_STATUS=0
  (
    cd "${WORK_DIR}" || exit 1
    # 2> で標準エラー出力（警告やエラー）を ERR_LOG に書き出す
    case "$1" in
    *.c)
      gcc -fdiagnostics-color=always -ansi -Wall -pedantic -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}"
      ;;
    *.cpp)
      g++ -fdiagnostics-color=always -std=c++23 -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}"
      ;;
    *.rs)
      rustc --color always -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}"
      ;;
    *.hs)
      ghc -fdiagnostics-color=always -outputdir . -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}"
      ;;
    *)
      echo "File extension is not compatible."
      echo "Extension should be: .c .cpp .rs .hs .rb .py .go .js .ts"
      exit 1
      ;;
    esac
  ) || COMP_STATUS=$? exit # statusをCOMP_STATUSに入れる

  # コンパイラの出力を表示
  if [ -f "${ERR_LOG}" ]; then
    cat "${ERR_LOG}" >&2
  fi

  # exit statusが0以外だった場合はここで終了
  if [ $COMP_STATUS -ne 0 ]; then
    exit 1
  fi

  # コンパイル標準エラー出力が0byteかチェック
  if [ -s "${ERR_LOG}" ]; then
    # 警告がある場合、キャッシュせずにTMP_BINを実行
    EXEC_BIN="${TMP_BIN}"
  else
    # 警告がない場合、キャッシュする
    mv "${TMP_BIN}" "${TEMP_DIR}${HASH}"
    touch "${TEMP_DIR}${HASH}"
  fi
else
  # 既にキャッシュが存在する場合は更新日時を新しくする
  touch "${TEMP_DIR}${HASH}"
fi

# 古いファイルを消す
# shellcheck disable=SC2012,SC2004
ls -1t "${TEMP_DIR}" | tail -n +$(($CACHE_AMOUNT + 1)) | xargs -r -I{} rm -- "${TEMP_DIR}{}"

# バイナリ実行
"${EXEC_BIN}" "${@:2}"
