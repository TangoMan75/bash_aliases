TangoMan bash_aliases documentation
===================================

⚡ bash
--------

⚡ aliases
-----------

### 🤡 cc

Clear terminal

```bash
'clear'
```

### 🤡 ccc

Clear terminal & history

```bash
'history -c && clear'
```

### 🤡 h

Print history

```bash
'echo_info "history\n"; history'
```

### 🤡 hh

Search history

```bash
'echo_info "history|grep\n"; history|grep'
```

### 🤡 hhh

Print 30 most used bash commands

```bash
'cut -f1 -d" " ~/.bash_history|sort|uniq -c|sort -nr|head -n 30'
```

### 🤡 ll

List non hidden files human readable

```bash
'echo_info "ls -lFh\n"; ls -lFh'
```

### 🤡 lll

List all files human readable

```bash
'echo_info "ls -alFh\n"; ls -alFh'
```

### 🤡 mkdir

Create directory and required parent directories

```bash
'mkdir -p'
```

### 🤡 unmount

Unmout drive

```bash
'umount'
```

### 🤡 xx

Exit terminal

```bash
'exit'
```

### 🤡 s

Open with sublime text (requires subl)

```bash
'subl'
```

### 🤡 xcopy

Copy to clipboard with xsel (requires xsel)

```bash
'xsel --input --clipboard'
```

### 🤡 xpaste

Paste from clipboard with xsel (requires xsel)

```bash
'xsel --output --clipboard'
```

### 🤡 clip

Copy selection to clipboard with xclip (requires xclip)

```bash
'xclip -selection clipboard'
```

⚡ dev
-------

### 🤖 _list_ides

List installed ides

### 🤖 open-in-ide

Open given files in ide

### 🤡 ide

open-in-ide alias

```bash
'open-in-ide'
```

⚡ docker
----------

### 🤖 docker-clean

Remove unused containers, images, networks, system and volumes

### 🤡 dcc

docker-clean alias

```bash
'docker-clean'
```

### 🤖 docker-exec

Execute command inside given container (interactive)

### 🤡 dex

docker-exec alias

```bash
'docker-exec'
```

### 🤖 docker-kill

Kill running containers

### 🤡 dkl

docker-kill alias

```bash
'docker-kill'
```

### 🤖 docker-list

List running containers

### 🤡 dls

docker-list alias

```bash
'docker-list'
```

### 🤖 docker-restart

Restart container (interactive)

### 🤡 drt

docker-restart alias

```bash
'docker-restart'
```

### 🤖 docker-shell

Enter interactive shell inside container (interactive)

### 🤡 dsh

docker-shell alias

```bash
'docker-shell'
```

### 🤖 docker-status

List images, volumes and network information

### 🤡 dst

docker-status alias

```bash
'docker-status'
```

### 🤖 docker-stop

Stop running containers

### 🤡 dsp

docker-stop alias

```bash
'docker-stop'
```

⚡ git
-------

### 🤖 git-config

Config bash_aliases git default settings

### 🤖 add

Stage files to git index

### 🤡 glp

Pretty Git Log

```bash
'git log --pretty)
```

### 🤖 amend

mend last commit message, author and date

### 🤖 blame

Show what revision and author last modified each line of a file

### 🤖 _branch_exists

Check branch exists

### 🤖 branch

Create, checkout, rename or delete git branch

### 🤡 gb

Create, checkout, rename or delete git branch

```bash
'branch'
```

### 🤖 checkout

Restore working tree files

### 🤖 clean-unreachable

Clean unreachable loose objects

### 🤖 clone

Clone remote git repository locally (pulling submodules if any)

### 🤖 _commit_exists

Check commit exists

### 🤖 commit

Write changes to local repository

### 🤖 conventional-branch

reate conventional branch name

### 🤖 conventional-commit

reate conventional commit message

### 🤖 delete-github-workflows

Delete old Github workflows

### 🤖 fetch

Fetch remote branches

### 🤖 _trim

rim

### 🤖 _format_type

ormat type

### 🤖 _format_ticket

ormat ticket

### 🤖 _format_branch_subject

ormat branch subject

### 🤖 _format_commit_subject

ormat commit subject

### 🤖 gabort

Abort the rebase or pick operation

### 🤖 gcontinue

Continue the rebase or pick operation

### 🤖 gdiff

Show changes between commits, commit and working tree, etc

### 🤖 _get_current_branch

Get current branch name

### 🤖 _get_main_branch

Get main branch name

### 🤖 get_url

et repository url from local config

### 🤡 what

Print changes from every commit

```bash
'echo_info "git whatchanged -p --abbrev-commit --pretty
```

### 🤖 greset

Reset current branch to a previous commit

### 🤖 gstatus

Print TangoMan git status

### 🤡 gst

Print TangoMan git gstatus

```bash
'gstatus'
```

### 🤖 guser

Print / update git account identity

### 🤖 init

Initialize git repository

### 🤖 _is_cherry_pick_in_progress

Check cherry-pick is in progress

### 🤖 _is_rebase_in_progress

Check rebase is in progress

### 🤖 list-bitbucket

Lists bitbucket user public repositories, try browsing "https://bitbucket.org/repo/all

### 🤖 list-github

Lists GitHub user repositories

### 🤖 log

Print git log

### 🤖 lremote

Print origin settings

### 🤖 merge

Merge git branch into current branch

### 🤖 open-commit-files-in-ide

Open modified/conflicting files in ide

### 🤡 iopen

open-commit-files-in-ide alias

```bash
'open-commit-files-in-ide'
```

### 🤖 _check_branch_is_valid

heck branch is valid

### 🤖 _parse_branch_type

arse branch type, eg: feat/FOO-01/foobar => fix

### 🤖 _parse_branch_ticket

arse branch ticket, eg: feat/FOO-01/foobar => FOO-01

### 🤖 _parse_branch_subject

arse branch subject, eg: feat/FOO-01/foobar => foobar

### 🤖 _get_branch_type

et branch type

### 🤖 _get_branch_ticket

et branch ticket

### 🤖 _get_branch_subject

et branch subject

### 🤖 _check_commit_is_valid

heck commit hash is valid

### 🤖 _parse_commit_type

arse commit type, eg: feat(foobar): FooBar (FOO-01) => feat

### 🤖 _parse_commit_scope

arse commit scope, eg: feat(foobar): FooBar (FOO-01) => foobar

### 🤖 _parse_commit_subject

arse commit subject, eg: feat(foobar): FooBar (FOO-01) => FooBar

### 🤖 _parse_commit_ticket

arse commit ticket, eg: feat(foobar): FooBar (FOO-01) => FOO-01

### 🤖 _parse_commit_pull_request

arse commit pull request, eg: feat(foobar): FooBar (FOO-01) (#4321) => 4321

### 🤖 _get_commit_type

et commit type

### 🤖 _get_commit_scope

et commit scope

### 🤖 _get_commit_subject

et commit subject

### 🤖 _get_commit_ticket

et commit ticket

### 🤖 _get_commit_pull_request

et commit pull request

### 🤖 _get_commit_body

et commit body

### 🤖 _pick_branch

Select a branch among multiple options

### 🤖 _pick_commit

Select a commit among multiple options

### 🤖 _pick_repository

Select a repository among multiple options

### 🤖 pick

Apply a commit from another branch

### 🤖 _print_jira_url

rint Jira url

### 🤖 pull

Pull git history from remote repository

### 🤖 push

Update remote git repository

### 🤖 rebase

Reorganize local commit history

### 🤖 reflog

Execute git reflog

### 🤖 reinit

Reset current git history

### 🤖 remote

Set / print local git repository server configuration

### 🤖 show

Print changes from given commit

### 🤖 stash

Manage stashed files

### 🤖 tag

Create, list or return latest tag

⚡ _header
-----------

### 🤖 _create_env

Create ".env" file into "~/.TangoMan75/bash_aliases/config" folder

### 🤖 hero

print TangoMan hero

### 🤖 _load_env

Load ".env"

### 🤖 _set_var

Set parameter to ".env" file

⚡ multimedia
--------------

### 🤖 convert-md

Convert Markdown to html or pdf format

### 🤖 picture-get-names

Print image subject names from file exif data

### 🤖 picture-jpeg-optimize

Optimize JPG images and remove exif

### 🤖 picture-list-exif

Lists picture exif modified at

### 🤖 picture-organize

Organise pictures and videos by last modified date into folders (creates undo script)

### 🤖 picture-rename-to-datetime

Rename pictures to date last modified (creates undo script)

### 🤖 picture-resize

Resize images

### 🤖 picture-update-datetime

Update picture datetime from filename (creates undo script)

### 🤖 play

Play folder with vlc

### 🤖 rename-extension-to-codec

Change multimedia file to correct extension

⚡ network
-----------

### 🤖 check-dns

Check DNS records

### 🤖 external-ip

Get external IP

### 🤖 hosts

Edit hosts with default text editor

### 🤖 list-adapters

List network adapters

### 🤖 mount-nfs

Mount nfs shared ressource into local mount point

### 🤡 local-ip

Print local ip

```bash
'echo_info "hostname -I\n"; hostname -I'
```

### 🤡 open-ports

List open ports

```bash
'echo_info "lsof -i -Pn | grep LISTEN\n"; lsof -i -Pn | grep LISTEN'
```

### 🤡 test-tor

Check Tor configuration

```bash
'curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -m 1 Congratulations'
```

### 🤡 close-ssh-tunnels

Close all ssh tunnels

```bash
'sudo pkill ssh'
```

### 🤡 find-ssh-process

Find ssh processes

```bash
'ps aux | grep ssh'
```

### 🤡 list-ssh

List open ssh connections

```bash
'netstat -n --protocol inet | grep :22'
```

### 🤡 mac

Print mac address

```bash
'ifconfig | grep HWaddr'
```

### 🤡 resolve

Resolve reverse hostname

```bash
'echo_info "host\n" &&; host'
```

### 🤡 iptables-list-rules

list iptables rules

```bash
'echo_info "sudo iptables -S"; sudo iptables -S; echo_info "sudo iptables -L\n"; sudo iptables -L'
```

### 🤡 start-vnc

Start VNC server in the background

```bash
'echo_info "x11vnc -usepw -bg -forever\n"; x11vnc -usepw -bg -forever'
```

### 🤡 stop-vnc

Start VNC server in the background

```bash
'echo_info "x11vnc -remote stop\n"; x11vnc -remote stop'
```

### 🤡 start-ssh

Start SSH server

```bash
'sudo systemctl start ssh'
```

### 🤡 stop-ssh

Stop SSH server

```bash
'sudo systemctl stop ssh'
```

### 🤖 port-redirect

Redirect ports with iptables

### 🤖 scan

Scan with nmap

### 🤖 set_hosts

Create / delete hosts in /etc/hosts

### 🤖 unmount-nfs

Unmount nfs share

### 🤖 wifi-get-bssids

Print available bssids, channels and ssids

### 🤖 wifi-managed-mode

Set wlan adapter to managed mode

### 🤖 wifi-monitor-mode

Set wlan adapter to monitor mode

### 🤖 wifi-radar

Discover available wireless networks

⚡ php
-------

### 🤖 php-server

Start php built-in server

### 🤖 set-php-version

Set default php version

⚡ python
----------

### 🤖 py-server

Start python built-in server

### 🤡 py

Execute python3 command

```bash
'python3'
```

### 🤡 pytests

Perform python unittest

```bash
'echo_info "python3 -m unittest -v\n" && python3 -m unittest -v'
```

### 🤡 py-install

Install requirements.txt with pip3

```bash
'pip3 install -r requirements.txt'
```

⚡ security
------------

### 🤖 change-mac-address

Spoof network adapter mac address (generates random mac if not provided)

### 🤖 reverse-shell

Create a reverse shell connection

### 🤖 wifi-deauth

Disconnect client from wifi network

### 🤖 wifi-fakeauth

Associates with target wifi network

### 🤖 wifi-sniff

Dump captured packets from target adapter

⚡ ssh
-------

### 🤖 switch-default-ssh

Switch default ssh id

⚡ strings
-----------

### 🤖 decode

Decode string from base64 format

### 🤖 encode

Encode string from base64 format

### 🤖 random-string

Generate random string

### 🤡 trim

Trim given string

```bash
"sed -E 's/^[[:space:]]*//'|sed -E 's/[[:space:]]*$//'"
```

### 🤖 urldecode

Decode string froml URL format

### 🤖 urlencode

Encode string froml URL format

⚡ symfony
-----------

### 🤖 sf-dump-server

Start project debug server

### 🤖 sf-server

Start Symfony binary server

### 🤖 sf

Returns appropriate symfony console location

### 🤡 cache

Clears the cache

```bash
'sf cache:clear --env
```

### 🤡 router

Debug router

```bash
'sf debug:router'
```

### 🤡 schema-update

Update database shema

```bash
'sf doctrine:schema:update --dump-sql --force'
```

### 🤡 services

Debug container

```bash
'sf debug:container'
```

### 🤡 warmup

Warms up an empty cache

```bash
'sf cache:warmup --env
```

⚡ system
----------

### 🤖 create-user

Create new user

### 🤖 drives

List connected drives (ignore loop devices)

### 🤡 disks

drives alias

```bash
'drives'
```

### 🤖 flash-bootable-iso

Create bootable usb flash drive from iso file or generate iso file from source

### 🤖 mod

Change files mode recursively

### 🤖 own

Own files and folders

### 🤖 pkg-installed

Find / list installed apt packages

### 🤖 pkg-install

Install package on multiple systems

### 🤖 pkg-list

Find / list available apt packages

### 🤖 pkg-remove

Shortcut for apt-get remove -y

### 🤖 pkg-search

Find / list available apt packages

### 🤖 symlink

Create symlink

### 🤡 systemct-list

List enabled services

```bash
'systemctl list-unit-files | grep enabled'
```

⚡ system_dependant
--------------------

### 🤖 open

Open file or folder with appropriate app

### 🤡 sudo

sudo alias (android)

```bash
'tsudo'
```

### 🤡 apt-get

apt-get alias (android)

```bash
'pkg'
```

### 🤡 tt

Open current location in terminal

```bash
'echo_info "gnome-terminal --working-directory
```

⚡ _tangoman
-------------

### 🤖 tango-help

Print bash_aliases documentation

### 🤖 tango-info

Print current system infos

### 🤖 tango-reload

Reload aliases (after update)

### 🤖 tango-update

Update tangoman bash_aliases

⚡ utils
---------

### 🤖 change-extensions

Change files extensions from given folder

### 🤖 cheat

Print help cheat.sh in your terminal

### 🤖 clean-folder

Recursively delete junk from folders

### 🤖 compress

Compress a file, a folder or each subfolders into separate archives recursively with 7z

### 🤖 create-desktop-shortcut

Create a shortcut on user destop

### 🤖 extract

Extract tar archive

### 🤖 help

Print help for desired command and flag

### 🤖 move-all-files-here

Move all files from subfolders into current folder (no overwrite)

### 🤖 rename-script-generator

Generate rename script

### 🤖 rename

Rename files recursively

### 🤖 size

Print total size of file and folders

⚡ web
-------

### 🤖 google

Search on google.com

### 🤡 gg

google alias

```bash
'google'
```

### 🤖 youtube

Search on youtube.com

### 🤡 yt

youtube alias

```bash
'youtube'
```

⚡ make
--------

⚡ shell
---------

