#!/bin/bash

# In case a URL gets taken down for whatever reason, configure them here.
bargsurl="https://raw.githubusercontent.com/unfor19/bargs/master/bargs.sh"
MrauuURL="https://github.com/GrubRescue9827/MrauuScript.git"

# ========
# DEFAULTS:
# ========
MrauuInstall="/opt/MrauuScript/"
UnprivilegedUser="gameuser"
ltnurl="https://localtonet.com/download/localtonet-linux-x64.zip"
ngkurl="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"
srvurl="https://api.purpurmc.org/v2/purpur/1.20.4/latest/download"

# ============
# OFFLINE MODE
# ============
# copies pre-downloaded files instead of downloading them from web.
# THIS WILL OVERRIDE DEFAULTS!
localonly="y"
bargsurl="/mnt/MrauuDev/dl/bargs.sh"
ltnurl="/mnt/MrauuDev/dl/ltn.zip"
ngkurl="/mnt/MrauuDev/dl/ngk.tgz"
srvurl="/mnt/MrauuDev/dl/server.jar"
MrauuURL="/mnt/MrauuDev/dl/MrauuScript/"

# ========
# ADVANCED
# ========
# Only change this if something's gone horrifically wrong!
tmp=/tmp/MrauuScript
#os="debian" # Should auto-detect, but sometimes things don't go our way, now do they?
deps="screen jq cron curl sudo git unzip tar nano sed openjdk-17-jre"

function devmode () {
# Debugging mode, skips all prompts.
echo "======================================="
echo "[WARN] You are using devmode overrides!"
echo "======================================="
MrauuInstall=/opt/MrauuScript
UnprivilegedUser="gameuser"
ltn=y
ngk=y
srv=y
ngkauth="ngkauth"
ngkapi="ngkapi"
ltnauth="ltnauth"
ltnapi="ltnapi"
ts="y"

#ltnurl="https://localtonet.com/download/localtonet-linux-x64.zip"
#ngkurl="https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"
#srvurl="https://api.purpurmc.org/v2/purpur/1.20.4/latest/download"
EDITOR=nano
}



function usermode () {

# Pretty TUI logo
echo '  .                         .                                 .                                  .       '
echo '      .         .                        .                *          .                   .               '
echo '##\      ##\      *      .     *              *      ###U##\    .            *    ##\        *   ##\     '
echo '#N#\  * #A# |           *               +           ##  __##\      *  .           \__|           ## |    '
echo '####\  #### | ######\  ######\  ##\   ##\ ##\   ##\ ## /  \__| #######\  ######\  ##\  ######\ ######\   '
echo '##\##\## ## |##  __##\ \____##\ ## |  ## |## |  ## |\###W##\  ##  _____|##  __##\ ## |##  __##\\_##  _|  '
echo '## \#Y#  ## |## |  \__|####### |## |  ## |## |  ## | \____##\ ## /      ## |  \__|## |## /  ## | ## |    '
echo '## |\#  /## |## |     ##  __## |## |  ## |## |  ## |##\   ## |## |  *   ## |      ## |## |  ## | ## |##\ '
echo '## | \_/ ## |## |  *  \####### |\######  |\######  |\###U##  |\#######\ ## |  +   ## |#######  | \####  |'
echo '\__|     \__|\__|      \_______| \______/  \______/  \______/  \_______|\__|   *  \__|##  ____/   \____/ '
echo '    .    *        *          *    .     .    *    *   .                   .          ## |         *     '
echo '   *          .      *         .     +                      *       *           .    ## |     *         '
echo '        .                                        .                     *             \__|               '
echo '    .                       .                                                                    .       '

echo "Welcome to the MrauuScript automatic installer!"

if [[ $localonly == "y" ]]; then
    echo "======================[WARNING!]======================"
    echo "[WARN] You are running this script in OFFLINE MODE!"
    echo
    echo "If this was a mistake, follow documentation to revert"
    echo "to online mode. (/docs/autoinstall.md)"
    echo "======================================================"
fi

read -r -p "Enter the install location [$MrauuInstall]: " input
if [[ ! -z "$input" ]]; then MrauuInstall="$input"; fi

read -r -p "Enter a name for a *new* user to run the Minecraft server [$UnprivilegedUser]: " input
if [[ ! -z "$input" ]]; then UnprivilegedUser="$input"; fi

read -r -p "Do you wish to setup alerts? [y/N]: " input
case "$input" in
    [yY][eE][sS]|[yY])
        echo "Beginning alerts configuration."
        # Because user can and will do *any* input (y/Y/yES/Yes/etc...) this just sets it to a *known* non-empty string.
        # Originally I was going to do this with nested case statements. I never wish to return to hell again.
        alerts="Nya~!"
        ;;
    *)
        echo "You may configure alerts manually at any time if you change your mind."
        echo "Alert documentation can be found at: https://github.com/placeholdertext"
        ;;
esac

# My hope is that this code is so horrifically inefficient and awful to read that some 3-letter agency specializing in neutralizing bad programmers comes to my door and
# forcefully installs microsoft windows on my main PC so that I may never use BASH again. Well, jokes on them I'm even worse at BATCH!

if [[ "$alerts" == "Nya~!" ]]; then
    read -r -p "Do you wish to use Ngrok? [y/N]: " input
        case "$input" in
        [yY][eE][sS]|[yY])
            # Hacky fix due to case-sensitive garbage code.
            ngk="y"
            ;;
        *)
            ;;
    esac

    read -r -p "Do you wish to use LocalToNet? [y/N]: " input
    case "$input" in
        [yY][eE][sS]|[yY])
            # Hacky fix due to case-sensitive garbage code.
            ltn="y"
            ;;
        *)
            ;;
    esac

    read -r -p "Do you wish to use Tailscale? [y/N]: " input
    case "$input" in
        [yY][eE][sS]|[yY])
            # Hacky fix due to case-sensitive garbage code.
            ts="y"
            ;;
        *)
            ;;
    esac
fi
# Still more alerts stuff. This should NEVER trigger if the above didn't. If that happens... panic?
if [[ "$ngk" == "y" ]]; then
    echo "[WARN] This data will be saved to the disk in PLAIN TEXT for configuration purposes! It will NOT be used or saved anywhere else."
    read -r -p "Enter your ngrok Authtoken: " ngkauth
    read -r -p "Enter your ngrok API key [NOT your Authtoken!]: " ngkapi

    echo "Ngrok download URLs seem to change with version. Visit https://ngrok.com/download in your web browser and copy the download link to the latest version."
    echo "Default: $ngkurl"
    read -r -p "Enter download URL: " input
    if [[ ! -z $input ]]; then ngkurl="$input"; fi
fi

if [[ $ltn == "y" ]]; then
    echo "[WARN] This data will be saved to the disk in PLAIN TEXT for configuration purposes! It will NOT be used or saved anywhere else."
    read -r -p "Enter your localtonet Authtoken: " ltnauth
    read -r -p "Enter your localtonet API key [NOT your Authtoken!]: " ltnapi

    echo "Visit https://localtonet.com/download in your web browser and copy the download link to the latest version."
    echo "Default: $ltnurl"
    read -r -p "Enter download URL: " input
    if [[ ! -z $input ]]; then ltnurl="$input"; fi
fi

if [[ $ts == "y" ]]; then
    echo "[WARN] After install, you'll have to manually log into Tailscale."
    read -n 1 -s -r -p "Press any key to aknowledge."
fi

if [[ "$alerts" == "Nya~!" ]]; then echo "Alerts configuration completed."; fi

read -r -p "Do you wish to download and install a Minecraft server? [y/N]: " input
case "$input" in
    [yY][eE][sS]|[yY])
        srv="y"
        ;;
    *)
        echo "[WARN] You will have to manually install a server."
        ;;
esac

if [[ "$srv" == "y" ]]; then
    echo "[WARN] At the moment, only purpur is natively supported!"
    echo "Enter the download URL to the *jarfile* of your prefered server."
    echo "Default: $srvurl"
    read -r -p "Enter download URL: " input
    if [[ ! -z "$input" ]]; then srvurl="$input"; fi

    # Prevent default from being empty. Just looks prettier.
    if [[ -z "$EDITOR" ]]; then EDITOR=nano; fi
    read -r -p "Enter the text editor you wish to use when accepting the server EULA [$EDITOR]: " input

    # Don't accidently overwrite the default editor with an empty string!
    if [[ ! -z "$input" ]]; then EDITOR=$input; fi
    if [[ -z "$EDITOR" ]]; then EDITOR=nano; fi
fi

echo "Here's a summary of what I've configured: [Entries left blank are interpreted as \"No\"]"
echo "InstallDir: \"$MrauuInstall\""
echo "UnprivilegedUser: \"$UnprivilegedUser\""
echo "Ngrok:"
echo "    ShouldInstall: \"$ngk\""
echo "    URL: \"$ngkurl\""
echo "    Authtoken: \"$ngkauth\""
echo "    APIKey: \"$ngkapi\""
echo "localtonet:"
echo "    ShouldInstall: \"$ltn\""
echo "    URL: \"$ltnurl\""
echo "    Authtoken: \"$ltnauth\""
echo "    APIKey: \"$ltnapi\""
echo "Tailscale:"
echo "    ShouldInstall: \"$ts\""
echo "Server:"
echo "    ShouldInstall: \"$srv\""
echo "    URL: \"$srvurl\""
echo "    EditWith: \"$EDITOR\""
read -n 1 -s -r -p "If this is okay, press any key and sit back. Press CTRL+C to cancel."

}

function FatalErr () {
    echo "[FATAL] $1"
    exit 1
}

if [[ $1 == "--devmode" ]]; then
    devmode
else
    usermode
fi

echo "[INFO] Beginning install process."

echo "[INFO] Install Dependencies..."
source /etc/os-release || echo "[WARN] Failed to find /etc/os-release!"

if [[ "$ID_LIKE" == "" ]]; then
    echo "[WARN] ID_LIKE not set, assuming OS name: '$NAME'"
    osname=$NAME
elif [[ "$NAME" == "" ]]; then
    echo "[WARN] OSNAME not set!"
    osname=$OSTYPE
else
    osname=$ID_LIKE
fi
 
 # OS Override, in case automatic detection doesn't work.
 if [[ ! -z "$os" ]]; then
    osname=$os
 fi

echo "[INFO] Interpreted OS as: \"$osname\""

# Select what package manager to use depending on OS name.
case $osname in
    debian|ubuntu|kali|pop|neon|zorin|linuxmint|elementary|raspbian)
    sudo apt-get update
    sudo apt-get install $deps -m -y
    ;;
    arch|manjaro)
    sudo pacman -Sy
    sudo pacman -Sy $deps
    ;;
    alpine)
    sudo apk update
    sudo apk add $deps
    ;;
    rocky|almalinux|fedora|rhel|ol|centos)
    sudo dnf update
    sudo dnf install $deps
    ;;
    darwin)
    echo "[WARN] MacOS support is untested! Expect jank!"
    echo "[ERROR] Cannot automatically install dependencies on MacOS."
    sleep 5
    ;;
    linux-android)
    echo "[WARN] I appriciate the GRIND trying to get this working on Android. Maximum respect. Installing dependencies may not work, though."
    pkg update
    pkg install $deps
    ;;
    haiku)
    echo "[WARN] Well, that's a strange OS."
    sleep 5
    ;;
    *)
    echo "[ERROR] Unidentified OS. Cannot automatically install dependencies!"
    read -r -p "Continue anyway? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            echo "[WARN] Continuing anyway with errors..."
            ;;
        *)
            FatalErr "User aborted install."
            ;;
    esac
    ;;
esac

echo "[INFO] Finished installing dependencies."

echo "[INFO] Beginning install..."

echo "[INFO] Creating directories..."
sudo mkdir -p $MrauuInstall
sudo mkdir $tmp

echo "[INFO] Creating new user..."
sudo useradd $UnprivilegedUser || echo "[WARN] Adding user failed. Assuming user already exists!"

echo "[INFO] Correcting permissions for new user..."
sudo chown -R $UnprivilegedUser:$UnprivilegedUser $MrauuInstall

echo "[INFO] Downloading MrauuScript..."
cd /opt/

if [[ "$localonly" == "y" ]]; then
    sudo cp -r $MrauuURL/. $MrauuInstall
    chown -R $UnprivilegedUser:$UnprivilegedUser $MrauuInstall
else
    sudo -u $UnprivilegedUser git clone $MrauuURL || FatalErr "Failed to download MrauuScript! Returned $?"
fi

echo "[INFO] Creating additional directories..."
sudo -u $UnprivilegedUser mkdir -p $MrauuInstall/bin/mc-server/

if [[ $ltn == "y" ]]; then
    echo "[INFO] Installing localtonet..."
    sudo -u $UnprivilegedUser mkdir -p $MrauuInstall/bin/alerts/localtonet/
    if [[ "$localonly" == "y" ]]; then
        sudo cp $ltnurl $tmp/ltn.zip
    else
        sudo curl --location -o $tmp/ltn.zip $ltnurl
    fi
    unzip $tmp/ltn.zip -d $MrauuInstall/bin/alerts/localtonet/ || FatalErr "Failed to extract file: \"$tmp/ltn.zip\" Returned: $?"
    sudo chown -R $UnprivilegedUser:$UnprivilegedUser $MrauuInstall/bin/alerts/localtonet/
    sudo chmod +x $MrauuInstall/bin/alerts/localtonet/localtonet
fi

if [[ $ngk == "y" ]]; then
    echo "[INFO] Installing ngrok..."
    sudo -u $UnprivilegedUser mkdir -p $MrauuInstall/bin/alerts/ngrok/
    if [[ "$localonly" == "y" ]]; then
        sudo cp $ngkurl $tmp/ngk.tgz
    else
        sudo curl --location -o $tmp/ngk.tgz $ngkurl
    fi
    sudo tar -xzf $tmp/ngk.tgz -C $MrauuInstall/bin/alerts/ngrok/ || FatalErr "Failed to extract file: \"$tmp/ngk.tgz\" Returned: $?"
    sudo chown -R $UnprivilegedUser:$UnprivilegedUser $MrauuInstall/bin/alerts/ngrok/
    sudo chmod +x $MrauuInstall/bin/alerts/ngrok/ngrok
fi

if [[ $ts == "y" ]]; then
    echo "[INFO] Installing Tailscale..."
    curl -fsSL https://tailscale.com/install.sh | sh || echo "[WARN] Tailscale install failed! Returned: $?"
fi

echo "[INFO] Moving config file..."
sudo mkdir -p /etc/opt/MrauuScript
sudo mv $MrauuInstall/config/globals.sh /etc/opt/MrauuScript/

echo "[INFO] Downloading BARGS"

if [[ "$localonly" == "y" ]]; then
    sudo cp $bargsurl $MrauuInstall/config/bargs.sh
else
    sudo -u $UnprivilegedUser curl -o $MrauuInstall/config/bargs.sh $bargsurl || FatalErr "Failed to download BARGS! Returned $?"
fi
sudo chown -R $UnprivilegedUser:$UnprivilegedUser $MrauuInstall/config/bargs.sh

echo "[INFO] Making files executable..."
sudo chmod +x $MrauuInstall/config/bargs.sh

if [[ "$srv" == "y" ]]; then
    echo "[INFO] Installing Java server..."
    if [[ "$localonly" == "y" ]]; then
        sudo cp $srvurl $MrauuInstall/bin/mc-server/server.jar
        sudo chown $UnprivilegedUser:$UnprivilegedUser $MrauuInstall/bin/mc-server/server.jar
    else
        sudo -u $UnprivilegedUser curl --location -o $MrauuInstall/bin/mc-server/server.jar $srvurl || FatalErr "Failed to download server! Returned $?"
    fi
    cd $MrauuInstall/bin/mc-server/
    sudo -u $UnprivilegedUser java -jar ./server.jar || FatalErr "Initial server startup failed! Returned $?"
    echo "[WARN] You must agree to the server's EULA."
    sleep 5
    $EDITOR $MrauuInstall/bin/mc-server/eula.txt || FatalErr "Failed to start text editor $EDITOR or eula.txt does not exist. Returned $?"
fi

echo "[INFO] Attempting automatic configuration..."
sed -i -e "s@=/opt/MrauuScript@=$MrauuInstall@g" /etc/opt/MrauuScript/globals.sh || echo "[ERROR] Failure when attempting to modify InstallLocation config. CONFIG MAY BE INCORRECT!"
sed -i -e "s@=gameuser@=$UnprivilegedUser@g" /etc/opt/MrauuScript/globals.sh || echo "[ERROR] Failure when attempting to modify UnprivilegedUser config. CONFIG MAY BE INCORRECT!"

if [[ $ngk == "y" ]]; then
    echo "$ngkauth" > $MrauuInstall/config/alerts/ngk-auth
    echo "$ngkapi" > $MrauuInstall/config/alerts/ngk-api
fi

if [[ $ltn == "y" ]]; then
    echo "$ltnauth" > $MrauuInstall/config/alerts/ltn-auth
    echo "$ltnapi" > $MrauuInstall/config/alerts/ltn-api
fi

if [[ $ts == "y" ]]; then
    touch $MrauuInstall/config/startup/ts-lock
    sudo systemctl enable tailscaled
fi

echo "[INFO] Cleaning up..."
sudo rm -ri $tmp
sudo rm -i $MrauuInstall/install.sh

echo "Install complete! You can start MrauuScript by running: $MrauuInstall/run.sh"
echo "Documentation is available in the directory $MrauuInstall/docs/"
echo "Up-to-date documentation is available on Github."
echo ""
echo "Enjoy your Minecraft server!"
