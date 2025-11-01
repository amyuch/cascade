# test.py（仅修改导入和设计架构获取逻辑，其他代码不变）
from mutation.fuzzerstate import FuzzerState
# 1. 移除 get_design_isa 导入，仅保留 get_design_boot_addr 和 get_design_cfg
from common.designcfgs import get_design_boot_addr, get_design_cfg
from mutation.basicblock import gen_basicblocks
from mutation.genelf import gen_elf_from_bbs
import subprocess

def main():
    # 1. 配置参数（不变）
    design_name = "boom"  # 目标 CPU 设计名称（如 vexriscv/boom）
    randseed = 12345
    memsize = 1 << 20
    nmax_bbs = 5
    authorize_privileges = False
    check_pc_spike_again = True

    # 2. 修复：通过 get_design_cfg 获取设计配置字典，再提取架构信息
    design_cfg = get_design_cfg(design_name)  # 获取该设计的所有配置
    design_base_addr = get_design_boot_addr(design_name)  # 原有启动地址获取逻辑不变
    # 从配置字典中提取架构（键名可能是 "isa" 或 "arch"，若报错需调整键名）
    design_isa = design_cfg.get("isa", "rv64g")  # 默认值 rv64g，避免键不存在报错

    # 3. 初始化 FuzzerState（不变）
    fuzzer_state = FuzzerState(
        design_base_addr=design_base_addr,
        design_name=design_name,
        memsize=memsize,
        randseed=randseed,
        nmax_bbs=nmax_bbs,
        authorize_privileges=authorize_privileges
    )
    # 补充架构信息（使用从 design_cfg 提取的 design_isa）
    fuzzer_state.design_isa = design_isa

    # 后续生成基本块、ELF、验证 Spike 的代码完全不变...
    gen_basicblocks(fuzzer_state)
    elf_path = gen_elf_from_bbs(
        fuzzerstate=fuzzer_state,
        is_spike_resolution=False,
        prefixname='test',
        test_identifier=fuzzer_state.instance_to_str(),
        start_addr=fuzzer_state.design_base_addr
    )

    print(f"生成的 ELF 文件路径：{elf_path}")
    # ...

if __name__ == "__main__":
    main()