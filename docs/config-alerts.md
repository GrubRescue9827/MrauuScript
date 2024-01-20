# Configuration of LocalToNet, Ngrok and/or Tailscale

### Ngrok or LocalToNet
In order to configure Ngrok or LocalToNet, you will need:
- An `Auth token`, available from the LocalToNet/Ngrok dashboard.
- An `API key`, which you must create via the LocalToNet/Ngrok dashboard.

As a privileged user, create a basic text document in `./config/alerts/` for each `Auth token` and `API` you wish to use. ***This file should only contain a single line.*** Use one of the file names below depending on what you plan to set up.

- ngk-auth = Ngrok auth token
- ngk-api = Ngrok API key
- ltn-auth = LocalToNet auth token
- ltn-api = LocalToNet API key

### Tailscale
To configure Tailscale to run at startup of the Minecraft server, simply create the empty file: `./config/startup/ts-lock`

```bash
# Run this command from the MrauuScript install directory. [Default: /opt/MrauuScript/]
touch ./config/startup/ts-lock
```
