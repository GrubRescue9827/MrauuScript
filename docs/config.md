# Configuration
MrauuScript mostly relies on BARGS as well as a global config file for configuration. Default config files can be found in ./config/

#### Global config file

```bash
todo
```

#### Per-Script config

```bash
---
default="./example"
---
```

All configurable options can be easily accessed via command line arguments. You can see all available command line arguments for a specific script using the argument `--help`. Once you have a setting locked in, you can ***set its value under `default=` in the appropriate configuration file.***

#### Notes:
- ⚠️ BARGS seems to have issues interpreting quotes, even if they are backslash-escaped!
- ⚠️ BARGS cannot handle config files with a file extension.

#### Custom Scripts
In addition, MrauuScript can also be configured to use custom scripts or commands for all of its functions. This can be used to better suit your specific needs. See `config-advanced.md` for more detailed information.

#### Alerts
See `config-alerts.md`.
