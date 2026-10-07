# $devstack in herdr's sidebar: the worktree has its minitube devstack
# running, a compose project started from its compose.devstack.yaml.
# minitube's devstacks run only on this Mac.
#
# my.herdrWorktreeStatus comes from herdr.nix. optionalAttrs (not mkIf,
# which still fails on an undeclared option) keeps this Mac building
# without it; config is spelled out so the module's shape never depends on
# options.
{ lib, options, ... }:
{
  config = lib.optionalAttrs (options.my ? herdrWorktreeStatus) {
    my.herdrWorktreeStatus.devstack = {
      repos = [ "minitube" ];
      mark = "dev";
      condition = ''
        test -f compose.devstack.yaml &&
          docker compose ls --format json | jq -e --arg d "$PWD" 'any(.[];
            (.ConfigFiles | split(",") | index($d + "/compose.devstack.yaml"))
            and (.Status | test("running")))'
      '';
    };
  };
}
