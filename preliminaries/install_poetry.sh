#!/bin/bash

# Install Poetry
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python

# Adding poetry to Zsh

# Environment
echo -e "source $HOME/.poetry/env" >> ~/.zshrc

# Auto-Tab Completition
mkdir $ZSH/plugins/poetry
poetry completions zsh > $ZSH/plugins/poetry/_poetry
echo "Please add 'poetry' to your plugin in zshrc."
