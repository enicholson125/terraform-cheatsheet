import json

CHEATSHEET_NAME = "cheatsheet.md"
CHEATSHEET_JSON = "cheatsheet.json"


def add_code_block(code):
    return f"```\n{code}\n```"


def load_json():
    with open(CHEATSHEET_JSON, 'r') as json_file:
        return json.load(json_file)


if __name__ == "__main__":
    print(load_json())
