#!/usr/bin/env bash
set -e

cd "$(dirname $0)"
cd "$(pwd -P)/stage1"

echo "Building stage1..."
time docker build -t ccondit/linuxfromscratch-stage1-build .

echo "Starting temporary container for export..."
docker run --name=linuxfromscratch-stage1-tmp ccondit/linuxfromscratch-stage1-build

echo "Exporting filesystem..."
docker export linuxfromscratch-stage1-tmp | gzip -c > ../linuxfromscratch-stage1.tar.gz

echo "Removing temporary resources..."
docker stop linuxfromscratch-stage1-tmp
docker rm linuxfromscratch-stage1-tmp
docker rmi ccondit/linuxfromscratch-stage1-build

echo "Loading squashed stage1..."
docker import \
        --change 'ENV PATH /bin:/sbin:/usr/bin:/usr/sbin' \
        --change 'CMD ["/bin/bash"]' \
        ../linuxfromscratch-stage1.tar.gz ccondit/linuxfromscratch

echo "Final image generated."


