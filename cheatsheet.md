# Table of Contents<a name="Table_of_Contents"></a>
 - [Loops](#Loops)
    - [for_each](#for_each)
      - [Creating resources](#Creating_resources)
      - [Creating sections within a resource](#Creating_sections_within_a_resource)
    - [count](#count)
      - [Multiple resources from list](#Multiple_resources_from_list)
      - [Flagging resources on and off](#Flagging_resources_on_and_off)
    - [for](#for)
      - [Iterating over lists](#Iterating_over_lists)
      - [Iterating over maps](#Iterating_over_maps)
      - [For loop in a string (string directive)](#For_loop_in_a_string_(string_directive))
    - [Wildcard to reference all resources created (splat)](#Wildcard_to_reference_all_resources_created_(splat))
      - [Created using count](#Created_using_count)
      - [Created using for_each](#Created_using_for_each)
 - [Ternary](#Ternary)
 - [Get path of running terraform code](#Get_path_of_running_terraform_code)
 - [Variable templating (string interpolation)](#Variable_templating_(string_interpolation))
 - [JSON encoding](#JSON_encoding)
# Terraform HCL cheatsheet<a name="Terraform_HCL_cheatsheet"></a>
## Loops<a name="Loops"></a>
### for_each<a name="for_each"></a>
#### Creating resources<a name="Creating_resources"></a>
```
variable "iterator" {
  default = ["2", "5"]
}

resource "random_string" "for_each_example" {
  for_each = toset(var.iterator)

  length = each.value
}

output "strings_created" {
  # Outputs a map of the string resources, keyed by var.iterator values
  value = random_string.for_each_example
}

output "long_string_length" {
  value = random_string.for_each_example["5"].length # 5
}

```
Applying this example outputs:
```

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.for_each_example["2"] will be created
  + resource "random_string" "for_each_example" {
      + id          = (known after apply)
      + length      = 2
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

  # random_string.for_each_example["5"] will be created
  + resource "random_string" "for_each_example" {
      + id          = (known after apply)
      + length      = 5
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + long_string_length = 5
  + strings_created    = {
      + 2 = {
          + id               = (known after apply)
          + keepers          = null
          + length           = 2
          + lower            = true
          + min_lower        = 0
          + min_numeric      = 0
          + min_special      = 0
          + min_upper        = 0
          + number           = true
          + override_special = null
          + result           = (known after apply)
          + special          = true
          + upper            = true
        }
      + 5 = {
          + id               = (known after apply)
          + keepers          = null
          + length           = 5
          + lower            = true
          + min_lower        = 0
          + min_numeric      = 0
          + min_special      = 0
          + min_upper        = 0
          + number           = true
          + override_special = null
          + result           = (known after apply)
          + special          = true
          + upper            = true
        }
    }
random_string.for_each_example["5"]: Creating...
random_string.for_each_example["2"]: Creating...
random_string.for_each_example["5"]: Creation complete after 0s [id=qqvSw]
random_string.for_each_example["2"]: Creation complete after 0s [id=GL]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

long_string_length = 5
strings_created = {
  "2" = {
    "id" = "GL"
    "keepers" = tomap(null) /* of string */
    "length" = 2
    "lower" = true
    "min_lower" = 0
    "min_numeric" = 0
    "min_special" = 0
    "min_upper" = 0
    "number" = true
    "override_special" = tostring(null)
    "result" = "GL"
    "special" = true
    "upper" = true
  }
  "5" = {
    "id" = "qqvSw"
    "keepers" = tomap(null) /* of string */
    "length" = 5
    "lower" = true
    "min_lower" = 0
    "min_numeric" = 0
    "min_special" = 0
    "min_upper" = 0
    "number" = true
    "override_special" = tostring(null)
    "result" = "qqvSw"
    "special" = true
    "upper" = true
  }
}

```
#### Creating sections within a resource<a name="Creating_sections_within_a_resource"></a>
```
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

output "example_output" {
  value = data.archive_file.inline_block_example
}

```
Applying this example outputs:
```

Changes to Outputs:
  + example_output = {
      + excludes                = null
      + id                      = "710215cc9950fa4f3ecb07bac6df6c564b4ea920"
      + output_base64sha256     = "yGvlJr7oIPhHBzxP5HfPu/TdkXOeGI0Ny3v0d1beInA="
      + output_file_mode        = null
      + output_md5              = "3b1349239b5307ba08fca2e22ad43409"
      + output_path             = "example.zip"
      + output_sha              = "710215cc9950fa4f3ecb07bac6df6c564b4ea920"
      + output_size             = 342
      + source                  = [
          + {
              + content  = "Some text in my first source"
              + filename = "first_source.txt"
            },
          + {
              + content  = "Some text in my second source."
              + filename = "second_source.txt"
            },
        ]
      + source_content          = null
      + source_content_filename = null
      + source_dir              = null
      + source_file             = null
      + type                    = "zip"
    }

You can apply this plan to save these new output values to the Terraform
state, without changing any real infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

example_output = {
  "excludes" = toset(null) /* of string */
  "id" = "710215cc9950fa4f3ecb07bac6df6c564b4ea920"
  "output_base64sha256" = "yGvlJr7oIPhHBzxP5HfPu/TdkXOeGI0Ny3v0d1beInA="
  "output_file_mode" = tostring(null)
  "output_md5" = "3b1349239b5307ba08fca2e22ad43409"
  "output_path" = "example.zip"
  "output_sha" = "710215cc9950fa4f3ecb07bac6df6c564b4ea920"
  "output_size" = 342
  "source" = toset([
    {
      "content" = "Some text in my first source"
      "filename" = "first_source.txt"
    },
    {
      "content" = "Some text in my second source."
      "filename" = "second_source.txt"
    },
  ])
  "source_content" = tostring(null)
  "source_content_filename" = tostring(null)
  "source_dir" = tostring(null)
  "source_file" = tostring(null)
  "type" = "zip"
}

```
### count<a name="count"></a>
#### Multiple resources from list<a name="Multiple_resources_from_list"></a>
```
# Better to use for_each if you can, as count makes the resources
# addresses less readable (e.g. random_string.count_basic[0])
# will recreate all the resources if you remove the first one in
# the array (as their index will have changed).
# However, if you do want to use it:

variable "string_lengths" {
  default = [2, 5, 1]
}

resource "random_string" "count_basic" {
  count = length(var.string_lengths)

  length = var.string_lengths[count.index]
}

```
Applying this example outputs:
```

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.count_basic[0] will be created
  + resource "random_string" "count_basic" {
      + id          = (known after apply)
      + length      = 2
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

  # random_string.count_basic[1] will be created
  + resource "random_string" "count_basic" {
      + id          = (known after apply)
      + length      = 5
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

  # random_string.count_basic[2] will be created
  + resource "random_string" "count_basic" {
      + id          = (known after apply)
      + length      = 1
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

Plan: 3 to add, 0 to change, 0 to destroy.
random_string.count_basic[2]: Creating...
random_string.count_basic[1]: Creating...
random_string.count_basic[0]: Creating...
random_string.count_basic[0]: Creation complete after 0s [id=gi]
random_string.count_basic[1]: Creation complete after 0s [id=ksS-[]
random_string.count_basic[2]: Creation complete after 0s [id=q]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

```
#### Flagging resources on and off<a name="Flagging_resources_on_and_off"></a>
```
variable "env" {
  default = "test"
}

resource "random_string" "test_env_only" {
  count  = var.env == "test" ? 1 : 0
  length = 5
}

resource "random_string" "prod_env_only" {
  count  = var.env == "prod" ? 1 : 0
  length = 5
}

output "test_env_only" {
  # We need this ternary or the terraform will fail to plan when
  # var.env != "test" (because random_string.test_env_only[0] will not exist)
  value = var.env == "test" ? random_string.test_env_only[0] : null
}

output "prod_env_only" {
  value = var.env == "prod" ? random_string.prod_env_only[0] : null
}

```
Applying this example outputs:
```

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.test_env_only[0] will be created
  + resource "random_string" "test_env_only" {
      + id          = (known after apply)
      + length      = 5
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + test_env_only = {
      + id               = (known after apply)
      + keepers          = null
      + length           = 5
      + lower            = true
      + min_lower        = 0
      + min_numeric      = 0
      + min_special      = 0
      + min_upper        = 0
      + number           = true
      + override_special = null
      + result           = (known after apply)
      + special          = true
      + upper            = true
    }
random_string.test_env_only[0]: Creating...
random_string.test_env_only[0]: Creation complete after 0s [id=YZgsu]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

test_env_only = {
  "id" = "YZgsu"
  "keepers" = tomap(null) /* of string */
  "length" = 5
  "lower" = true
  "min_lower" = 0
  "min_numeric" = 0
  "min_special" = 0
  "min_upper" = 0
  "number" = true
  "override_special" = tostring(null)
  "result" = "YZgsu"
  "special" = true
  "upper" = true
}

```
### for<a name="for"></a>
#### Iterating over lists<a name="Iterating_over_lists"></a>
```
variable "favourite_vegetables" {
  default = ["Artichoke", "Broccoli", "Potato"]
}

output "vegetable_statements" {
  value = [for veg in var.favourite_vegetables : "${veg} is great."]
}

```
Applying this example outputs:
```

Changes to Outputs:
  + vegetable_statements = [
      + "Artichoke is great.",
      + "Broccoli is great.",
      + "Potato is great.",
    ]

You can apply this plan to save these new output values to the Terraform
state, without changing any real infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

vegetable_statements = [
  "Artichoke is great.",
  "Broccoli is great.",
  "Potato is great.",
]

```
#### Iterating over maps<a name="Iterating_over_maps"></a>
```
variable "vegetable_opinions" {
  default = {
    artichoke   = "great"
    cauliflower = "terrible"
  }
}

output "uppercase_opinions" {
  value = { for veg, opinion in var.vegetable_opinions : upper(veg) => upper(opinion) }
}

```
Applying this example outputs:
```

Changes to Outputs:
  + uppercase_opinions = {
      + ARTICHOKE   = "GREAT"
      + CAULIFLOWER = "TERRIBLE"
    }

You can apply this plan to save these new output values to the Terraform
state, without changing any real infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

uppercase_opinions = {
  "ARTICHOKE" = "GREAT"
  "CAULIFLOWER" = "TERRIBLE"
}

```
#### For loop in a string (string directive)<a name="For_loop_in_a_string_(string_directive)"></a>
```
variable "fruits" {
  default = ["apple", "tangerine", "mango"]
}

output "for_within_string" {
  # ~ character strips empty newlines and whitespace
  value = <<EOF
%{~for fruit in var.fruits}
  ${fruit}
%{~endfor}
EOF
}

```
Applying this example outputs:
```

Changes to Outputs:
  + for_within_string = <<-EOT

          apple
          tangerine
          mango
    EOT

You can apply this plan to save these new output values to the Terraform
state, without changing any real infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

for_within_string = <<EOT

  apple
  tangerine
  mango

EOT

```
### Wildcard to reference all resources created (splat)<a name="Wildcard_to_reference_all_resources_created_(splat)"></a>
#### Created using count<a name="Created_using_count"></a>
```
variable "string_lengths" {
  default = [2, 5, 1]
}

resource "random_string" "splat_count" {
  count = length(var.string_lengths)

  length = var.string_lengths[count.index]
}

output "all_random_strings_created" {
  # Outputs a list of all the random_strings created
  value = random_string.splat_count[*].result
}

```
Applying this example outputs:
```

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.splat_count[0] will be created
  + resource "random_string" "splat_count" {
      + id          = (known after apply)
      + length      = 2
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

  # random_string.splat_count[1] will be created
  + resource "random_string" "splat_count" {
      + id          = (known after apply)
      + length      = 5
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

  # random_string.splat_count[2] will be created
  + resource "random_string" "splat_count" {
      + id          = (known after apply)
      + length      = 1
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + all_random_strings_created = [
      + (known after apply),
      + (known after apply),
      + (known after apply),
    ]
random_string.splat_count[0]: Creating...
random_string.splat_count[2]: Creating...
random_string.splat_count[1]: Creating...
random_string.splat_count[2]: Creation complete after 0s [id=>]
random_string.splat_count[1]: Creation complete after 0s [id=N@iB}]
random_string.splat_count[0]: Creation complete after 0s [id=Bx]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

all_random_strings_created = [
  "Bx",
  "N@iB}",
  ">",
]

```
#### Created using for_each<a name="Created_using_for_each"></a>
```
variable "iterator" {
  default = ["2", "5"]
}

resource "random_string" "for_each_splat" {
  for_each = toset(var.iterator)

  length = each.value
}

output "map_of_resources_created" {
  value = random_string.for_each_splat[*]
}

```
Applying this example outputs:
```

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.for_each_splat["2"] will be created
  + resource "random_string" "for_each_splat" {
      + id          = (known after apply)
      + length      = 2
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

  # random_string.for_each_splat["5"] will be created
  + resource "random_string" "for_each_splat" {
      + id          = (known after apply)
      + length      = 5
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + map_of_resources_created = [
      + {
          + 2 = {
              + id               = (known after apply)
              + keepers          = null
              + length           = 2
              + lower            = true
              + min_lower        = 0
              + min_numeric      = 0
              + min_special      = 0
              + min_upper        = 0
              + number           = true
              + override_special = null
              + result           = (known after apply)
              + special          = true
              + upper            = true
            }
          + 5 = {
              + id               = (known after apply)
              + keepers          = null
              + length           = 5
              + lower            = true
              + min_lower        = 0
              + min_numeric      = 0
              + min_special      = 0
              + min_upper        = 0
              + number           = true
              + override_special = null
              + result           = (known after apply)
              + special          = true
              + upper            = true
            }
        },
    ]
random_string.for_each_splat["2"]: Creating...
random_string.for_each_splat["5"]: Creating...
random_string.for_each_splat["5"]: Creation complete after 0s [id=)u:xG]
random_string.for_each_splat["2"]: Creation complete after 0s [id=b5]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

map_of_resources_created = [
  {
    "2" = {
      "id" = "b5"
      "keepers" = tomap(null) /* of string */
      "length" = 2
      "lower" = true
      "min_lower" = 0
      "min_numeric" = 0
      "min_special" = 0
      "min_upper" = 0
      "number" = true
      "override_special" = tostring(null)
      "result" = "b5"
      "special" = true
      "upper" = true
    }
    "5" = {
      "id" = ")u:xG"
      "keepers" = tomap(null) /* of string */
      "length" = 5
      "lower" = true
      "min_lower" = 0
      "min_numeric" = 0
      "min_special" = 0
      "min_upper" = 0
      "number" = true
      "override_special" = tostring(null)
      "result" = ")u:xG"
      "special" = true
      "upper" = true
    }
  },
]

```
## Ternary<a name="Ternary"></a>
```
# Very useful for varying resources by environment

variable "env" {
  default = "prod"
}

resource "random_string" "longer_in_prod" {
  length = var.env == "prod" ? 5 : 3
}

output "string_produced" {
  # Will be 5 characters long
  value = random_string.longer_in_prod.result
}

```
Applying this example outputs:
```

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.longer_in_prod will be created
  + resource "random_string" "longer_in_prod" {
      + id          = (known after apply)
      + length      = 5
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + string_produced = (known after apply)
random_string.longer_in_prod: Creating...
random_string.longer_in_prod: Creation complete after 0s [id=ag}&=]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

string_produced = "ag}&="

```
## Get path of running terraform code<a name="Get_path_of_running_terraform_code"></a>
```
# This gives the path of the terraform running
# relative to the directory in which the entry
# terraform was run.
# This is the entry terraform, so it returns '.'
# This is useful when creating and referencing
# non-terraform files bundled into a module

output "entry_terraform_path" {
  value = path.module
}

```
Applying this example outputs:
```

Changes to Outputs:
  + entry_terraform_path = "."

You can apply this plan to save these new output values to the Terraform
state, without changing any real infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

entry_terraform_path = "."

```
## Variable templating (string interpolation)<a name="Variable_templating_(string_interpolation)"></a>
```
# If the value you're interpolating is part of a resource
# then Terraform will infer the dependency between the two -
# it won't try to build the resource containing the interpolation
# until it has built the referenced resource.

resource "random_string" "insertion" {
  length = 7
}

locals {
  my_string = "Random string value is ${random_string.insertion.result}"
}

output "my_string" {
  value = local.my_string
}

```
Applying this example outputs:
```

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.insertion will be created
  + resource "random_string" "insertion" {
      + id          = (known after apply)
      + length      = 7
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + my_string = (known after apply)
random_string.insertion: Creating...
random_string.insertion: Creation complete after 0s [id=damIR&g]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

my_string = "Random string value is damIR&g"

```
## JSON encoding<a name="JSON_encoding"></a>
```
# This is particularly useful if you're working in
# AWS, as it makes IAM policy writing neater

output "example_json_policy" {
  value = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

```
Applying this example outputs:
```

Changes to Outputs:
  + example_json_policy = jsonencode(
        {
          + Statement = [
              + {
                  + Action   = [
                      + "ec2:Describe*",
                    ]
                  + Effect   = "Allow"
                  + Resource = "*"
                },
            ]
          + Version   = "2012-10-17"
        }
    )

You can apply this plan to save these new output values to the Terraform
state, without changing any real infrastructure.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

example_json_policy = "{\"Statement\":[{\"Action\":[\"ec2:Describe*\"],\"Effect\":\"Allow\",\"Resource\":\"*\"}],\"Version\":\"2012-10-17\"}"

```
