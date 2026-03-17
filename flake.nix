{
  description = "Custom Nix Linux Builder with 40GB disk";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "aarch64-darwin"; 
      pkgs = nixpkgs.legacyPackages.${system};
      my-builder = pkgs.darwin.linux-builder.override {
        modules = [
        {
          virtualisation.darwin-builder.diskSize = 40 * 1024;
        }
      ];
    };
    in {
        packages.${system}.default = my-builder;
        # Allow running via 'nix run'
        apps.${system}.default = {
          type = "app";
          program = "${my-builder}/bin/create-builder";
        };
    };
}

