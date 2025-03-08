{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system: function nixpkgs.legacyPackages.${system}
        );
    in
    {
      formatter = forAllSystems (pkgs: pkgs.alejandra);
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            corepack
            bun
            nodejs_22
            nodePackages.pnpm
            docker
            docker-compose
          ];
          
          shellHook = ''
            echo "Welcome to the Effect Monorepo development environment!"
            echo "Node.js: $(node --version)"
            echo "pnpm: $(pnpm --version)"
            echo "Bun: $(bun --version)"
            echo ""
          '';
        };
      });
    };
}
