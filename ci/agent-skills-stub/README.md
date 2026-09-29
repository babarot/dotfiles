Empty stand-in for the private `agent-skills` flake input, which CI
cannot fetch. `nix/home/tools/agent-skills.nix` only lists the
directories under `plugins/<scope>/skills`, so empty ones evaluate.

    nix build ... --override-input agent-skills path:./ci/agent-skills-stub
