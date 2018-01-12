#!/bin/bash
#
# Builds development version of the site.
#
# by Alexander Borsuk <me@alex.bio> from Minsk, Belarus.
#
# Useful debug options:
# -e aborts if any command has failed.
# -u aborts on using unset variable.
# -x prints all executed commands.
# -o pipefail aborts if on any failed pipe operation.
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create a copy of config in a temporary directory and modify it for the dev build.
if [ -z ${TMPDIR+x} ]; then
  TMPDIR=/var/tmp/
fi
DEV_CONFIG="${TMPDIR}dev_config.yaml"
cp "$SCRIPT_DIR/../config.yaml" "$DEV_CONFIG"
# config.yaml production values and their dev replacements for sed:
declare -a toReplace=(
  's|dev_mode: false|dev_mode: true|g'
  's|https://www.vibrobox.com/|https://VibroBox.github.io/preview.com/|g'
  's|https://www.vibrobox.ru/|https://VibroBox.github.io/preview.ru/|g'
)
for sed_param in "${toReplace[@]}"; do
  sed -i .bak "$sed_param" "$DEV_CONFIG"
done

# Build site with modified dev config.
HUGO_CONFIG="$DEV_CONFIG" source "$SCRIPT_DIR/build.sh"

# Remove production CNAME for dev builds.
rm "$SCRIPT_DIR/../public/en/CNAME" "$SCRIPT_DIR/../public/ru/CNAME"
