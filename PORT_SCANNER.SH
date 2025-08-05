#!/bin/bash

# Advanced Port Scanner Tool
# Author: Hemil Panchal
# Purpose: Comprehensive Information Gathering

clear
echo -e "\e[1;34m"
cat << "EOF"
   ____            _      ____                                  
  |  _ \ ___  _ __| |_   / ___|  ___ __ _ _ __  _ __   ___ _ __ 
  | |_) / _ \| '__| __|  \___ \ / __/ _` | '_ \| '_ \ / _ \ '__|
  |  __/ (_) | |  | |_    ___) | (_| (_| | | | | | | |  __/ |   
  |_|   \___/|_|   \__|  |____/ \___\__,_|_| |_|_| |_|\___|_|   
EOF
echo -e "\e[0m"
echo "----------------------------------------------------------------"
echo "         ADVANCED PORT SCANNER - INFORMATION GATHERING          "
echo "----------------------------------------------------------------"
echo -e "\e[1;33mAuthor: Hemil Panchal\e[0m"
echo -e "\e[1;33mVersion: 3.0\e[0m"
echo

# Check dependencies
check_dependencies() {
    local missing=0
    declare -A tools=(
        ["nmap"]="Network mapper"
        ["openssl"]="SSL toolkit"
        ["curl"]="HTTP client"
        ["netmask"]="IP address conversion"
        ["whois"]="WHOIS lookup"
        ["dnsenum"]="DNS enumeration"
    )

    echo -e "\e[1;36mChecking dependencies:\e[0m"
    for tool in "${!tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "✗ $tool (${tools[$tool]})"
            missing=1
        else
            echo -e "✓ $tool"
        fi
    done
    
    if [ $missing -eq 1 ]; then
        read -p "Attempt to install missing dependencies? [y/N] " install
        if [[ "$install" =~ ^[Yy]$ ]]; then
            sudo apt-get update && sudo apt-get install -y nmap openssl curl whois dnsenum netmask
            if [ $? -ne 0 ]; then
                echo "Failed to install dependencies. Please install them manually."
                exit 1
            fi
        else
            echo "Required tools not available. Exiting."
            exit 1
        fi
    fi
    echo
}

check_dependencies

# Function to display menu
show_menu() {
    echo -e "\e[1;32m"
    echo "MAIN SCAN CATEGORIES:"
    echo "1) Port Scanning Techniques"
    echo "2) Service and Version Detection"
    echo "3) Vulnerability Assessment"
    echo "4) Network Discovery"
    echo "5) Web Application Tests"
    echo "6) Target Information Gathering"
    echo "7) Advanced Techniques"
    echo "8) Exit"
    echo -e "\e[0m"
}

show_port_scan_menu() {
    echo -e "\e[1;36m"
    echo "PORT SCANNING TECHNIQUES:"
    echo "1) Quick Port Scan"
    echo "2) Full Port Scan"
    echo "3) Custom Port Range"
    echo "4) TCP Scan"
    echo "5) UDP Scan"
    echo "6) Top Ports Scan"
    echo "7) Back to Main Menu"
    echo -e "\e[0m"
}

show_web_tests_menu() {
    echo -e "\e[1;36m"
    echo "WEB APPLICATION TESTS:"
    echo "1) HTTP Methods Check"
    echo "2) HTTPS Methods Check"
    echo "3) SSL Certificate Information"
    echo "4) Web Server Enumeration"
    echo "5) Back to Main Menu"
    echo -e "\e[0m"
}

show_advanced_menu() {
    echo -e "\e[1;36m"
    echo "ADVANCED TECHNIQUES:"
    echo "1) NSE Script Scan"
    echo "2) MAC Address Spoofing"
    echo "3) Aggressive Scan"
    echo "4) Firewall Detection"
    echo "5) Back to Main Menu"
    echo -e "\e[0m"
}

# Function to get target
get_target() {
    read -p "Enter target IP or domain: " target
    if [ -z "$target" ]; then
        echo "Target cannot be empty!"
        get_target
    fi
}

# Function to get port
get_port() {
    read -p "Enter port number: " port
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "Invalid port number! Must be between 1-65535."
        get_port
    fi
}

# Function for HTTP/HTTPS methods check
check_http_methods() {
    local target=$1
    local port=${2:-80}
    local ssl=${3:-false}
    local proto="http"
    
    if [ "$ssl" = true ]; then
        proto="https"
    fi

    echo -e "\n\e[1;36mTesting HTTP Methods on $proto://$target:$port/\e[0m"
    echo "------------------------------------------------"
    
    # Test standard methods
    declare -a methods=("GET" "POST" "HEAD" "PUT" "DELETE" "OPTIONS" "TRACE" "PATCH")
    
    for method in "${methods[@]}"; do
        echo -n "Testing $method: "
        response=$(curl -s -I -X "$method" "$proto://$target:$port/" -o /dev/null -w "%{http_code}")
        if [ "$response" == "000" ]; then
            echo -e "\e[1;31mFailed to connect\e[0m"
        else
            echo -e "\e[1;32m$response\e[0m"
        fi
    done
    
    # Test for potentially dangerous methods
    echo -e "\n\e[1;33mTesting Potentially Dangerous Methods:\e[0m"
    declare -a dangerous_methods=("PROPFIND" "COPY" "LOCK" "MKCOL" "MOVE")
    
    for method in "${dangerous_methods[@]}"; do
        echo -n "Testing $method: "
        response=$(curl -s -I -X "$method" "$proto://$target:$port/" -o /dev/null -w "%{http_code}")
        if [ "$response" == "000" ]; then
            echo -e "\e[1;31mFailed to connect\e[0m"
        elif [ "$response" == "200" ] || [ "$response" == "207" ]; then
            echo -e "\e[1;31m$response (ENABLED - Potential Risk!)\e[0m"
        else
            echo -e "\e[1;32m$response\e[0m"
        fi
    done
}

# Function for SSL certificate info
ssl_cert_info() {
    local target=$1
    local port=${2:-443}
    
    echo -e "\n\e[1;36mSSL Certificate Information for $target:$port\e[0m"
    echo "------------------------------------------------"
    
    # Test if the port is open first
    if ! nc -z -w 3 "$target" "$port"; then
        echo "Port $port is not open or not responding."
        return
    fi
    
    echo -e "\n\e[1;33mBasic Certificate Info:\e[0m"
    openssl s_client -connect "$target:$port" -servername "$target" < /dev/null 2>/dev/null | \
        openssl x509 -noout -issuer -subject -dates
    
    echo -e "\n\e[1;33mCertificate Details:\e[0m"
    openssl s_client -connect "$target:$port" -servername "$target" < /dev/null 2>/dev/null | \
        openssl x509 -noout -text | grep -A1 "Version:\|Serial Number:\|Signature Algorithm:\|Issuer:\|Validity\|Subject:\|Public Key Algorithm:\|X509v3"
    
    echo -e "\n\e[1;33mCertificate Chain:\e[0m"
    openssl s_client -connect "$target:$port" -showcerts -servername "$target" < /dev/null 2>/dev/null
    
    echo -e "\n\e[1;33mCertificate Expiry Status:\e[0m"
    expiration=$(openssl s_client -connect "$target:$port" -servername "$target" < /dev/null 2>/dev/null | \
        openssl x509 -noout -enddate | cut -d= -f2)
    if [ -n "$expiration" ]; then
        exp_seconds=$(date -d "$expiration" +%s)
        now_seconds=$(date +%s)
        days_left=$(( (exp_seconds - now_seconds) / 86400 ))
        
        if [ "$days_left" -lt 0 ]; then
            echo -e "\e[1;31mCertificate expired $(( -1 * days_left )) days ago!\e[0m"
        elif [ "$days_left" -lt 30 ]; then
            echo -e "\e[1;33mCertificate expires in $days_left days ($expiration)\e[0m"
        else
            echo -e "\e[1;32mCertificate expires in $days_left days ($expiration)\e[0m"
        fi
    fi
}

# Function for full target information
get_target_info() {
    local target=$1
    
    echo -e "\n\e[1;36mComprehensive Target Information for $target\e[0m"
    echo "------------------------------------------------"
    
    # Basic network information
    echo -e "\n\e[1;33mNetwork Information:\e[0m"
    ip=$(dig +short "$target" | head -1)
    if [ -n "$ip" ]; then
        echo "IP Address: $ip"
        whois "$ip" | grep -i "netname\|country\|orgname\|originas\|descr" | head -10
    else
        echo "Could not resolve IP address"
    fi
    
    # DNS information
    echo -e "\n\e[1;33mDNS Information:\e[0m"
    dnsenum --noreverse "$target" | grep -A10 "Host's addresses"
    
    # WHOIS information
    echo -e "\n\e[1;33mWHOIS Information:\e[0m"
    whois "$target" | grep -v "^%" | head -20
    
    # Traceroute
    echo -e "\n\e[1;33mTraceroute:\e[0m"
    traceroute -m 10 "$target" 2>/dev/null || echo "Traceroute not available"
    
    # GeoIP information (using free API)
    echo -e "\n\e[1;33mGeolocation Information:\e[0m"
    if [ -n "$ip" ]; then
        curl -s "http://ip-api.com/json/$ip" | jq -r '. | "Country: \(.country)\nRegion: \(.regionName)\nCity: \(.city)\nISP: \(.isp)\nOrg: \(.org)\nAS: \(.as)\nLat/Lon: \(.lat),\(.lon)"'
    else
        echo "No IP available for geolocation lookup"
    fi
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice (1-8): " main_choice
    
    case $main_choice in
        1)  # Port Scanning Techniques
            while true; do
                show_port_scan_menu
                read -p "Enter your choice (1-7): " choice
                
                case $choice in
                    1) 
                        get_target
                        echo "Performing Quick Port Scan on $target..."
                        nmap -T4 -F $target
                        ;;
                    2)
                        get_target
                        echo "Performing Full Port Scan on $target..."
                        nmap -T4 -p- $target
                        ;;
                    3)
                        get_target
                        read -p "Enter custom port range (e.g., 20-80): " port_range
                        echo "Performing Custom Port Range Scan on $target..."
                        nmap -T4 -p $port_range $target
                        ;;
                    4)
                        get_target
                        echo "Performing TCP SCAN on $target..."
                        nmap -T4 -sT $target
                        ;;
                    5)
                        get_target
                        echo "Performing UDP SCAN on $target..."
                        nmap -T4 -sU $target
                        ;;
                    6)
                        get_target
                        echo "Scanning Top ports on $target..."
                        nmap -T4 --top-ports 50 $target
                        ;;
                    7)
                        break
                        ;;
                    *)
                        echo "Invalid choice. Please select a valid option."
                        ;;
                esac
                read -p "Press Enter to continue..."
            done
            ;;
        2)  # Service and Version Detection
            get_target
            echo "Performing Service and Version Detection on $target..."
            nmap -T4 -sV $target
            read -p "Press Enter to continue..."
            ;;
        3)  # Vulnerability Assessment
            get_target
            echo "Performing Vulnerability Scan on $target..."
            nmap -T4 --script vuln $target
            read -p "Press Enter to continue..."
            ;;
        4)  # Network Discovery
            get_target
            echo "Performing Network Discovery on $target..."
            nmap -T4 -sn $target
            read -p "Press Enter to continue..."
            ;;
        5)  # Web Application Tests
            while true; do
                show_web_tests_menu
                read -p "Enter your choice (1-5): " choice
                
                case $choice in
                    1)
                        get_target
                        get_port
                        check_http_methods "$target" "$port" false
                        ;;
                    2)
                        get_target
                        get_port
                        check_http_methods "$target" "$port" true
                        ;;
                    3)
                        get_target
                        read -p "Enter port number (default 443): " port
                        port=${port:-443}
                        ssl_cert_info "$target" "$port"
                        ;;
                    4)
                        get_target
                        echo "Performing Web Server Enumeration on $target..."
                        nmap -T4 --script http-enum $target
                        ;;
                    5)
                        break
                        ;;
                    *)
                        echo "Invalid choice. Please select a valid option."
                        ;;
                esac
                read -p "Press Enter to continue..."
            done
            ;;
        6)  # Target Information Gathering
            get_target
            get_target_info "$target"
            read -p "Press Enter to continue..."
            ;;
        7)  # Advanced Techniques
            while true; do
                show_advanced_menu
                read -p "Enter your choice (1-5): " choice
                
                case $choice in
                    1)
                        get_target
                        echo "Available NSE script categories:"
                        echo "1) safe         - Non-intrusive scripts"
                        echo "2) vuln         - Vulnerability detection"
                        echo "3) exploit      - Exploitation scripts"
                        echo "4) auth         - Authentication related"
                        echo "5) discovery    - Service discovery"
                        echo "6) brute        - Brute force attacks"
                        echo "7) custom       - Enter script name manually"
                        read -p "Select category (1-7) or press Enter for default (safe): " nse_category
                        
                        case $nse_category in
                            1) script_arg="--script=safe";;
                            2) script_arg="--script=vuln";;
                            3) script_arg="--script=exploit";;
                            4) script_arg="--script=auth";;
                            5) script_arg="--script=discovery";;
                            6) script_arg="--script=brute";;
                            7) 
                                read -p "Enter script name or path (e.g., http-title, smb-vuln-ms17-010): " custom_script
                                script_arg="--script=$custom_script"
                                ;;
                            *) script_arg="--script=safe";;
                        esac
                        
                        read -p "Enter port (leave empty for all ports): " nse_port
                        if [ -n "$nse_port" ]; then
                            port_arg="-p $nse_port"
                        else
                            port_arg=""
                        fi
                        
                        echo "Performing NSE Script Scan on $target..."
                        nmap -T4 $port_arg $script_arg $target
                        ;;
                    2)
                        get_target
                        echo "Available MAC address spoofing options:"
                        echo "1) Random MAC"
                        echo "2) Cisco"
                        echo "3) Apple"
                        echo "4) Samsung"
                        echo "5) Microsoft"
                        read -p "Select vendor (1-5): " mac_choice
                        
                        case $mac_choice in
                            1) mac_arg="random";;
                            2) mac_arg="Cisco";;
                            3) mac_arg="Apple";;
                            4) mac_arg="Samsung";;
                            5) mac_arg="Microsoft";;
                            *) mac_arg="random";;
                        esac
                        
                        echo "Performing scan with spoofed MAC ($mac_arg)..."
                        nmap -T4 -sT --spoof-mac $mac_arg $target
                        ;;
                    3)
                        get_target
                        echo "Performing Aggressive Scan on $target..."
                        nmap -T4 -A $target
                        ;;
                    4)
                        get_target
                        echo "Performing Firewall Detection on $target..."
                        nmap -T4 -sA $target
                        ;;
                    5)
                        break
                        ;;
                    *)
                        echo "Invalid choice. Please select a valid option."
                        ;;
                esac
                read -p "Press Enter to continue..."
            done
            ;;
        8)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done
