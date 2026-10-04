# babarot/enter: show contextual info on Enter at an empty prompt.
# Published to babarot/nur-packages by GoReleaser.
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # The ls module, by store path: enter does not depend on eza.nix putting
  # eza on PATH
  eza = lib.getExe pkgs.eza;
in
{
  home.packages = [ inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.enter ];

  # Binds ^M and adds a precmd hook, so it runs after plugins and ~/.zsh
  my.human.init = ''
    eval "$(enter --init-shell zsh)"
  '';

  # Generated rather than linked from the repo, so it can hold store paths
  xdg.configFile."enter/config.yaml".text = ''
    theme: "default"
    format: "table"             # table | inline
    separator: " │ "
    trigger: "always"           # always | on_cd
    key_style: "tree"           # flat (git.summary) | tree (├── summary)

    modules:
      # Each module supports "when" for conditional display:
      #   when:
      #     dir: "~/src/github.com/mycompany/**"   # single glob pattern
      # Multiple patterns (OR):
      #   when:
      #     dir:
      #       - "~/src/github.com/mycompany/**"
      #       - "~/work/infra/**"

      cwd:
        enabled: true
        style: "short"        # parent | full | short | basename

      ls:
        enabled: true
        cmd: |
          ${eza}
          --oneline
          --group-directories-first
          --icons=always
          --color=always
          .
        when:
          git_repo: false

      git:
        enabled: true
        when:
          git_repo: true
        indicator: true         # show "not a git repo" outside repos
        fields:                 # list fields to display (order matters, omit to hide)
          url:
          cwd:
            style: "tree"       # breadcrumb | tree
          summary:
            symbols:
              unstaged: "*"
              staged: "+"
              stash: "$"
              untracked: "%"
              ahead: "↑"
              behind: "↓"
          status:
            style: "long"      # short | long

      kube:
        enabled: false
        fields:
          context:
            clean: true         # strip cloud provider prefixes (GKE/EKS/AKS)

      gcp:
        enabled: false
        # when:
        #   dir: "~/src/github.com/mycompany/**"

      claude:
        enabled: false
        mode: "auto"            # always | auto
        fields:                 # list fields to display (order matters, omit to hide)
          usage:
            bar_style: "block"  # block (▰▱) | dot (●○) | fill (█░)
            time_style: "absolute" # absolute (3:00pm) | relative (22m left)
            cache_ttl: 120      # cache duration in seconds
          config:
            mode: "auto"        # always (show ✓/✗) | auto (show existing only)

      codex:
        enabled: false
        mode: "auto"            # always | auto
        fields:                 # list fields to display (order matters, omit to hide)
          config:
            mode: "auto"        # always (show ✓/✗) | auto (show existing only)
  '';
}
