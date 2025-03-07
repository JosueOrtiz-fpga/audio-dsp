import subprocess
import os
from pathlib import Path
import sys
sys.path.append("C:\\vunit")
from vunit import VUnit




MODELSIM_INSTALL = "\\intelFPGA\\20.1\\modelsim_ase\\win32aloem"
VLIB_EXE = MODELSIM_INSTALL + "\\vlib.exe"
VMAP_EXE = MODELSIM_INSTALL + "\\vmap.exe"
VLOG_EXE = MODELSIM_INSTALL + "\\vlog.exe"

os.environ['VUNIT_MODELSIM_PATH'] = MODELSIM_INSTALL
os.environ['VUNIT_SIMULATOR'] = "modelsim"

# ROOT
ROOT = Path(__file__).resolve().parent
# Sources path for DUT
DUT_PATH = ROOT / "../../i2s_axis"
# Sources path for TB
TB_PATH = ROOT

VU = VUnit.from_argv()
VU.add_verilog_builtins()

# create design library
design_lib = VU.add_library("lib_i2s_axis")
# add design source files to design_lib
design_lib.add_source_files([DUT_PATH / "*.sv"])
 
# create testbench library
tb_lib = VU.add_library("lib_tb_i2s_axis")
# add testbench source files to tb_lib
tb_lib.add_source_files([TB_PATH / "*.sv"])

VU.main()
