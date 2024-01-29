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
rm -rf "${BUILD_DIR:?}"/*
rm -rf "${BUILD_DIR}"/.gitignore

cp --recursive ./.gitignore ./css ./images ./favicon.ico ./CNAME "${BUILD_DIR}"

mkdir -p ./tmp
rm -rf ./tmp/*

# content templates
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/content/index.md.erb >./tmp/index.md
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/content/welcome.md.erb >./tmp/welcome.md
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/content/site-shards.md.erb >./tmp/site-shards.md
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/content/thoughts-and-ideas.md.erb >./tmp/thoughts-and-ideas.md
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/content/how-this-site-is-built.md.erb >./tmp/how-this-site-is-built.md
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/content/license.md.erb >./tmp/license.md

# util templates
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/util/sample-code.md.erb >./tmp/sample-code.md
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/util/highlighting-css.template.erb >./tmp/highlighting-css.template
SITE_BASE_URL="${SITE_BASE_URL}" erb ./_templates/util/page.template.erb >./tmp/page.template

for f in _sources/*.md; do
  filename=$(basename "$f" ".md")
  mkdir -p "${BUILD_DIR}/${filename}"

  pandoc \
    "$f" \
    -f markdown+smart+link_attributes+backtick_code_blocks --highlight-style tango --eol=lf --toc-depth=3 --toc -s \
    --template ./tmp/page.template \
    -o "${BUILD_DIR}/${filename}"/index.html
done

pandoc \
  ./tmp/index.md \
  ./tmp/sample-code.md \
  -f markdown+smart+link_attributes+backtick_code_blocks --highlight-style tango --eol=lf --toc-depth=3 --toc -s \
  --template ./tmp/highlighting-css.template \
  -o "${BUILD_DIR}"/css/highlight.css

pandoc \
  ./tmp/index.md \
  ./tmp/welcome.md \
  ./tmp/site-shards.md \
  ./tmp/thoughts-and-ideas.md \
  ./tmp/how-this-site-is-built.md \
  ./tmp/license.md \
  -f markdown+smart+link_attributes+backtick_code_blocks --highlight-style tango --eol=lf --toc-depth=3 --toc -s \
  --template ./tmp/page.template \
  -o "${BUILD_DIR}"/index.html

rm -rf ./tmp

echo "Done!"
exit 0
