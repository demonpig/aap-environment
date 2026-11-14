#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if ! command -v terraform >/dev/null 2>&1 && ! command -v tofu >/dev/null 2>&1; then
  echo "Neither Terraform nor OpenTofu was found on PATH. Install one and rerun ./setup.sh." >&2
  exit 1
fi

VENV_DIR="$ROOT_DIR/.env"
VENV_PYTHON="$VENV_DIR/bin/python"
VENV_PIP="$VENV_DIR/bin/pip"
VENV_ANSIBLE_GALAXY="$VENV_DIR/bin/ansible-galaxy"
VENV_ANSIBLE_INVENTORY="$VENV_DIR/bin/ansible-inventory"
VENV_ANSIBLE_PLAYBOOK="$VENV_DIR/bin/ansible-playbook"
COLLECTIONS_DIR="$ROOT_DIR/.ansible/collections"

if [[ ! -x "$VENV_PYTHON" ]]; then
  echo "Creating Python virtual environment in .env..."
  python3 -m venv "$VENV_DIR"
fi

if ! "$VENV_PYTHON" - <<'PY'
import sys

try:
    import ansible
    import passlib  # noqa: F401
except ImportError:
    sys.exit(1)

version = tuple(int(part) for part in ansible.__version__.split(".")[:2])
if version < (2, 16) or version >= (2, 17):
    sys.exit(1)
PY
then
  echo "Installing Python dependencies from requirements.txt..."
  "$VENV_PIP" install --disable-pip-version-check -r requirements.txt
fi

if [[ "${1:-}" == "--list" ]]; then
  if [[ $# -ne 1 ]]; then
    echo "Usage: ./setup.sh --list" >&2
    exit 2
  fi

  "$VENV_ANSIBLE_INVENTORY" --list | "$VENV_PYTHON" -c '
import json
import sys

hostvars = json.load(sys.stdin).get("_meta", {}).get("hostvars", {})
if not hostvars:
    raise SystemExit("Terraform inventory contains no hosts.")

hosts = []
missing = []
for hostname, variables in sorted(hostvars.items()):
    address = variables.get("ansible_host")
    if address:
        hosts.append((hostname, address))
    else:
        missing.append(hostname)

if missing:
    raise SystemExit("Terraform inventory has no IP for: " + ", ".join(missing))

for hostname, address in hosts:
    print(f"{hostname} {address}")
'
  exit 0
fi

if ! "$VENV_PYTHON" - "$ROOT_DIR/requirements.yml" "$COLLECTIONS_DIR" <<'PY'
import json
import sys
from pathlib import Path

import yaml

requirements_file = Path(sys.argv[1])
collections_dir = Path(sys.argv[2]) / "ansible_collections"
requirements = yaml.safe_load(requirements_file.read_text()) or {}

for collection in requirements.get("collections", []):
    namespace, name = collection["name"].split(".", 1)
    manifest = collections_dir / namespace / name / "MANIFEST.json"
    if not manifest.is_file():
        sys.exit(1)
    installed = json.loads(manifest.read_text()).get("collection_info", {}).get("version")
    requested = collection.get("version")
    if requested and requested not in ("*", "latest") and installed != requested:
        sys.exit(1)
PY
then
  echo "Installing Ansible Galaxy dependencies from requirements.yml..."
  "$VENV_ANSIBLE_GALAXY" collection install \
    --collections-path "$COLLECTIONS_DIR" \
    -r requirements.yml
fi

echo "Running the baseline playbook..."
exec "$VENV_ANSIBLE_PLAYBOOK" \
  collections/lab/terraform/playbooks/baseline.yml \
  --ask-vault-pass \
  "$@"
