#!/bin/bash -leE

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${SCRIPT_DIR}"
# shellcheck source=settings.sh
. "${SCRIPT_DIR}/settings.sh"

NCCL_RDMA_SHARP_PLUGINS_DIR="${NCCL_RDMA_SHARP_PLUGINS_DIR:-${WORKSPACE}/_install}"
echo "INFO: NCCL_RDMA_SHARP_PLUGINS_DIR = ${NCCL_RDMA_SHARP_PLUGINS_DIR}"

cd "${WORKSPACE}"

if ! "${WORKSPACE}/autogen.sh"; then
    echo "ERROR: ${WORKSPACE}/autogen.sh failed"
    echo "FAIL"
    exit 1
fi

if ! "${WORKSPACE}/configure" \
    --prefix="${NCCL_RDMA_SHARP_PLUGINS_DIR}" \
    --with-cuda="${CUDA_HOME}" \
    --with-sharp="${HPCX_SHARP_DIR}"; then
    echo "ERROR: ${WORKSPACE}/configure failed"
    echo "FAIL"
    exit 1
fi

if ! make -j install; then
    echo "ERROR: 'make -j install' failed"
    echo "FAIL"
    exit 1
fi

echo "INFO: ${NCCL_RDMA_SHARP_PLUGINS_DIR}:"
find "${NCCL_RDMA_SHARP_PLUGINS_DIR}" -type f

echo "PASS"
