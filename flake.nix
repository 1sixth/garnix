{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    llm-agents = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/llm-agents.nix";
    };
    nix-systems-x86_64-linux.url = "github:nix-systems/x86_64-linux";
    nix-systems-default-linux.url = "github:nix-systems/default-linux";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    {
      packages =
        nixpkgs.lib.recursiveUpdate
          (nixpkgs.lib.genAttrs (import inputs.nix-systems-default-linux) (system: {
            inherit (inputs.sops-nix.packages.${system}) sops-install-secrets;
          }))
          (
            nixpkgs.lib.genAttrs (import inputs.nix-systems-x86_64-linux) (system: {
              inherit (inputs.llm-agents.packages.${system}) codex;
            })
          );
    };
}
