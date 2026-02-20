# Dotfiles

This repository contains my **personal Linux dotfiles**, managed using **GNU Stow**. It is intended to quickly reproduce a consistent user and development environment across multiple machines.

The focus is on simplicity, transparency, and version control of configuration files.

## Overview

Dotfiles are configuration files used by the shell, desktop environment, and various CLI/TUI applications. By tracking them in a Git repository and managing symlinks with **stow**, it becomes easy to:

* keep configurations consistent across systems;
* bootstrap a new machine quickly;
* roll back changes safely using Git.

## Repository Structure

The repository follows a **Stow-compatible layout**. Each top-level directory represents a *package* whose contents will be symlinked into `$HOME`.

Example structure:

```text
.
├── zsh/
│   └── .zshrc
├── config/
│   └── .config/
│       └── ...
├── LICENSE
└── README.md
```

* Each package directory mirrors the target filesystem structure.
* Files are symlinked into the home directory using `stow`.

## Requirements

* `git`
* `stow`
* Applications corresponding to the provided configuration files (e.g. `zsh`, window manager, CLI tools)


## Installation

Clone the repository into your home directory (or any preferred location):

```bash
git clone https://github.com/MishowHD/Dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Install one or more packages using **GNU Stow**:

```bash
stow .
```

This will create the appropriate symbolic links in `$HOME`.

> **Important**: Back up any existing configuration files before running `stow`, as conflicts may occur.

## Usage

* Modify configuration files directly inside the repository.
* Apply changes immediately (or reload the affected application).
* Commit changes to keep a full history of configuration updates.

## Notes

* The repository reflects my personal workflow and preferences; adapt as needed.

## License

This repository is licensed under the **MIT License**. See the `LICENSE` file for details.

