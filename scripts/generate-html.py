from jinja2 import Environment, FileSystemLoader
import helper_functions as helper


def sanitise_for_html(text: str):
    return text.replace('<', "&lt;").replace('>', "&gt;")


def get_file_contents_and_santitise(filename: str):
    contents = helper.get_file_contents(filename)
    return sanitise_for_html(contents)


def get_tf_output_and_sanitise(filename: str):
    output = helper.get_terraform_output(filename)
    return sanitise_for_html(output)


def generate_index():
    env = Environment(
        loader=FileSystemLoader("templates")
    )
    template = env.get_template("cheatsheet.html")
    # Running actual terraform makes rendering super slow, hence not
    # rendering dynamically. (Plus there's no reason why this can't
    # just be served from a bucket and that's both easier and more
    # secure so generating the html beforehand and stashing it in a
    # bucket is what I'm going with)
    template.globals["get_example_contents"] = get_file_contents_and_santitise
    template.globals["get_terraform_output"] = get_tf_output_and_sanitise
    spec = helper.load_cheatsheet_json()
    return template.render(spec=spec)


if __name__ == "__main__":
    print(generate_index())
