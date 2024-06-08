#!/bin/bash

install_tools() 
{

  local wireguard_bin
  wireguard_bin="/usr/bin/wg"
  local ufw_bin
  ufw_bin="/usr/sbin/ufw"
  local curl_bin
  curl_bin="/usr/bin/curl"

  echo "Updating the system..."
  sleep 4
  sudo apt update

  # declare associative array
  declare -A packages_to_install

  # insert value in the associative array
  packages_to_install["wireguard"]="/usr/bin/wg"
  packages_to_install["ufw"]="/usr/sbin/ufw"
  packages_to_install["curl"]="/usr/bin/curl"

  # for each key in array, access the value
  for elem in "${!packages_to_install[@]}"
  do
    if [[ ! -f "${packages_to_install[${elem}]}" ]]; then
      echo "Installing ${elem}..."
      sleep 4
      sudo apt install "${elem}" -y
    fi
  done

}

server_configuration()
{

  # file security

  umask 077
  
  # directory to save keys
  local server_keys_dir
  server_keys_dir="/home/${USER}/server_keys"

  if [[ -d "${server_keys_dir}" ]]; then
    echo "The directory already exists, next step will create the private and public keys"
  else
    echo "Creating the directory to save keys in ${server_keys_dir}"
    mkdir "${server_keys_dir}"
    sleep 2
  fi 

  # create private key and derive the public key from it

  echo "Creating private and public key for the server"
  sleep 3
  echo
  wg genkey | tee ${server_keys_dir}/server.key | wg pubkey > ${server_keys_dir}/server.pub

  # < is faster than cat, https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html
  local private_key_server
  private_key_server=$(< ${server_keys_dir}/server.key)
  public_key_server=$(< ${server_keys_dir}/server.pub)

  # server configuration file

  cat << EOF | sudo tee -a /etc/wireguard/wg0.conf
[Interface]
PrivateKey = ${private_key_server}
Address = ${IP_ADDRESS_SERVER}
ListenPort = ${LISTEN_PORT}
SaveConfig = true
EOF

  # network forwarding

  sudo sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" /etc/sysctl.conf

  # firewall rules

  cat << EOF | sudo tee -a /etc/wireguard/wg0.conf
PostUp = ufw route allow in on wg0 out on ${NETWORK_INTERFACE} 
PostUp = iptables -t nat -I POSTROUTING -o ${NETWORK_INTERFACE} -j MASQUERADE
PreDown = ufw route delete allow in on wg0 out ${NETWORK_INTERFACE}
PreDown = iptables -t nat -D POSTROUTING -o ${NETWORK_INTERFACE} -j MASQUERADE
EOF

  # allow ssh

  sudo ufw allow OpenSSH

  # allow Wireguard

  sudo ufw allow 51820/udp

  # restart ufw

  sudo ufw disable
  echo y | sudo ufw enable

  # starting Wireguard server

  sudo systemctl enable wg-quick@wg0.service
  sudo systemctl start wg-quick@wg0.service
  sudo systemctl status wg-quick@wg0.service

}

peer_configuration()
{

  # file security

  umask 077

  local peer_keys_dir
  peer_keys_dir="/home/${USER}/peer_keys"

  # keep the name of the file entered by user in a new variable
  local name_key
  name_key="${1}"

  if [[ -d "${peer_keys_dir}" ]]; then
    echo "The directory already exists, next step will create the private and public keys"
  else
    echo "Creating the directory to save keys in ${peer_keys_dir}"
    mkdir "${peer_keys_dir}"
    sleep 2
  fi 

  echo "Displaying current private and public keys"
  sleep 2
  ls /home/"${USER}"/peer_keys

  echo "Creating private and public key for the peer"
  echo
  sleep 3

  wg genkey | tee "${peer_keys_dir}"/"${name_key}".key | wg pubkey > "${peer_keys_dir}"/"${name_key}".pub

  local private_key_peer
  private_key_peer=$(< ${peer_keys_dir}/${name_key}.key)
  local server_keys_dir
  server_keys_dir="/home/${USER}/server_keys"
  public_key_peer=$(< ${peer_keys_dir}/${name_key}.pub)
  public_key_server=$(< ${server_keys_dir}/server.pub)
  public_ip_address=$(curl -s ip.me)

  local allowed_ip_arg
  read -p "Please enter the IP address and the CIDR that will be allowed for the peer (e.g. 192.168.1.0/24), multiple IPs must be seperated by commas: " allowed_ip_arg

  # peer configuration file
  # endpoint will be the public ip address

  cat << EOF | sudo tee -a /etc/wireguard/${name_key}.conf
[Interface]
PrivateKey = ${private_key_peer}
Address = ${allowed_ip_arg}
ListenPort = ${LISTEN_PORT}

[Peer]
PublicKey = ${public_key_server}
AllowedIPs = ${IP_NETWORK_ID}
Endpoint = ${public_ip_address}:${LISTEN_PORT} 
EOF

  # adding peer pubkey to server conf

  sudo wg set wg0 peer "${public_key_peer}" allowed-ips "${allowed_ip_arg}"

}

add_allowed_ips()
{

  local peer_keys_dir
  peer_keys_dir="/home/${USER}/peer_keys"

  echo "Displaying public keys from the directory ${peer_keys_dir}"
  tail ${peer_keys_dir}/*.pub

  local public_key_choice
  read -p "Please enter the public key (related to a peer) to update the allowed ips: " public_key_choice

  local ip_choice
  read -p "Please enter the new IP address and the CIDR. Careful, current IPs will be overwritten: " ip_choice

  sudo wg set wg0 peer "${public_key_choice}" allowed-ips "${ip_choice}"

}

remove_wireguard()
{

  local peer_keys_dir
  peer_keys_dir="/home/${USER}/peer_keys"
  local server_keys_dir
  server_keys_dir="/home/${USER}/server_keys"
  local wireguard_bin
  wireguard_bin="/usr/bin/wg"
  local wireguard_config
  wireguard_config="/etc/wireguard"

  echo "This will remove all the WireGuard configuration:"
  echo "1. Directories to store keys: ${peer_keys_dir} and ${server_keys_dir}"
  echo "2. WireGuard package"
  echo "3. WireGuard configuration files for the server and peers (in /etc/wireguard/)"
  echo "4. WireGuard interface wg0"
  echo "5. UFW package and configuration"

  read -p "Do you want to proceed? [y/n] " choice
  # convert to lowercase
  choice=$(echo "${choice}" | tr ‘[A-Z]‘ ‘[a-z]‘)

  allowed_yes="y|yes"

  if [[ "${choice}" =~ ^(${allowed_yes})$ ]]; then
    echo "1. Removing directories where keys were stored..."
      if [[ -d "${server_keys_dir}" ]]; then
        rm -r ${server_keys_dir}
      fi
      if [[ -d "${peer_keys_dir}" ]]; then
        rm -r ${peer_keys_dir}
      fi

    sleep 1

    echo "2. Removing WireGuard package..."
    sudo apt remove wireguard
    sudo apt autoremove

    sleep 1

    echo "3. Removing configuration files for server and peers..."
      if [[ -d "${wireguard_config}" ]]; then
        sudo rm -r /etc/wireguard
      fi

    sleep 1

    echo "4. Removing wg0 interface..."
    sudo ip link delete wg0

    sleep 1

    echo "5. Removing UFW package..."
    sudo apt remove ufw
    sudo apt autoremove

  else
   echo "The configuration will stay as it is, exiting program"
   exit
  fi

}

usage()
{

  echo "DESCRIPTION"
  echo "  Management tool for WireGuard written in Bash"
  echo "  Can install, configure and create peers on the host"
  echo
  echo "USAGE"
  echo "  ${0} [-i] [-s] [-p peer_name] [-a] [-r]"
  echo
  echo "OPTIONS"
  echo "  -i"
  echo "    Install tools (cURL, WireGuard, UFW) mandatory for the installation, should be run only once"
  echo
  echo "  -s"
  echo "    Install the server configuration. Should be run only once."
  echo
  echo "  -p"
  echo "    Create a new peer, can be run multiple times. Please choose different names for the configuration file"
  echo
  echo "  -a"
  echo "    Add an allowed ip to an already created peer. Display current public keys and ask you an IP address with CIDR and the public key"
  echo
  echo "  -r"
  echo "    Remove all the WireGuard packages and configuration including keys"

}

main() 
{

  IP_ADDRESS_SERVER="192.168.2.1/29"
  IP_NETWORK_ID="192.168.2.0/29"
  LISTEN_PORT="51820"
  NETWORK_INTERFACE=$(ip -o -4 route show to default | awk '{print $5}')

  # print usage with no argument or help argument
  if [[ ${#} -eq 0 ]] || [[ "${1}" == "--help" ]]; then
    usage
    exit 0
  fi

  while getopts "isp:ar" opt
  do
    case ${opt} in
      i) install_tools ;;

      s) server_configuration ;;

      p) peer_configuration "${OPTARG}" ;;

      a) add_allowed_ips ;;

      r) remove_wireguard ;;

      /?) echo "Invalid option: -${OPTARG}" >&2
          exit 1 ;;
    esac
  done

}

main "$@"
