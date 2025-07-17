# Tekluna's tekkible 💾

Modified version of [Typecraft's crucible](https://github.com/typecraft-dev/crucible) Arch linux setup script.

# Usage

Just clones this repo. Running the run.sh script will install packages and flatpaks.
    The list of packages is in the `packages.conf` file.
    The list of flatpaks is in the `install-flatpaks.sh` file.

# The dotfiles

To install the dotfiles, run the `dotfiles-setup.sh` script. It will clone and symlink the dotfiles using **gnu stow** from the `$REPO_URL`, which are set to be my [hyprtekdots](https://github.com/tekluna/hyprtekdotsj) dotfiles default, but you can change it to your own.

(if you do change `$REPO_URL` to be make sure to also change line `31: cd "$REPO_URL/dotfiles"` if yours are not configured the same way)
# Installation

// clone this repo:
```bash
git clone https://github.com/tekluna/tekkibles.github
```

// run the setup scripts
```bash
./run.sh
./dotfiles-setup.shjk
```
