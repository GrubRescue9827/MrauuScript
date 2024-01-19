# Manual Installation 

## Install dependencies
Dependencies are listed in the `depends.txt` file. Package names and package managers will vary depending on distro, so you'll have to manually install them. Most dependencies should be pre-installed.

## MrauuScript Installation

1. Create a directory where you will install MrauuScript.

```bash
sudo mkdir /opt/MrauuScript/
```

2. Create a new non-privileged user. (This will be the user the Minecraft server runs under.)

```bash
sudo useradd gameuser
```

3. Fix the permissions on your install directory to ensure `gameuser` has full access.

```bash
sudo chown -R gameuser /opt/MrauuScript/
```

4. Download MrauuScript

```bash
sudo su gameuser
cd /opt/
git clone https://github.com/GrubRescue9827/MrauuScript.git
cd ./MrauuScript
```

5. Create additional directories
```bash
mkdir ./bin/
mkdir ./bin/mc-server/

# OPTIONAL:
mkdir ./bin/alerts/
mkdir ./bin/alerts/localtonet/
mkdir ./bin/alerts/ngrok/
```

6. Move `globals.sh` to `/etc/opt/MrauuScript/globals.sh`

```bash
# Log out of gameuser
exit
# If not already, cd into install directory
cd /opt/MrauuScript/

sudo mkdir /etc/opt/MrauuScript
sudo mv ./config/globals.sh /etc/opt/MrauuScript/
```

## Install bargs
Bargs is a framework for parsing command line arguments with BASH. Since my development is no good, my scripts heavily rely on it.

```bash
sudo -u gameuser curl -o ./config/bargs.sh https://raw.githubusercontent.com/unfor19/bargs/master/bargs.sh
sudo chmod +x ./config/bargs.sh
```

## Install Minecraft Server
1. For this step, you may use any server software of your choice. By default, MrauuScript is pre-configured with performance optimizations for `Purpur` but any java-based Minecraft server software will work with some modification. (See: `Using-Other-Servers.md`) Replace \<URL\> with the download URL of the server software of your preference.

```bash
cd ./bin/mc-server
sudo -u gameuser curl -o server.jar <URL>
```

2. Run the server for first time and accept the EULA.

```bash
sudo -u gameuser java -jar ./server.jar

# Accept the EULA with your prefered text editor of choice.
nano eula.txt
```

## Install LocalToNet/Ngrok (Optional)

1. Place the LocalToNet/ngrok executable in its respective folder in the the `./bin/alerts/` directory.

```
cd /opt/MrauuScript/bin/alerts/<localtonet or ngrok>
sudo -u gameuser curl -o <localtonet or ngrok> <Download URL>
```

3. Make sure it is executable by your unprivileged user.

```
sudo chmod +x /opt/MrauuScript/bin/<localtonet or ngrok>/<localtonet or ngrok executable>
```

3. MrauuScript requires some extra configuration to enable LocalToNet or Ngrok, see: [Configuration - Alerts](./config-alerts.md)

## Install Tailscale (Optional)

1. Use the automated installer found on the [Tailscale website](https://tailscale.com/download)
2. Make sure the `tailscaled` daemon was enabled automatically

```bash
sudo systemctl status tailscaled

# IF it does NOT say enabled:
sudo systemctl enable tailscaled && sudo systemctl start tailscaled
```

3. Log into the Tailscale client via a web browser

```
tailscale up
```

## Configuration
See [Configuration Documentation](./config.md)
