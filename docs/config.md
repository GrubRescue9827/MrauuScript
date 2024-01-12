# Configuration
MrauuScript mostly relies on BARGS as well as a global config file for configuration. Default config files can be found in ./config/

## Global config file

```bash
todo
```

## Per-Script config

```bash
---
default="./example"
---
```

All configurable options can be easily accessed via command line arguments. You can see all available command line arguments for a specific script using the argument `--help`. Once you have a setting locked in, you can ***set its value under `default=` in the appropriate configuration file.***

#### Notes:
- ⚠️ BARGS seems to have issues interpreting quotes, even if they are backslash-escaped!
- ⚠️ BARGS cannot handle config files with a file extension.

## Custom Scripts
In addition, MrauuScript can also be configured to use custom scripts or commands. This can be used to better suit your specific needs. See `Advanced Documentation.md` for more detailed information.

## Configuration of LocalToNet and/or Ngrok

In order to configure Ngrok or LocalToNet, you will need:
- An `Auth token`, available from the LocalToNet/Ngrok dashboard.
- An `API key`, which you must create via the LocalToNet/Ngrok dashboard.

As a privileged user, create a basic text document in `./config/alerts/` for each `Auth token` and `API` you wish to use. ***This file should only contain a single line.*** Use one of the file names below depending on what you plan to set up.

- ngk-auth = Ngrok auth token
- ngk-api = Ngrok API key
- ltn-auth = LocalToNet auth token
- ltn-api = LocalToNet API key
