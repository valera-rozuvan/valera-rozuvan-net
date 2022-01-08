#!/bin/bash

set -o errexit
set -o pipefail

function hndl_SIGHUP() {
  echo "Unfortunately, the script received SIGHUP..."
  exit 1
}
function hndl_SIGINT() {
  echo "Unfortunately, the script received SIGINT..."
  exit 1
}
function hndl_SIGQUIT() {
  echo "Unfortunately, the script received SIGQUIT..."
  exit 1
}
function hndl_SIGABRT() {
  echo "Unfortunately, the script received SIGABRT..."
  exit 1
}
function hndl_SIGTERM() {
  echo "Unfortunately, the script received SIGTERM..."
  exit 1
}

trap hndl_SIGHUP SIGHUP
trap hndl_SIGINT SIGINT
trap hndl_SIGQUIT SIGQUIT
trap hndl_SIGABRT SIGABRT
trap hndl_SIGTERM SIGTERM

# ----------------------------------------------------------------------------------------------

if [ $# -eq 0 ]; then
  echo "Error! No arguments supplied."
  exit 1
fi

SITE_BASE_URL="${1}"
BUILD_DIR="${2}"

if [ -z "${SITE_BASE_URL}" ]; then
  echo "Error! Provide 1st argument - the Base URL. It should not be an empty string."
  exit 1
fi

if [ -z "${BUILD_DIR}" ]; then
  echo "Error! Provide 2nd argument - the Build Directory. It should not be an empty string."
  exit 1
fi

mkdir -p "${BUILD_DIR}"
rm -rf "${BUILD_DIR:?}/*"
rm -rf "${BUILD_DIR:?}/.*"

cp --recursive ./css "${BUILD_DIR}"
cp --recursive ./images "${BUILD_DIR}"

cp ./images/favicon.ico "${BUILD_DIR}"
rm -rf "${BUILD_DIR}"/images/favicon.ico

cp ./.gitignore "${BUILD_DIR}"
cp ./CNAME "${BUILD_DIR}"

mkdir -p ./tmp

SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/page.template.erb >./tmp/page.template

extension=".md"

for f in _sources/*"${extension}"; do
  filename=$(basename "$f" $extension)
  mkdir -p "${BUILD_DIR}/${filename}"

  pandoc "$f" -f markdown+smart --toc-depth=3 --toc --eol=lf --template ./tmp/page.template -s -o "${BUILD_DIR}/${filename}/index.html"
done

SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/index.md.erb >./tmp/index.md
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/welcome.md.erb >./tmp/welcome.md
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/toc.md.erb >./tmp/toc.md
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/how-this-site-is-built.md.erb >./tmp/how-this-site-is-built.md
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/license.md.erb >./tmp/license.md

pandoc \
  ./tmp/index.md \
  ./tmp/welcome.md \
  ./tmp/toc.md \
  ./tmp/how-this-site-is-built.md \
  ./tmp/license.md \
  -f markdown+smart --toc-depth=3 --toc --eol=lf --template ./tmp/page.template -s \
  -o "${BUILD_DIR}/index.html"
