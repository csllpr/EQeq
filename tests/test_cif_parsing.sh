#!/bin/bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

run_case() {
    local source_cif="$1"
    local case_dir="$2"

    mkdir -p "$case_dir"
    cp "$source_cif" "$case_dir/input.cif"

    (
        cd "$case_dir"
        "$repo_root/eqeq" input.cif 1.2 -2.0 3 ewald 2 2 50 \
            "$repo_root/data/ionizationdata.dat" "$repo_root/data/chargecenters.dat" \
            >/dev/null 2>eqeq.log
    )

    test -f "$case_dir/input.cif_EQeq_ewald_1.20_-2.00.cif"
    test -f "$case_dir/input.cif_EQeq_ewald_1.20_-2.00.json"
}

run_case "$repo_root/debug/data_C.cif" "$tmpdir/debug_case"
run_case "$repo_root/examples/IRMOF1/IRMOF1.cif" "$tmpdir/irmof1_case"

echo "CIF parsing regression checks passed."
