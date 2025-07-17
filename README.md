# Tekluna's tekkible 💾

Modified version of [Typecraft's crucible](https://github.com/typecraft-dev/crucible) Arch linux setup script.

# Usage

Just clones this repo. Running the run.sh script will install packages and flatpaks.
    The list of packages is in the `packages.conf` file.
    The list of flatpaks is in the `install-flatpaks.sh` file.

# The dotfiles

To install the dotfiles, run the `dotfiles-setup.sh` script. It will clone and symlink the dotfiles using **gnu stow** from the `$DOTFILES_REPO`, which are set to be mine by default, but you can change it to your own.

# Installation

clone this repo
`git clone https://github.com/tekluna/tekkibles.git`

run the setup scripts
`./run.sh`
`./dotfiles-setup.sh`
