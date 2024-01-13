# Manual Installation 

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
sudo chown gameuser /opt/MrauuScript/
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
mkdir ./bin/mc-server/

# OPTIONAL:
mkdir ./bin/alerts/localtonet/
mkdir ./bin/alerts/ngrok/
```

6. Move `globals.sh` to `/root/.config`

```bash
# Log out of gameuser
exit

sudo mkdir /root/.config/MrauuScript
sudo mv ./globals.sh /root/.config/MrauuScript
```

## Install bargs
Bargs is a framework for parsing command line arguments with BASH. Since my development is no good, my scripts heavily rely on it.

```bash
curl -o ./config/bargs.sh https://raw.githubusercontent.com/unfor19/bargs/master/bargs.sh
```

## Install dependencies
Dependencies are listed in the `depends.txt` file. Package names and package managers will vary depending on distro, so you'll have to manually install them. Most dependancies should be pre-installed.

## Install Minecraft Server
1. For this step, you may use any server software of your choice. By default, MrauuScript is pre-configured with performance optimizations for `Purpur` but any java-based Minecraft server software will work with some modification. (See: `Using-Other-Servers.md`) Replace \<URL\> with the download URL of the server software of your preference.

```bash
cd ./bin/mc-server
curl -o server.jar <URL>
```

2. Run the server for first time and accept the EULA.

```bash
java -jar ./server.jar
```

## Install LocalToNet/Ngrok (Optional)

1. Place the LocalToNet/ngrok executable in its respective folder in the the `./bin/alerts/` directory.
2. Make sure it is executable by your unprivileged user.
3. MrauuScript requires some extra configuration to enable LocalToNet or Ngrok, see: `config-alerts.md`

## Install Tailscale (Optional)
