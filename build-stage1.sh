#!/usr/bin/env bash
set -e

cd "$(dirname $0)"
cd "$(pwd -P)/stage1"

echo "Building stage1..."
time docker build -t ccondit/linuxfromscratch-stage1-build .

