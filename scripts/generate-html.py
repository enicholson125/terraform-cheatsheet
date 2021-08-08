from jinja2 import Environment, FileSystemLoader
import helper_functions


def generate_index():
    env = Environment(
        loader=FileSystemLoader("templates")
    )
    template = env.get_template("cheatsheet.html")
    # Running actual terraform makes rendering super slow, hence not rendering dynamically
    # (Plus there's no reason why this can't just be served from a bucket
    # and that's both easier and more secure so generating the html
    # beforehand and stashing it in a bucket is what I'm going with)
    template.globals["get_example_contents"] = helper_functions.get_file_contents
    template.globals["get_terraform_output"] = helper_functions.get_terraform_output
    spec = helper_functions.load_cheatsheet_json()
    return template.render(spec=spec)


if __name__ == "__main__":
    print(generate_index())
