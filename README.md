# terraform-cheatsheet
Cheatsheet for HCL in Terraform, as there are lots of Terraform CLI cheatsheets but I couldn't find any HCL ones.

The cheatsheet is specified in json, with the terraform examples as terraform files in the examples directory so they can be run.

## To generate cheatsheet HTML

Clone this repository then from within the repository run

```bash
python scripts/generate-html.py
```

## To run the cheatsheet locally in a Docker container

Clone this repository then from root of the repository run

```bash
python scripts/generate-html.py > index.html
docker build -t test-cheatsheat .
docker run -it -p 8080:80 test-cheatsheet
```

## To set up pre-commit hooks

```bash
pipenv sync --dev
pipenv run pre-commit install
```
