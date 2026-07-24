#!/bin/bash

#--------------------------------------------------
# network aliases
#--------------------------------------------------

alias local-ip='_echo_info "hostname -I\n"; hostname -I' ## Print local ip
alias open-ports='_echo_info "lsof -i -Pn | grep LISTEN\n"; lsof -i -Pn | grep LISTEN' ## List open ports
alias test-tor='curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -m 1 Congratulations' ## Check Tor configuration

alias close-ssh-tunnels='sudo pkill ssh'                ## Close all ssh tunnels
alias find-ssh-process='ps aux | grep ssh'              ## Find ssh processes
alias list-ssh='netstat -n --protocol inet | grep :22'  ## List open ssh connections
alias mac='ifconfig | grep HWaddr'                      ## Print mac address
alias resolve='_echo_info "host\n" &&; host'             ## Resolve reverse hostname
alias iptables-list-rules='_echo_info "sudo iptables -S"; sudo iptables -S; _echo_info "sudo iptables -L\n"; sudo iptables -L' ## list iptables rules
alias start-vnc='_echo_info "x11vnc -usepw -bg -forever\n"; x11vnc -usepw -bg -forever' ## Start VNC server in the background
alias stop-vnc='_echo_info "x11vnc -remote stop\n"; x11vnc -remote stop' ## Start VNC server in the background
alias start-ssh='sudo systemctl start ssh'              ## Start SSH server
alias stop-ssh='sudo systemctl stop ssh'                ## Stop SSH server
