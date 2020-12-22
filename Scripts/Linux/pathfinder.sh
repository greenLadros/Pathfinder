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
    echo -e '\e[0m' "Enumerating Network&System on $1..."
    nmap_res=$(nmap -T4 -A -p- $1)
    #retriving valuable info
    os_info="$(grep OS nmap_res)"
    ports_info="$(grep open nikto_res_http)"
    outdated_info="$(grep outdated nmap_res)"
    vulns_info="$(grep vulnrable nmap_res)"
    retrived_info="$(grep retrived nmap_res)"
    #finding vulns
    vulns_found=0
    vulns=""
    if [ -n "$os_info" ]; then
        $vulns="$vulns\n +Try to search for exploits specific to this os and version. For exploits: https://www.exploit-db.com/"
        let vulns_found++
    fi
    if [ -n "$ports_info" ]; then
        $vulns="$vulns\n +Open ports found, you should look for vulns in the protocol or the service running on it. For exploits: https://www.exploit-db.com/"
        let vulns_found++
    fi
    if [ -n "$vulns_info" ]; then
        $vulns="$vulns\n +If you dont know what those vulns mean you should google them (Maybe they will be helpfull). For a great resource: https://www.exploit-db.com/"
        let vulns_found++
    fi
    if [ -n "$outdated_info" ]; then
        $vulns="$vulns\n +Apache/0.0.0 is outdated, This version is probably vulnrable to alot of exploits. For exploits: https://www.exploit-db.com/"
        let vulns_found++
    fi
    echo "Finished Enumerating Network&System!"
    #dislaying results
    echo -e '\e[32m' "--------------------NetSysPath--------------------"
    echo "Info:"
    echo "+OS: $os_info"
    echo "+Ports: $ports_info"
    echo "+OudatedSoftware: $outdated_info"
    echo "+OtherVulns: $vulns_info"
    echo "+Retrived(Most of the time its not important): $retrived_info"
    echo             "__________________________________________________"
    echo "Found $vulns_found vulnerabilities:"
    echo $vulns
    echo             "--------------------------------------------------"
}

#enumerate web
function enum_web()
{
    echo -e '\e[0m' "Enumerating WebApp on $1..."
    nikto_res_http=$(nikto -host $1:80)
    nikto_res_https=$(nikto -host $1:443)
    #dirb_res=$(dirb --options)
    #retriving valuable info
    server_info="http:$(grep server nikto_res_http),https:$(grep server nikto_res_https)"
    cgi_info="http:$(grep CGI nikto_res_http),https:$(grep CGI nikto_res_https)"
    outdated_info="http:$(grep outdated nikto_res_http),https:$(grep outdated nikto_res_https)"
    vulns_info="http:$(grep vulnrable nikto_res_http),https:$(grep vulnrable nikto_res_https)"
    retrived_info="http:$(grep retrived nikto_res_http),https:$(grep retrived nikto_res_https)"
    dir_info="dirb_res"
    #finding vulns
    vulns_found=0
    vulns=""
    if [[ "$cgi_info" == "+ CGI"* ]]; then
        $vulns="$vulns\n +CGI directories found, Try Command Injection on the server system with the cgi scripts. For more info: https://www.exploit-db.com/"
        let vulns_found++
    fi
    if [ -n "$outdated_info" ]; then
        $vulns="$vulns\n +Apache/0.0.0 is outdated, This version is probably vulnrable to alot of exploits. For exploits: https://www.exploit-db.com/"
        let vulns_found++
    fi
    if [ -n"$vulns_info" ]; then
        $vulns="$vulns\n +If you dont know what those vulns mean you should google them (Maybe they will be helpfull). For a great resource: https://www.exploit-db.com/"
        let vulns_found++
    fi
    if [ -n "$Hidden" ]; then
        $vulns="$vulns\n +You should try and go to those directories (Maybe you will find something the owners dont want you to see)."
        let vulns_found++
    fi
    echo "Finished Enumerating WebApp!"
    #dislaying results
    echo -e '\e[32m' "--------------------WebAppPath--------------------"
    echo "Info:"
    echo "+Server: $server_info"
    echo "+CGI: $cgi_info"
    echo "+OudatedSoftware: $outdated_info"
    echo "+OtherVulns: $vulns_info"
    echo "+HiddenDirectories: $dir_info"
    echo "+Retrived(Most of the time its not important): $retrived_info"
    echo             "__________________________________________________"
    echo "Found $vulns_found vulnerabilities:"
    echo $vulns
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