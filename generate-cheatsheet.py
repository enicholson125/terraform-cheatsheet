import json

CHEATSHEET_NAME = "cheatsheet.md"
CHEATSHEET_JSON = "cheatsheet.json"


def add_code_block(code: str):
    return f"```\n{code}\n```\n"


def add_top_heading(heading: str):
    return f"#{heading}\n"


def add_second_heading(heading: str):
    return f"##{heading}\n"


def add_third_heading(heading: str):
    return f"###{heading}\n"


def add_text(text: str):
    return f"{text}\n"


def load_json(json_filename: str):
    with open(json_filename, 'r') as json_file:
        return json.load(json_file)


def get_example_contents(filename: str):
    filename = f"examples/{filename}"
    with open(filename, 'r') as file:
        return file.read()


def generate_cheatsheet_text():
    cheatsheet_spec = load_json(CHEATSHEET_JSON)
    cheatsheet = ""
    for first_heading, second_heading in cheatsheet_spec.items():
        cheatsheet += add_top_heading(first_heading)
        for heading, third_heading in second_heading.items():
            cheatsheet += add_second_heading(heading)
            if len(third_heading) == 1:
                for entry, code_file in third_heading.items():
                    cheatsheet += add_text(entry)
                    cheatsheet += add_code_block(
                        get_example_contents(code_file))
            else:
                for next_heading, entry in third_heading.items():
                    if type(entry) == str:
                        cheatsheet += add_text(next_heading)
                        cheatsheet += add_code_block(
                            get_example_contents(entry))
                    else:
                        cheatsheet += add_third_heading(next_heading)
                        for text, code_file in entry.items():
                            cheatsheet += add_text(text)
                            cheatsheet += add_code_block(
                                get_example_contents(code_file))
    return cheatsheet


def write_to_cheatsheet_file(cheatsheet_text: str):
    with open(CHEATSHEET_NAME, 'w') as file:
        file.write(cheatsheet_text)


if __name__ == "__main__":
    write_to_cheatsheet_file(generate_cheatsheet_text())
