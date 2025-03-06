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
DUT_PATH = ROOT / "../.."
# Sources path for TB
TEST_PATH = ROOT

VU = VUnit.from_argv()
VU.add_verilog_builtins()

# create design library
design_lib = VU.add_library("design_lib")
# add design source files to design_lib
design_lib.add_source_files([DUT_PATH / "*.sv"])
 
# create testbench library
tb_lib = VU.add_library("tb_counter_lib")
# add testbench source files to tb_lib
tb_lib.add_source_files([TEST_PATH / "*.sv"])

VU.main()

# result = subprocess.run([VLIB_EXE, "work"], shell=True, capture_output=True, text=True)
# if(result.returncode !=0):
#     print(result.stdout)
# result = subprocess.run([VMAP_EXE, "work", "work"], shell=True, capture_output=True, text=True)
# if(result.returncode !=0):
#     print(result.stdout)
# result = subprocess.run([VLOG_EXE, "../../counter.sv"], shell=True, capture_output=True, text=True)
# print(result.stdout)
