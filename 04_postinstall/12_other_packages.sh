#!/usr/bin/env sh

# Install all npm packages
npm install -g live-server

# Install all pipx packages
pipx install git+https://github.com/veneres/py-pandoc-include-code.git
pipx install aria2p[tui]
