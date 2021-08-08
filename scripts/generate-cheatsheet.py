import helper_functions

# TODO make so this doesn't have to be run from the root of the directory


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


def get_code_example_and_output_if_present(filename: str):
    if filename == "":
        return ""
    code = add_code_block(helper_functions.get_file_contents(filename))
    output = add_code_block(helper_functions.get_terraform_output(filename))
    return code + add_text("Applying this example outputs:") + output


def generate_cheatsheet_text():
    cheatsheet_spec = helper_functions.load_cheatsheet_json()
    index = add_top_heading("Table of Contents")
    cheatsheet = add_top_heading(cheatsheet_spec["title"])
    for section in cheatsheet_spec["sections"]:
        index += add_top_level_index_entry(section["title"])
        cheatsheet += add_second_heading(section["title"])
        cheatsheet += get_code_example_and_output_if_present(section["code"])
        for subsection in section["subsections"]:
            index += add_second_level_index_entry(subsection["title"])
            cheatsheet += add_third_heading(subsection["title"])
            cheatsheet += get_code_example_and_output_if_present(
                subsection["code"])
            for subsubsection in subsection["subsubsections"]:
                index += add_third_level_index_entry(subsubsection["title"])
                cheatsheet += add_fourth_heading(subsubsection["title"])
                cheatsheet += get_code_example_and_output_if_present(
                    subsubsection["code"])
    return index + cheatsheet


if __name__ == "__main__":
    print(generate_cheatsheet_text())
