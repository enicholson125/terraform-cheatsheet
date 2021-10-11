# terraform-cheatsheet
Cheatsheet for HCL in Terraform, as there are lots of Terraform CLI cheatsheets but I couldn't find any HCL ones.

The cheatsheet is specified in json, with the terraform examples as terraform files in the examples directory so they can be run.

## To generate cheatsheet HTML

```bash
python scripts/generate-html.py
```

## To set up pre-commit hooks

```bash
pipenv sync --dev
pipenv run pre-commit install
```
