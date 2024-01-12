# Documentation - API Handler
In the interest of making sure ALL servers can auto update, API querying is handled by its own separate script. This modularity allows for easy support of Minecraft servers which do not use a similar API to Purpur or have no suitable API (In the latter case, you may be able to scrape for the requested data).

## Usage
API.sh is not intended to be used directly. If you're using Purpur, you should not need to specify a custom API handler script unless they've changed their API and bricked my example script. If you're using a server software that I have not written an api handler for, you may write your own.

## Writing your own API handler script
If your Minecraft Server software is NOT supported, you can write your own BASH script to get the download link. Your BASH script should return the download URL to the latest build of the specified Minecraft version. If a version is NOT specified, it should default to the latest version available. Print the output as plain text, as pictured below.
```bash
$ # Usage: api.sh [version]
$ bash ./api.sh "1.20.2"
https://api.purpurmc.org/v2/purpur/1.20.2/latest/download
```