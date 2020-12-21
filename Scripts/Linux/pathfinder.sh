#!/bin/bash
#pathfinder is a network,system and web enumeration tool.

#init
#parse input
function parse_input()
{
    if [[ $# == 2 ]]; then
        #parse arg2
        if [ "$2" = "-A" ]; then
            echo "all"
        elif [ "$2" = "-W" ]; then
            echo "web"
        elif [ "$2" = "-NS" ]; then
            echo "netsys"
        else
            echo "Error: $1 is not a valid option"
            welcome
            echo "exit"
        fi
    elif [[ $# == 1 ]]; then
        #parse arg1
        if [ "$1" = "--welcome" ]; then
            welcome
            echo "exit"
        elif [ "$1" = "--help" ]; then
            help
            echo "exit"
        else
            echo "Error: $1 is not a valid option"
            welcome
            echo "exit"
        fi
    else
        echo "Error: $# is not a valid amount of argumants"
        welcome
        echo "exit"
    fi
}

#manual
function welcome()
{
    #displays welcome page also known as usage page
    echo "
██████╗░░█████╗░████████╗██╗░░██╗███████╗██╗███╗░░██╗██████╗░███████╗██████╗░
██╔══██╗██╔══██╗╚══██╔══╝██║░░██║██╔════╝██║████╗░██║██╔══██╗██╔════╝██╔══██╗
██████╔╝███████║░░░██║░░░███████║█████╗░░██║██╔██╗██║██║░░██║█████╗░░██████╔╝
██╔═══╝░██╔══██║░░░██║░░░██╔══██║██╔══╝░░██║██║╚████║██║░░██║██╔══╝░░██╔══██╗
██║░░░░░██║░░██║░░░██║░░░██║░░██║██║░░░░░██║██║░╚███║██████╔╝███████╗██║░░██║
╚═╝░░░░░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═════╝░╚══════╝╚═╝░░╚═╝
*********************************by green_ladros*****************************
usage:
option1 - pathfinder <target> <path_to_walk>
option2 - pathfinder <display>
args:
<target> - the target machine's ip address.
<path_to_walk> - what type of enumeration to do. (-A/-NS/-W) (all/netsys/web)
<display> - what to display. (--welcome/--help) (welcome/help page)
"
}
function help()
{
    #displays a more in deep usage page
    echo "
██╗░░██╗███████╗██╗░░░░░██████╗░██╗
██║░░██║██╔════╝██║░░░░░██╔══██╗██║
███████║█████╗░░██║░░░░░██████╔╝██║
██╔══██║██╔══╝░░██║░░░░░██╔═══╝░╚═╝
██║░░██║███████╗███████╗██║░░░░░██╗
╚═╝░░╚═╝╚══════╝╚══════╝╚═╝░░░░░╚═╝
usage:
option1 - pathfinder <target> <path_to_walk>
option2 - pathfinder <display>
args:
<target> - the target machine's ip address.
<path_to_walk> - what type of enumeration to do. (-A/-NS/-W) (all/netsys/web)
<display> - what to display. (--welcome/--help) (welcome/help page)
"
}

#enumerate system&network
function enum_netsys()
{
    echo -e '\e[0m' "Enumerating Network&System..."
    nmap_res=$(nmap -T4 -A -p- $1)
    echo "Finished Enumerating Network&System!"
    echo -e '\e[32m' "--------------------NetSysPath--------------------"
    echo $nmap_res
    echo             "--------------------------------------------------"
}

#enumerate web
function enum_web()
{
    echo -e '\e[0m' "Enumerating WebApp..."
    nikto_res_http=$(nikto -host $1:80)
    nikto_res_https=$(nikto -host $1:443)
    #dirb_res=$(dirb --options)
    echo "Finished Enumerating WebApp!"
    echo -e '\e[32m' "--------------------WebAppPath--------------------"
    echo $nikto_res_http
    echo $nikto_res_https
    echo             "--------------------------------------------------"
}

#main
function main()
{
    #the main function
    echo "Pathfinding..."
    PATH_TO_WALK=$(parse_input $1 $2)
    echo $PATH_TO_WALK
    if [ "$PATH_TO_WALK" = "all" ]; then
        enum_web $1
        enum_netsys $1
    elif [ "$PATH_TO_WALK" = "web" ]; then
        enum_web $1
    elif [ "$PATH_TO_WALK" = "netsys" ]; then
        enum_netsys $1
    elif [ "$PATH_TO_WALK" = "exit" ]; then
        exit 0
    else
        echo "Error: $PATH_TO_WALK is not a valid option"
        welcome
        exit 0
    fi
    echo "Done!"
}

#run
main $1 $2