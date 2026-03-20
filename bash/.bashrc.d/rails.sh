#!/bin/bash
# Rails shortcuts for Bash
# Works like Fish abbreviations but in Bash

# Rails function that runs bin/rails if it exists, otherwise uses global rails
r() {
    if [ -f "bin/rails" ]; then
        ./bin/rails "$@"
    elif command -v rails &>/dev/null; then
        rails "$@"
    else
        echo "Rails not found. Install Rails or run from a Rails project directory."
        return 1
    fi
}

# Additional Rails shortcuts
rs() {
    if [ -f "bin/rails" ]; then
        ./bin/rails server "$@"
    elif command -v rails &>/dev/null; then
        rails server "$@"
    fi
}

rc() {
    if [ -f "bin/rails" ]; then
        ./bin/rails console "$@"
    elif command -v rails &>/dev/null; then
        rails console "$@"
    fi
}

rlg() {
    if [ -f "bin/rails" ]; then
        ./bin/rails generate "$@"
    elif command -v rails &>/dev/null; then
        rails generate "$@"
    fi
}

rd() {
    if [ -f "bin/rails" ]; then
        ./bin/rails destroy "$@"
    elif command -v rails &>/dev/null; then
        rails destroy "$@"
    fi
}
