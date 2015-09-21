#!/usr/bin/env bash
set -e

cd "$(dirname $0)"
cd "$(pwd -P)"

echo "Building stage0..."
time docker build -t ccondit/linuxfromscratch-stage0 .

echo "Starting temporary container for export..."
docker run --name=linuxfromscratch-stage0-tmp ccondit/linuxfromscratch-stage0

echo "Exporting filesystem..."
docker export linuxfromscratch-stage0-tmp | gzip -c > ../linuxfromscratch-stage0.tar.gz

echo "Stage0 generated."
