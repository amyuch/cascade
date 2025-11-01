#!/usr/bin/env bash
# =============================================================================
#  Cascade environment  --  Verilator edition  (user: amax)
# =============================================================================

# --- 1. 定位本文件所在目录（兼容 source / bash 调用） ------------------------
if [[ "$0" != "$BASH_SOURCE" && -n "$BASH_SOURCE" ]]; then
    # 被 source
    META_ROOT=$(dirname $(realpath -- "$BASH_SOURCE"))
else
    # 被 bash 执行
    META_ROOT=$(cd "$(dirname "$0")" && pwd -P)
fi
export CASCADE_META_ROOT=$META_ROOT
echo "[CASCADE] meta repo root: $CASCADE_META_ROOT"

# --- 2. 基础目录 --------------------------------------------------------------
export CASCADE_DESIGN_PROCESSING_ROOT=$CASCADE_META_ROOT/design-processing
unset CASCADE_DESIGN                 # 默认不选 design

# --- 3. 工具链统一放在 /home/AM/chipyard 预编译目录 ----------------------------
CHIPYARD_ROOT=/home/AM/chipyard/chipyard/
export VERILATOR_ROOT=/usr/local/bin/
export RISCV=$CHIPYARD_ROOT/riscv-tools
export YOSYS_ROOT=$CHIPYARD_ROOT/tools/yosys-install/bin
export SV2V_ROOT=$CHIPYARD_ROOT/tools/sv2v-Linux

# --- 4. 实验数据 / Python-venv / Rust ----------------------------------------
export CASCADE_DATADIR=/home/AM/prefuzz/cascade/cascade-data          # 大容量数据
export CASCADE_PYTHON_VENV=$CHIPYARD_ROOT/python-venv-cascade
export CARGO_HOME=$CHIPYARD_ROOT/.cargo
export RUSTUP_HOME=$CHIPYARD_ROOT/.rustup

# --- 5. 并行度 & FD ----------------------------------------------------------
export CASCADE_JOBS=$(nproc)          # 自动取 CPU 核数
ulimit -n 65535                       # 开大文件句柄

# --- 6. 通用 Python 脚本 / Yosys 脚本 ----------------------------------------
export CASCADE_PYTHON_COMMON=$CASCADE_DESIGN_PROCESSING_ROOT/common/python_scripts
export CASCADE_YS=$CASCADE_DESIGN_PROCESSING_ROOT/common/yosys

# --- 7. RISC-V 配置 ----------------------------------------------------------
export CASCADE_RISCV_BITWIDTH=64
export CASCADE_PK64=$RISCV/riscv64-unknown-elf/bin/pk
export CASCADE_GCC=riscv64-unknown-elf-gcc
export CASCADE_OBJDUMP=riscv64-unknown-elf-objdump

# --- 8. PATH 拼装（我们的工具优先） ------------------------------------------
PATH=$VERILATOR_ROOT/bin:$PATH
PATH=$SV2V_ROOT/bin:$PATH
PATH=$YOSYS_ROOT/bin:$PATH
PATH=$RISCV/bin:$PATH
PATH=$CARGO_HOME/bin:$PATH
PATH=$CASCADE_PYTHON_VENV/bin:$PATH
export PATH

# --- 9. 其他 -----------------------------------------------------------------
export MPLCONFIGDIR=/home/AM/.matplotlib-cache
mkdir -p "$MPLCONFIGDIR"

# --- 10. 标记已 source -------------------------------------------------------
export CASCADE_ENV_SOURCED=yes
export CASCADE_ENV_VERSION=2        # 版本号升级，方便检测

# --- 11. 按 hostname 微调（示例） -------------------------------------------
HOSTNAME=$(hostname)
case "$HOSTNAME" in
    amax* )
        # 如果是主服务器，已按上面默认配置
        ;;
    * )
        # 其它机器可自行追加
        ;;
esac