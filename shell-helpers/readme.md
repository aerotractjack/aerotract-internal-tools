# Shell helpers for aerotract machines
This repo contains shell helpers you will want to `source` in your `.bashrc` (or similar) file

# Setup
To add a helper to your system, 
1. Clone this repository and `cd` into the `shell-helpers folder`
```bash
home/user$ gh repo clone aerotractjack/aerotract-internal-tools.git internal-tools
home/user$ cd internal-tools/shell-helpers
```
2. For each file you want (`bash_alias.sh` for example)
```bash
internal-tools/shell-helpers$ echo "source $(pwd)/bash_alias.sh" >> ~/.bashrc
source ~/.bashrc
```
3. Use an alias or function
```bash
home/user$ p3
Python 3.10.6 (main, Nov 14 2022, 16:10:14) [GCC 11.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
```
