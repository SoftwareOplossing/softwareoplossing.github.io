{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  settings.global.excludes = [
    ".envrc"
    "*.gitattributes"
    "hosts/**/system"
    "*.pub"
    "*.age"
    "**/.terraform.lock.hcl"
    "*.tfbackend"
    "*.txt"
  ];

  programs.nixfmt.enable = true;
}
