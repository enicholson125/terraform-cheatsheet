import json
import os
import shutil
import subprocess

# TODO make so this doesn't have to be run from the root of the directory

CHEATSHEET_NAME = "cheatsheet.md"
CHEATSHEET_JSON = "cheatsheet.json"

MAIN_TF_FILE = "examples/terraform/main.tf"


def add_code_block(code: str):
    return f"```\n{code}\n```\n"


def add_text(text: str):
    return f"{text}\n"


def add_top_heading(heading: str):
    return f'# {heading}<a name="{heading.replace(" ", "_")}"></a>\n'


def add_second_heading(heading: str):
    return f'## {heading}<a name="{heading.replace(" ", "_")}"></a>\n'


def add_third_heading(heading: str):
    return f'### {heading}<a name="{heading.replace(" ", "_")}"></a>\n'


def add_fourth_heading(heading: str):
    return f'#### {heading}<a name="{heading.replace(" ", "_")}"></a>\n'


def add_top_level_index_entry(entry: str):
    return f' - [{entry}](#{entry.replace(" ", "_")})\n'


def add_second_level_index_entry(entry: str):
    return f'    - [{entry}](#{entry.replace(" ", "_")})\n'


def add_third_level_index_entry(entry: str):
    return f'      - [{entry}](#{entry.replace(" ", "_")})\n'


def load_json(json_filename: str):
    with open(json_filename, 'r') as json_file:
        return json.load(json_file)


def get_file_contents(filename: str):
    with open(filename, 'r') as file:
        return file.read()


def get_terraform_output(filename: str):
    tmp_dir = "tmp_terraform"
    os.mkdir(tmp_dir)
    try:
        shutil.copyfile(filename, f"{tmp_dir}/example.tf")
        shutil.copyfile(MAIN_TF_FILE, f"{tmp_dir}/main.tf")
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


def get_code_example_and_output(example_filename):
    code = add_code_block(get_file_contents(example_filename))
    output = add_code_block(get_terraform_output(example_filename))
    return code + add_text("Applying this example outputs:") + output


def generate_cheatsheet_text():
    cheatsheet_spec = load_json(CHEATSHEET_JSON)
    cheatsheet = ""
    index = add_top_heading("Table of Contents")
    for first_heading, second_heading in cheatsheet_spec.items():
        cheatsheet += add_top_heading(first_heading)
        for heading, third_heading in second_heading.items():
            index += add_top_level_index_entry(heading)
            cheatsheet += add_second_heading(heading)
            # Check if section is subdivided or not
            if type(third_heading) == str:
                cheatsheet += get_code_example_and_output(
                    f"examples/{third_heading}")
            else:
                for heading, entry in third_heading.items():
                    if type(entry) == str:
                        index += add_third_level_index_entry(heading)
                        cheatsheet += add_third_heading(heading)
                        cheatsheet += get_code_example_and_output(
                            f"examples/{entry}")
                    else:
                        index += add_second_level_index_entry(heading)
                        cheatsheet += add_third_heading(heading)
                        for text, code_file in entry.items():
                            index += add_third_level_index_entry(text)
                            cheatsheet += add_fourth_heading(text)
                            cheatsheet += get_code_example_and_output(
                                f"examples/{code_file}")
    return index + cheatsheet


if __name__ == "__main__":
    print(generate_cheatsheet_text())
