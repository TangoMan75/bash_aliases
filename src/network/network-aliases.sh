#!/bin/bash

#--------------------------------------------------
# network aliases
#--------------------------------------------------

alias local-ip='echo_info "hostname -I"; hostname -I'                               ## Print local ip
alias open-ports='echo_info "lsof -i -Pn | grep LISTEN"; lsof -i -Pn | grep LISTEN' ## List open ports
alias test-tor='curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -m 1 Congratulations' ## Check Tor configuration

alias close-ssh-tunnels='sudo pkill ssh'               ## Close all ssh tunnels
alias find-ssh-process='ps aux | grep ssh'             ## Find ssh processes
alias list-ssh='netstat -n --protocol inet | grep :22' ## List open ssh connections
alias mac='ifconfig | grep HWaddr'                     ## Print mac address
alias resolve='echo_info "host" &&; host'              ## Resolve reverse hostname
alias iptables-list-rules='echo_info "sudo iptables -S"; sudo iptables -S; echo_info "sudo iptables -L"; sudo iptables -L' ## list iptables rules
alias start-vnc='echo_info "x11vnc -usepw -bg -forever"; x11vnc -usepw -bg -forever' ## Start VNC server in the background
alias stop-vnc='echo_info "x11vnc -remote stop"; x11vnc -remote stop' ## Start VNC server in the background
alias start-ssh='sudo systemctl start ssh'             ## Start SSH server
alias stop-ssh='sudo systemctl stop ssh'               ## Stop SSH server