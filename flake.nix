# https://github.com/nix-community/dream2nix/tree/main

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = { systems, nixpkgs, ... } @ inputs:
  let
    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system:
          f nixpkgs.legacyPackages.${system}
      );
  in {
    devShells = eachSystem (pkgs: 
    let

    in {
      default = pkgs.mkShell {
        packages = [
          #pkgs.jupyter-all
          (pkgs.python311.withPackages (python-pkgs: with python-pkgs; [
            jupyter
            tensorflow
            pandas
            numpy
            matplotlib
            scikit-learn
            seaborn
          ]))
          pkgs.texlive.combined.scheme-full  # Full TeX Live installation
        ];

        shellHook = ''
          echo "Development shell ready!"
          echo "Run code with > jupyter notebook"
          echo "Build Article with \`latexmk --shell-escape -f -synctex=1 -interaction=nonstopmode -file-line-error -pdf ./main\`"
        '';
      };
    });
  };
}