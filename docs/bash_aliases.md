TangoMan bash_aliases documentation
===================================

src
---

### cc

```bash
'clear'
```

clear terminal

### ccc

```bash
'clear && history -c'
```

clear terminal & history

### h

```bash
'echo_info "history"; history'
```

history

### hh

```bash
'echo_info "history|grep"; history|grep'
```

search history

### hhh

```bash
'cut -f1 -d" " ~/.bash_history|sort|uniq -c|sort -nr|head -n 30'
```

print most used commands

### ll

```bash
'echo_info "ls -lFh"; ls -lFh'
```

list non hidden files human readable

### lll

```bash
'echo_info "ls -alFh"; ls -alFh'
```

list all files human readable

### mkdir

```bash
'mkdir -p'
```

create necessary parent directories

### unmount

```bash
'umout'
```

unmout

### xx

```bash
'exit'
```

disconnect

### clip

Send output to xclip when available

utils
-----

### decode

Decode string from base64 format

### strreplace

Search and replace string from files

### help

Print help for desired option

### compress

Compress a file, a folder or each subfolders into separate archives recursively with 7z

### create-desktop-shortcut

Create a shortcut on user destop

### rename

Rename files from given folder (creates undo script)

### random-string

Generate random string

### extract-archives

Extract each archive to destination

### clean-folder

recursively delete junk from folder

### exists

Check if program is installed, and command or function exists

### url-to-markdown

Finds every `url` file from given folder appends urls and titles into markdown file

### move-all-files-here

Move all files from subfolders ibto current folder

### search

Find file in current directory

### archive

Compress / extract tar archive

### rename-script-generator

Generate rename script in current folder

### size

Print total size of file and folders

### encode

Encode string from base64 format

### cheat

Print help cheat.sh in your terminal

header
------

### echo_hero

print hero header

system
------

### pkg-search

Find / list available apt packages

### pkg-installed

Find / list installed apt packages

### create-user

Create new user

### pkg-install

Install package on multiple systems

### drives

list connected drives (ignore loop devices)

### disks

```bash
'drives'
```

List devices

### devices

```bash
'drives'
```

List devices

### own

Own files and folders

### pkg-remove

Shortcut for apt-get remove -y

### symlink

Create symlink

### systemct-list

```bash
'systemctl list-unit-files | grep enabled'
```

List enabled services

### codename

Get linux codename

### bootable-iso

Create bootable usb flash drive from iso file or generate iso file from source

### pkg-list

Find / list available apt packages

### distribution

Get linux distribution

multimedia
----------

### picture-list-exif

Lists picture exif modified at

### picture-organize

Organise picture and videos by last modified date into folders (creates undo script)

### play

Play folder with vlc

### picture-rename-to-datetime

Rename pictures to date last modified (creates undo script)

### picture-update-datetime

Update picture modified at from filename (creates undo script)

docker
------

### docker-status

List images, volumes and network information

### dst

```bash
'docker-status'
```

docker-status alias

### dc-status

```bash
'docker-status'
```

docker-status alias

### docker-exec

Execute command inside given container

### dex

```bash
'docker-exec'
```

docker-exec alias

### dc-exec

```bash
'docker-exec'
```

docker-exec alias

### docker-stop

Stop running containers

### dsp

```bash
'docker-stop'
```

docker-stop alias

### dc-stop

```bash
'docker-stop'
```

docker-stop alias

### docker-shell

Enter interactive shell inside given container

### dsh

```bash
'docker-shell'
```

docker-shell alias

### dc-shell

```bash
'docker-shell'
```

docker-shell alias

### docker-kill

Kill running containers

### dkl

```bash
'docker-kill'
```

docker-kill alias

### dc-kill

```bash
'docker-kill'
```

docker-kill alias

### docker-clean

Remove all unused system, images, containers, volumes and networks

### dcc

```bash
'docker-clean'
```

docker-clean alias

### dc-clean

```bash
'docker-clean'
```

docker-clean alias

### docker-list

List containers

tangoman
--------

### tango-doc

Print bash_aliases documentation

### tango-info

Print current system infos

### tango-config

Config bash_aliases default settings

### tango-reload

Reload aliases (after update)

### tango-update

Self-update tangoman bash_aliases

git
---

### lremote

List remote git branches

### push

Update remote git repository

### dashboard

Print git dashboard

### gst

```bash
'dashboard'
```

print git dashboard

### commit

Write changes to repository, or rename last commit

### toplevel

Jump to git toplevel folder

### cdgit

```bash
'toplevel'
```

jump to project top level folder

### rebase

Clean local commit history

### gstatus

Print git status

### branch-exists

Check if git branch exists

### add

Stage files to git index

### clone

Clone remote git repository to local folder

### greset

Reset current git history

### current

```bash
'echo "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"'
```

print current branch name

### fetch

```bash
'echo_info "git fetch --all"; git fetch --all'
```

fetch all branches

### latest-sha

```bash
'echo_info "git rev-parse --verify HEAD"; git rev-parse --verify HEAD'
```

print latest commit sha

### log

```bash
'echo_info "git log --graph --stat"; git log --graph --stat'
```

print full git log

### previous-sha

```bash
'echo_info "git rev-parse --verify HEAD^1"; git rev-parse --verify HEAD^1'
```

print previous commit sha

### repository-name

```bash
'echo $(git remote get-url origin|sed -E "s/(http:\/\/|https:\/\/|git@)//"|sed -E "s/\.git$//"|tr ":" "/"|cut -d/ -f3)'
```

print remote repository name

### repository

```bash
'echo "$(basename `git rev-parse --show-toplevel` 2>/dev/null)"'
```

print current toplevel folder name

### undo

```bash
'echo_info "git checkout -- ."; git checkout -- .'
```

remove all changes

### what

```bash
'echo_info "git whatchanged -p --abbrev-commit --pretty=medium"; git whatchanged -p --abbrev-commit --pretty=medium'
```

print changes from every commit

### list-github

Lists GitHub user repositories

### amend

mend last commit message, author and date

### remote

Set / print local git repository server configuration

### config

Set bash_aliases git global settings

### list-bitbucket

Lists private repositories from bitbucket

### lbranches

List local git branches

### lb

```bash
'lbranches'
```

list branches

### branch

Create, checkout, rename or delete git branch

### backup

Backup current local repository to remote server

### guser

Print / update git account identity

### tag

Create, list or return latest tag

### gdiff

Print changes between working tree and latest commit

### diff

```bash
'gdiff'
```

git diff

### init

Initialize git repository

### pull

Fetch from remote repository to local branch

### reclone

Reclone git repository

### bitbucket

Create new private git repository on bitbucket

### stash

Manage stashed files

### delete-github-workflows

Delete old Github workflows

### merge

Merge git branch into current branch

strings
-------

### urldecode

Encode string to URL format

### echo_box

Print formatted text inside box with optional title, footer and size (remove indentation)

### urlencode

Decode string from URL format

### trim

```bash
"sed -E 's/^[[:space:]]*//'|sed -E 's/[[:space:]]*$//'"
```

trim given string

network
-------

### port-scan

Scan ports with nmap

### local-ip

```bash
'echo_info "hostname -I"; hostname -I'
```

Print local ip

### open-ports

```bash
'echo_info "lsof -i -Pn | grep LISTEN"; lsof -i -Pn | grep LISTEN'
```

List open ports

### test-tor

```bash
'curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -m 1 Congratulations'
```

Check Tor configuration

### close-ssh-tunnels

```bash
'sudo pkill ssh'
```

Close all ssh tunnels

### find-ssh-process

```bash
'ps aux | grep ssh'
```

Find ssh processes

### list-ssh

```bash
'netstat -n --protocol inet | grep :22'
```

List open ssh connections

### mac

```bash
'ifconfig | grep HWaddr'
```

Print mac address

### resolve

```bash
'echo_info "host" &&; host'
```

Resolve reverse hostname

### iptables-list-rules

```bash
'echo_info "sudo iptables -S"; sudo iptables -S; echo_info "sudo iptables -L"; sudo iptables -L'
```

list iptables rules

### start-vnc

```bash
'echo_info "x11vnc -usepw -bg -forever"; x11vnc -usepw -bg -forever'
```

Start VNC server in the background

### stop-vnc

```bash
'echo_info "x11vnc -remote stop"; x11vnc -remote stop'
```

Start VNC server in the background

### start-ssh

```bash
'sudo systemctl start ssh'
```

Start SSH server

### stop-ssh

```bash
'sudo systemctl stop ssh'
```

Stop SSH server

### unmount-nfs

unmount nfs share into /media/nfs

### set_hosts

set your /etc/hosts

### port-redirect

Redirect ports with iptables

### unset-hosts

Comment out desired host from /etc/hosts

### wifi-get-bssids

Print available bssids, channels and ssids

### wifi-radar

Discover available wireless networks

### wifi-monitor-mode

Set wlan adapter to monitor mode

### check-dns

Check DNS records

### mount-nfs

mount nfs share into /media/nfs

### external-ip

Get external IP

### ping-scan

Ping scan with nmap

### quick-scan

Quick scan local network with nmap

### wifi-managed-mode

Set wlan adapter to managed mode

### hosts

Edit hosts

### mysql-start

```bash
'sudo /etc/init.d/mysql start'
```

start mysql server

### mysql-stop

```bash
'sudo /etc/init.d/mysql stop'
```

stop mysql server

ssh
---

### switch_default_id

Switch default ssh id

php
---

### php-server

Start php built-in server

### storm

Open file at given line with phpstorm-url-handler

### set-php-version

set default php version

system_dependant
----------------

### clear-chrome-cache

kill google chrome process and clear cache on linux

### open

Open file or folder with appropriate app

### tt

```bash
'echo_info "gnome-terminal --working-directory=`pwd`"; gnome-terminal --working-directory=`pwd`'
```

open current location in terminal

security
--------

### wifi-sniff

Dump captured packets from target adapter

### reverse-shell

Create a reverse shell connection

### wifi-fakeauth

Associates with target wifi network

### wifi-deauth

Disconnect client from wifi network

### change-mac-address

Spoof network adapter mac address

symfony
-------

### sf-nuke

Removes symfony cache, logs, sessions and vendors

### sf-lint

Run php-cs-fixer linter

### sf-tests

Run phpunit tests

### sf

Returns appropriate symfony console location

### sf-server

Start Symfony binary server

### sf-dump-server

Start project debug server

### sf-rebuild

Creates symfony var/cache, var/logs, var/sessions

### cache

```bash
'sf cache:clear --env=prod'
```

clears the cache

### router

```bash
'sf debug:router'
```

debug router

### schema-update

```bash
'sf doctrine:schema:update --dump-sql --force'
```

update database shema

### services

```bash
'sf debug:container'
```

debug container

### warmup

```bash
'sf cache:warmup --env=prod'
```

warms up an empty cache

python
------

### py

```bash
'python3'
```

Execute python3 command

### pytests

```bash
'echo_info "python3 -m unittest -v" && python3 -m unittest -v'
```

Perform python unittest

### py-install

```bash
'pip3 install -r requirements.txt'
```

Install requirements.txt with pip3

### py-server

Start python built-in server

web
---

### gg

```bash
'google'
```

google

### gif

```bash
'giphy'
```

giphy

### yt

```bash
'youtube'
```

youtube

### lmgtfy

Let me google that for you search

### giphy

Search on giphy.com

### github

Search on github.com

### google

Search on google.com

### youtube

Search on youtube.com

### trends

Search on google trends

