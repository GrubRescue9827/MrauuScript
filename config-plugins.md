# Configuring plugins for automatic updates

Plugins are configured in the `plugins.csv` file located in the [plugin updates folder](/config/update/plugins/).


#### Example `plugins.csv` file (with headers)

| **Plugin Name**          | **Unparsed/Manual Download URL**           | **Parsed URL** (If applicable.)        |
|--------------------------|--------------------------------------------|----------------------------------------|
| filename-to-save.jar     | Human-accessible URL                       | Some kind of API endpoint to           |
| example.jar              | For use with non-static URLs               | download latest version automatically. |
| /subfolder/plugin.jar | User must use web browser to "parse" page. | Not supported.                         |

*Headers should not be included in `plugins.csv`
