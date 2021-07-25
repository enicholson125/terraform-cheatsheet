variable "zip_sources" {
  default = {
    first_source = {
      source_content = "Some text in my first source"
      filename       = "first_source.txt"
    }

    second_source = {
      source_content = "Some text in my second source."
      filename       = "second_source.txt"
    }
  }
}

data "archive_file" "inline_block_example" {
  type        = "zip"
  output_path = "example.zip"

  # Generates two inline blocks of the form:
  # source {
  #   content = <content>
  #   filename = <filename>
  # }
  dynamic "source" {
    for_each = var.zip_sources

    content {
      content  = source.value["source_content"]
      filename = source.value["filename"]
    }
  }
}
