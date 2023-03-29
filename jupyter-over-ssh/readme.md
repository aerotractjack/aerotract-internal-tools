# How to set up and use `jupyter-lab` over ssh

# Server setup
1. Install `jupyterlab` globally on your server
2. Add `jupyterlab`'s location to your `PATH`
3. Start `jupyterlab` in a headless fashion on a specific port (I've chosen `5055`)

# Server usage
1. Setup: `$ ./server.sh --setup`
2. Run a jupyter lab in a tmux session: `$ ./server.sh`

# Client setup
1. Add the following line to your `~/.bashrc` file: `export AEROTRACT_PUBLIC_IP=ABC.DE.FGH.JK` (get the real IP from a team member)

# Client usage
1. Connect to server and attach to notebook: `$ ./client.sh MACHINE_PORT`
2. Navigate to `localhost:5055` in your browser
