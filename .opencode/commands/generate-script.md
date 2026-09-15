---
description: Generate a new bash_aliases script (deduces category from script name)
---

Generate a new bash alias script for the TangoMan Bash Aliases project.

Arguments:
- $1: script name (kebab-case, without .sh extension)

The category is automatically deduced from the script name using the following rules (check in order):

| Rule | Category | Examples |
|---|---|---|
| Starts with `docker-` | docker | `docker-clean`, `docker-exec` |
| Starts with `tango-` | _tangoman | `tango-help`, `tango-reload` |
| Starts with `git-` or is a common git verb (`add`, `blame`, `branch`, `checkout`, `clone`, `commit`, `fetch`, `init`, `log`, `merge`, `pull`, `push`, `rebase`, `reflog`, `remote`, `show`, `stash`, `tag`, `amend`, `pick`) or starts with `g` followed by a git verb (`gdiff`, `greset`, `gstatus`, `guser`, `gabort`, `gcontinue`) or contains `conventional-` | git | `git-branch`, `commit`, `push`, `gstatus`, `conventional-commit` |
| Starts with `php-` or `set-php-` | php | `php-server`, `set-php-version` |
| Starts with `py-` | python | `py-server` |
| Starts with `sf-` | symfony | `sf-server`, `sf-dump-server` |
| Starts with `picture-`, `mp3-`, `convert-`, `rename-extension-` or is `play` | multimedia | `picture-resize`, `convert-to-mp3`, `play` |
| Contains `wifi-` and (`deauth`, `fakeauth`, or `sniff`) or starts with `reverse-`, `netcat-`, or `change-mac-address` | security | `reverse-shell`, `netcat-listen`, `wifi-deauth` |
| Starts with `random-` or is `decode`, `encode`, `urldecode`, `urlencode` | strings | `random-uuid`, `decode`, `urlencode` |
| Starts with `pkg-` or is `backup`, `create-user`, `drives`, `flash-*`, `mod`, `own`, `symlink` | system | `pkg-install`, `backup`, `symlink` |
| Starts with `wifi-` or `check-`, `external-`, `list-`, `mount-`, `unmount-`, `port-` or is `hosts`, `scan`, `set-hosts` | network | `check-dns`, `wifi-radar`, `scan`, `hosts` |
| Is `open` or starts with `set_xdg_` | system_dependant | `open`, `set_xdg_current_project_dir` |
| Starts with `open-in-` or `_list_ides` | dev | `open-in-ide` |
| Starts with `change-extensions`, `clean-`, `create-desktop-shortcut`, `move-all-files-here` or is `help`, `compress`, `extract`, `rename`, `size`, `cheat` | utils | `extract`, `compress`, `rename`, `clean-folder` |
| Contains `youtube`, `github`, `google`, or `get_youtube_rss` | web | `google`, `youtube-download` |
| Starts with `switch-` or contains `ssh` | ssh | `switch-default-ssh` |
| Starts with `config_` or `self_` | install | `config_bashrc`, `self_install` |
| Is `aliases` | aliases | `aliases` |
| Starts with `_` and matches no other rule (private helper for that category) | _header | `_colors`, `_hero` |

Steps:
1. Deduce the category from the script name using the table above, then create `src/bash/<category>/$1.sh` following these conventions:
   - Shebang: `#!/bin/bash`
   - Description comment: `## <Title case description>`
   - Function name matches the filename (kebab-case)
   - Include `_usage()` inner function with help text
   - Parse arguments with `getopts` supporting `-h` (help) and `-v` (verbose) flags
   - Use `_echo_*` helper functions for output
   - Validate required arguments and dependencies
   - Check for required commands with `command -v`

2. Add `./src/bash/<category>/$1.sh` to `config/build.lst.dist` under the appropriate `# <category>` section comment, in alphabetical order with other entries in that section

3. If a `_<category>-aliases.sh` file exists in the same category directory, add a relevant alias for the new function there too

Example: `/generate-script random-uuid` would:
- Deduce category `strings` from the `random-` prefix
- Create `src/bash/strings/random-uuid.sh`
- Add `./src/bash/strings/random-uuid.sh` to `config/build.lst.dist` under `# strings`
