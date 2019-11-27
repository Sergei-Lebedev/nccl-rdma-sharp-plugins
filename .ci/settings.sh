#!/bin/bash -leE

set -o pipefail

if [ -n "$DEBUG" ]
then
    set -x
fi

CUDA_VERSION="${CUDA_VERSION:-10.1}"
echo "INFO: CUDA_VERSION = ${CUDA_VERSION}"

module load dev/cuda${CUDA_VERSION}
module load hpcx-gcc
module load ml/ci-tools

# It is needed to disable nccl_rdma_sharp_plugin libs from HPC-X
export LD_LIBRARY_PATH=`echo $LD_LIBRARY_PATH | sed -e 's|nccl_rdma_sharp_plugin|nccl_rdma_sharp_pluginX|g'`

TOP_DIR="$(git rev-parse --show-toplevel)"
echo "INFO: TOP_DIR = ${TOP_DIR}"

echo "INFO: CUDA_HOME = ${CUDA_HOME}"
echo "INFO: HPCX_SHARP_DIR = ${HPCX_SHARP_DIR}"
echo "INFO: HPCX_DIR = ${HPCX_DIR}"
echo "INFO: WORKSPACE = ${WORKSPACE}"

HOSTNAME=`hostname -s`
echo "INFO: HOSTNAME = $HOSTNAME"

WORKSPACE="${WORKSPACE:-${TOP_DIR}}"

CI_DIR="${WORKSPACE}/.ci"

if [ ! -d "${HPCX_DIR}" ]
then
    echo "ERROR: ${HPCX_DIR} does not exist or not accessible"
    echo "FAIL"
    exit 1
fi