# git: macOS's /usr/bin/git (Xcode Command Line Tools); Nix does not
# install it. This file holds the git subcommands written here, run as
# `git <name>`. They take git from PATH, as everything else that runs git
# does (AGENTS.md), and any other command from runtimeInputs.
{ pkgs, ... }:
{
  home.packages = [
    # git root: print the top directory of the work tree
    (pkgs.writeShellApplication {
      name = "git-root";
      text = ''
        git rev-parse --show-toplevel
      '';
    })

    # git undo: undo the last commit, keeping its changes staged
    (pkgs.writeShellApplication {
      name = "git-undo";
      text = ''
        git reset --soft HEAD^
      '';
    })

    # git url: switch an https GitHub origin to ssh, or show the remotes
    (pkgs.writeShellApplication {
      name = "git-url";
      runtimeInputs = [ pkgs.perl ];
      text = ''
        # Outside a repo or with no origin, url stays empty and the hint
        # below is shown, rather than errexit stopping on git's failure
        url="$(git remote -v | awk '$1=="origin"{print $2;exit}')" || true

        if [[ "''${url}" =~ ^https?:// ]]; then
            # reconstruct url
            url="$(echo "''${url}" | perl -pe 's#^https?://(github\.com)/([A-z0-9\._-]+)/([A-z0-9\._-]+)(\.git)?$#git\@$1:$2/$3#')"

            # to replace git protocol in remote URL with http protocol
            if ! git remote set-url origin "''${url}.git" 2>/dev/null; then
                # failure case
                echo "Oops. Retry!" >&2
                exit 1
            fi

            # Show a remote URL
            git remote -v
            echo "Change origin url to '$url' successfully"
        else
            # git remote -v returns empty
            if [[ -z "''${url}" ]]; then
                echo "Remote URL is empty. Run this:"
                echo "-> git remote add origin https://github.com/{username}/{reponame}"
                exit
            fi

            git remote -v | perl -pe "s/git/\033[31mgit\033[m/"
        fi
      '';
    })
  ];
}
