#!/bin/bash -e

TEMP_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/qrun/"
CACHE_AMOUNT=30

SHOW_TIME=0
NO_CACHE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
  -tn | -nt)
    SHOW_TIME=1
    NO_CACHE=1
    shift
    ;;
  -h | --help)
    echo -e "Format: qrun [-t|--time] [-n|--no-cache] \033[4mfile\033[24m"
    exit 0
    ;;
  -t | --time)
    SHOW_TIME=1
    shift
    ;;
  -n | --no-cache)
    NO_CACHE=1
    shift
    ;;
  -*)
    echo "Unknown option: $1"
    exit 1
    ;;
  *)
    break
    ;;
  esac
done

if [ "$#" -lt 1 ]; then
  echo "Argument not found."
  echo -e "Format: qrun [-t|--time] \033[4mfile\033[24m"
  exit 1
fi

if [ ! -f "$1" ]; then
  echo "File not found."
  exit 1
fi

CMD=()
case "$1" in
*.rb) CMD=(ruby "$1" "${@:2}") ;;
*.py) CMD=(uv run "$1" "${@:2}") ;;
*.go) CMD=(go run "$1" "${@:2}") ;;
*.js) CMD=(node "$1" "${@:2}") ;;
*.ts) CMD=(bun "$1" "${@:2}") ;;
*.exs) CMD=(elixir "$1" "${@:2}") ;;
esac

if [ ${#CMD[@]} -gt 0 ]; then
  if [ "$SHOW_TIME" -eq 1 ]; then
    TIMEFORMAT=$'\e[90m[Execution time: %3Rs]\e[0m'
    time "${CMD[@]}"
    exit $?
  else
    exec "${CMD[@]}"
  fi
fi

mkdir -p "${TEMP_DIR}"
HASH=$(sha256sum "$1" | cut -d' ' -f1)
EXEC_BIN="${TEMP_DIR}${HASH}"

if [ ! -f "${TEMP_DIR}${HASH}" ] || [ "$NO_CACHE" -eq 1 ]; then
  SRC_FILE=$(realpath "$1")
  WORK_DIR="/tmp/qrun-${HASH}"
  mkdir -p "${WORK_DIR}"
  trap 'rm -rf "${WORK_DIR}"' EXIT
  TMP_BIN="${WORK_DIR}/out_bin"
  ERR_LOG="${WORK_DIR}/err.log"
  COMP_STATUS=0

  if [ "$SHOW_TIME" -eq 1 ]; then
    TIMEFORMAT=$'\e[90m[Compile time: %3Rs]\e[0m'
    time (
      cd "${WORK_DIR}" || exit 1
      case "$1" in
      *.c) gcc -fdiagnostics-color=always -ansi -Wall -pedantic -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}" ;;
      *.cpp) g++ -fdiagnostics-color=always -std=c++23 -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}" ;;
      *.rs) rustc --color always -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}" ;;
      *.hs) ghc -fdiagnostics-color=always -outputdir . -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}" ;;
      *)
        echo "File extension is not compatible."
        exit 1
        ;;
      esac
    ) || COMP_STATUS=$?
  else
    (
      cd "${WORK_DIR}" || exit 1
      case "$1" in
      *.c) gcc -fdiagnostics-color=always -ansi -Wall -pedantic -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}" ;;
      *.cpp) g++ -fdiagnostics-color=always -std=c++23 -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}" ;;
      *.rs) rustc --color always -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}" ;;
      *.hs) ghc -fdiagnostics-color=always -outputdir . -o "${TMP_BIN}" "${SRC_FILE}" 2>"${ERR_LOG}" ;;
      *)
        echo "File extension is not compatible."
        exit 1
        ;;
      esac
    ) || COMP_STATUS=$?
  fi

  if [ -f "${ERR_LOG}" ]; then
    cat "${ERR_LOG}" >&2
  fi
  if [ $COMP_STATUS -ne 0 ]; then
    exit 1
  fi
  if [ -s "${ERR_LOG}" ]; then
    EXEC_BIN="${TMP_BIN}"
  else
    mv "${TMP_BIN}" "${TEMP_DIR}${HASH}"
    touch "${TEMP_DIR}${HASH}"
  fi
else
  if [ "$SHOW_TIME" -eq 1 ]; then
    echo -e "\033[90m[Compile time: \e[3mCached\e[0m\033[90m]\033[0m" >&2
  fi
  touch "${TEMP_DIR}${HASH}"
fi

# shellcheck disable=SC2012,SC2004
ls -1t "${TEMP_DIR}" | tail -n +$(($CACHE_AMOUNT + 1)) | xargs -r -I{} rm -- "${TEMP_DIR}{}"

if [ "$SHOW_TIME" -eq 1 ]; then
  TIMEFORMAT=$'\e[90m[Execution time: %3Rs]\e[0m'
  time "${EXEC_BIN}" "${@:2}"
else
  exec "${EXEC_BIN}" "${@:2}"
fi
