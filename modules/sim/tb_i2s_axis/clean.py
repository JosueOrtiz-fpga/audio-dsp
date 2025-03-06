import os
import shutil

dir_path = "vunit_out"
if os.path.exists(dir_path):
    shutil.rmtree(dir_path)
else:
    print(f"Directory '{dir_path}' not found.")
