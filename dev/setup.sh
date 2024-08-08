#!/usr/bin/env bash

pandoc --version || brew install pandoc

yq --version || brew install yq
yamllint --version || brew install yamllint

# https://pre-commit.com
pre-commit --version || pip install pre-commit
pre-commit install
pre-commit run --all-files
