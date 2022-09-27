# GodotPlayground
Trying out Godot

Primary Scene is `Entry.tscn`. This Scene will run as a client or server instance based on some criteria.

# Setup
## Windows
1) Add the root Godot application directory to your system PATH environment variable.
2) Rename the godot_whatever.cmd file to just godot.cmd
3) Download a PostgreSQL image: https://hub.docker.com/_/postgres
4) Run the PostgreSQL image

# Running the Server
## Windows
Inside the root of the project directory, open *Powershell* or *cmd* and do `.\runserver.cmd`

# Running the Client
Just click the Play button or F5 in the Godot Editor.

## Running Multiple Clients
Inside the root of the project directory, do `godot.cmd` as many times as desired.