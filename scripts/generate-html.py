from jinja2 import Environment, FileSystemLoader
import json


def generate_index():
    env = Environment(
        loader=FileSystemLoader("templates")
    )
    template = env.get_template("cheatsheet.html")
    with open("cheatsheet.json", 'r') as json_file:
        spec = json.load(json_file)
    return template.render(spec=spec)


if __name__ == "__main__":
    print(generate_index())
