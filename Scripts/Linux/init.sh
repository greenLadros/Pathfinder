#!/bin/bash
#this is the initalizer of the pathfinder tool

#init
#welcome
echo "Initalizing pathfinder tool..."
#get input
echo "Please enter the Scripts folder absolute path: "
read SCRIPTS_PATH
echo "necessary tools: Nmap, Nikto, Dirb"
echo "Do you want to install the necessary tools?(y/n): "
read B_INSTALL_REQUIREMENTS

#install requirements
if [ "$B_INSTALL_REQUIREMENTS" = "y" ]; then
    #sudo apt update upgrade
    #sudo apt-get update upgrade
    #echo "Where do you want to install the necessary tools?: "
    #read INSTALL_PATH
    echo "Installing Requirements..."
    #installing Nmap
    apt-get install nmap -y
    #installing nikto
    apt-get install nikto -y
    #installing dirb
    apt install dirb -y
    echo "Requirements Installed!"
else
    echo "If the required tools are missing the tool will not operate as expected!"
fi

#config
echo "Configuring Tool..."
export PATH=$PATH:$SCRIPTS_PATH
echo "Finished Configuration!"

#end
echo "Done!"