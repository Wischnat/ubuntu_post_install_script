#!/bin/bash

function update {
    echo "update"
    apt-get update -y
}

function upgrade {
    echo "upgrade"
    apt-get upgrade -y
}

function autoremove {
    echo "autoremove"
    sudo apt autoremove -y
}

function dependencies {
    sudo apt install curl
    sudo apt-get install wget
    sudo apt-get install dialog
}

function main {
    update
    upgrade
    dependencies

    # https://askubuntu.com/questions/491509/how-to-get-dialog-box-input-directed-to-a-variable
    exec 3>&1;
    choices=$(dialog --checklist "Which software do you want to install?" 40 40 4 \
        1 "Git" on \
        2 "Node 18 LTS" on \
        3 "JDK 11" on \
        4 "Docker & Docker Compose" on \
        5 "Chrome" on \
        6 "Visual Studio Code" on \
        7 "Discord" on \
        8 "PGAdmin" on \
        9 "Brave" on \
        10 "Tailscale" on \
        11 "PowerTop" off \
        12 "Android Studio" off \
        13 "Flutter (without setup)" off \
        2>&1 1>&3);
    clear

    for choice in $choices
    do
        case $choice in
            1)
            echo "Installing Git"
            sudo apt-get install git -y
            ;;

            2)
            echo "Installing Node 18"
            sudo curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
            sudo apt-get install nodejs -y
            ;;

            3)
            echo "Installing JDK 11"
            sudo apt-get install openjdk-11-jre -y
            sudo apt-get install openjdk-11-jdk openjdk-11-demo openjdk-11-doc openjdk-11-jre-headless openjdk-11-source -y
            ;;

            4)
            echo "Installing Docker & Docker Compose"
            sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;

            5)
            echo "Installing Chrome"
            sudo wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
            sudo dpkg -i chrome.deb
            sudo apt-get install -f
            rm -f chrome.deb
            ;;

            6)
            echo "Installing Visual Studio Code"
            sudo wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
            sudo dpkg -i vscode.deb
            sudo apt-get install -f
            rm -f vscode.deb
            ;;

            7)
            echo "Installing Discord"
            sudo wget -O discord.deb 'https://discord.com/api/download?platform=linux&format=deb'
            sudo dpkg -i discord.deb
            sudo apt-get install -f
            rm -f discord.deb
            ;;

            8)
            # Installing Postgres & Pgadmin
            # https://www.tecmint.com/install-postgresql-and-pgadmin-in-ubuntu/
            # https://www.pgadmin.org/download/pgadmin-4-apt/
            echo "Installing PGAdmin"
            curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
            sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'
            update
            sudo apt install pgadmin4
            ;;

            9)
            echo "Installing Brave"
            sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
            update
            sudo apt install brave-browser -y
            ;;

            10)
            echo "Installing Tailscale"
            sudo curl -fsSL https://tailscale.com/install.sh | sh
            ;;

            11)
            echo "Installing PowerTop"
            sudo apt-get install powertop 
            ;;


            12)
            echo "Installing Android Studio"
            sudo apt-get install libcanberra-gtk-module android-sdk
            sudo add-apt-repository ppa:maarten-fonville/android-studio -y
            update
            sudo apt install android-studio -y
            ;;

            13)
            # https://docs.flutter.dev/get-started/install/linux
            echo "Installing Flutter"
            sudo snap install flutter --classic
            flutter sdk-path
            ;;
        
	    esac
	done

    autoremove
}

main
