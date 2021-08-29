import os
import shutil
import subprocess
import json

MAIN_TF_FILE = "examples/terraform/main.tf"
EXAMPLE_MODULE_FILE = "examples/example_module/main.tf"
CHEATSHEET_JSON = "cheatsheet.json"


def load_cheatsheet_json():
    with open(CHEATSHEET_JSON, 'r') as json_file:
        return json.load(json_file)


def get_file_contents(filename: str):
    if filename == "":
        return ""
    with open(filename, 'r') as file:
        return file.read()


def get_terraform_output(filename: str):
    if filename == "":
        return ""
    tmp_dir = "tmp_terraform"
    os.mkdir(tmp_dir)
    try:
        shutil.copyfile(filename, f"{tmp_dir}/example.tf")
        shutil.copyfile(MAIN_TF_FILE, f"{tmp_dir}/main.tf")
        example_module_path = f"{tmp_dir}/example_module"
        os.mkdir(example_module_path)
        shutil.copyfile(EXAMPLE_MODULE_FILE, f"{example_module_path}/main.tf")
        subprocess.run(["terraform", f"-chdir={tmp_dir}", "init"],
                       stdout=subprocess.PIPE)
        output = subprocess.run(
            ["terraform", f"-chdir={tmp_dir}",
                "apply", "-auto-approve", "-no-color"],
            stdout=subprocess.PIPE).stdout.decode()
    except:  # noqa
        # make sure we clean up the temp directory
        shutil.rmtree(tmp_dir)
        raise
    shutil.rmtree(tmp_dir)
    return output
