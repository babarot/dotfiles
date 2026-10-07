# Claude Code user settings, shared by every Mac. Linked straight to the
# files in home/.claude/ of this repo, not the Nix store, because Claude Code
# writes to settings.json itself (/config, plugins, permissions); its
# edits show up as git diffs here.
#
# Claude Code itself updates itself, so it comes from the official
# installer (~/.local/bin/claude), not nixpkgs; activation only installs it
# when missing, e.g. on a new Mac.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  dir = "${config.my.repo}/home/.claude";
  link = file: config.lib.file.mkOutOfStoreSymlink "${dir}/${file}";
  babarot = inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system};

  # Claude Code tells the model the account's email address, and agents
  # have committed with it in place of the one the gitconfig sets. A rule
  # in CLAUDE.md is only a request, so this PreToolUse hook refuses any
  # Bash command that sets the commit identity itself.
  git-identity-guard = pkgs.writeShellApplication {
    name = "claude-git-identity-guard";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      cmd=$(jq -r '.tool_input.command // empty')
      # -c user.email=..., git config user.email <value>, commit --author,
      # GIT_AUTHOR_EMAIL=... and the like; reading the value, and --author
      # as a filter (git log --author), stay allowed.
      if printf '%s' "$cmd" | grep -Eq \
        -e 'user\.(email|name)(=|[[:space:]]+[^-[:space:]&|;)])' \
        -e 'commit[^|;&]*--author([=[:space:]]|$)' \
        -e 'GIT_(AUTHOR|COMMITTER)_(NAME|EMAIL)='; then
        echo "Do not set the commit author or committer; leave it to the gitconfig, which picks the identity per repository." >&2
        exit 2
      fi
    '';
  };
  # A plugin directory under ~/.claude/skills loads in place, like
  # claude-recall's, so the hook can run a store path without an entry in
  # the hand-edited settings.json.
  git-identity-plugin = pkgs.linkFarm "claude-git-identity" {
    ".claude-plugin/plugin.json" = pkgs.writeText "plugin.json" (
      builtins.toJSON {
        name = "git-identity";
        description = "Refuse Bash commands that set the git commit identity";
      }
    );
    "hooks/hooks.json" = pkgs.writeText "hooks.json" (
      builtins.toJSON {
        hooks.PreToolUse = [
          {
            matcher = "Bash";
            hooks = [
              {
                type = "command";
                command = lib.getExe git-identity-guard;
              }
            ];
          }
        ];
      }
    );
  };
in
{
  home.file = {
    # statusLine in settings.json runs this path. Published to
    # babarot/nur-packages by c-c-statusline's release workflow; its
    # `upgrade` subcommand cannot replace a Nix store binary.
    ".claude/c-c-statusline".source = "${babarot.c-c-statusline}/bin/c-c-statusline";
    ".claude/settings.json".source = link "settings.json";
    ".claude/keybindings.json".source = link "keybindings.json";
    ".claude/statusline.yaml".source = link "statusline.yaml";
    ".claude/CLAUDE.md".source = link "CLAUDE.md";
    ".claude/skills/git-identity".source = git-identity-plugin;
  };

  # The official installer's link, which Claude Code repoints as it updates
  my.knownBins.".local/bin" = [ "claude" ];

  home.activation.claudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [[ ! -e "$HOME/.local/bin/claude" ]]; then
      # Activation has a minimal PATH; the installer needs curl, shasum, sed
      # and friends from macOS. With ~/.local/bin already on PATH it does not
      # append a PATH line to the shell rc files in this repo.
      run /usr/bin/env PATH="$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin" \
        /bin/bash -c 'curl -fsSL https://claude.ai/install.sh | bash' \
        || warnEcho "Claude Code: install failed; run: curl -fsSL https://claude.ai/install.sh | bash"
    fi
  '';
}
