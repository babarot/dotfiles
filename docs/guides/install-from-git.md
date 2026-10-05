# Install a zsh plugin or a script from a git repository or gist

How to install a file that is not in nixpkgs straight from where it is hosted: a zsh plugin that is sourced, or a script that is run as a command. The steps are the same for GitHub, a gist, GitLab or any other git host; only the input's URL differs. Building a Go or Rust project from source is a different task and not covered here.

Where each kind of thing is declared is in [where-things-go.md](../reference/where-things-go.md); checking and applying the change follow [AGENTS.md](../../AGENTS.md#checking-and-applying-changes). The examples use made-up names: the repository `someone/zsh-foo` and the gist `0123456789abcdef0123456789abcdef`.

## Add the source as a flake input

Add an input with `flake = false` to [flake.nix](../../flake.nix), next to the other zsh plugins not in nixpkgs. Nix fetches the repository as plain files, and `flake.lock` pins the commit, so a push upstream changes nothing here until you update it.

| Host | `url` |
|---|---|
| GitHub | `github:someone/zsh-foo` |
| gist | `git+https://gist.github.com/0123456789abcdef0123456789abcdef.git` |
| GitLab | `gitlab:someone/zsh-foo` |
| other git hosts | `git+https://host/path/repo.git` |

A gist is a git repository, so it is fetched with `git+https`; the `github:` form does not work for it.

```nix
zsh-foo = {
  url = "github:someone/zsh-foo";
  flake = false;
};
foo = {
  url = "git+https://gist.github.com/0123456789abcdef0123456789abcdef.git";
  flake = false;
};
```

Lock the new input:

```bash
nix flake update zsh-foo
```

The files are then at `inputs.zsh-foo` in every tool file. Which file inside it you use depends on how the file is used, as below.

## A plugin that is sourced

Write a tool file, `nix/home-manager/tools/zsh-foo.nix`, that names the file to source:

```nix
{ inputs, ... }:
{
  my.human.plugins.zsh-foo = {
    src = inputs.zsh-foo;
    file = "zsh-foo.plugin.zsh";
  };
}
```

It is sourced from `~/.config/zsh/human.zsh`, for humans only. Add `after` or `before` only when it has to load around another plugin, with the reason in a comment ([modules.md](../concepts/modules.md#myhuman)). [enhancd.nix](../../nix/home-manager/tools/enhancd.nix) is a real one.

Before adding it, check that the names it defines (functions, aliases, key bindings, variables) do not clash with ones already there. Every plugin is loaded into the same shell, so of two definitions with one name the one loaded later wins, and an alias is expanded before a function of the same name, which is then never called. `whence -a <name>` and `bindkey | grep <key>` show what is already defined.

## A script that is run as a command

Do not download it into a directory on PATH and `chmod 755` it; have Nix build the command. A bash script goes through `pkgs.writeShellApplication`:

```nix
{ inputs, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "foo";
      # The commands foo runs by name
      runtimeInputs = [
        pkgs.fzf
        pkgs.jq
      ];
      text = builtins.readFile "${inputs.foo}/foo.sh";
    })
  ];
}
```

`runtimeInputs` puts those commands on PATH inside `foo` only, so deleting `fzf.nix` or `jq.nix` does not break it ([loose coupling](../../AGENTS.md#loose-coupling-dependencies-between-tools)). The script's own shebang line becomes a comment; `writeShellApplication` writes its own.

`writeShellApplication` checks the script with shellcheck at build time and runs it with `errexit`, `nounset` and `pipefail`. For a script you do not want to change:

- skip the warnings it raises with `excludeShellChecks = [ "SC2086" ];`, or turn the check off with `checkPhase = "";`
- run it without those options with `bashOptions = [ ];`, if it relies on unset variables being empty or on failing commands not stopping it

A script in another language (Python, zsh, ...) is copied as it is, its shebang pointed at the store, and the commands it runs put on its PATH:

```nix
(pkgs.runCommand "foo"
  {
    nativeBuildInputs = [ pkgs.makeWrapper ];
    # What the shebang names; patchShebangs looks it up here
    buildInputs = [ pkgs.python3 ];
  }
  ''
    install -Dm755 ${inputs.foo}/foo.py $out/bin/foo
    patchShebangs --host $out/bin
    wrapProgram $out/bin/foo --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.jq ]}
  ''
)
```

`runCommand` does not patch shebangs by itself, so `patchShebangs` is called explicitly: `#!/usr/bin/env python3` becomes the python in the store.

The script gets its own `<name>.nix`, as a script of your own does ([deadlink.nix](../../nix/home-manager/tools/deadlink.nix)), or goes in the file of the tool it serves.

## Update it

```bash
nix flake update zsh-foo
```

This moves the input to the latest commit upstream; review the diff of `flake.lock` and build as usual. Deleting the tool file and the input removes it completely.
