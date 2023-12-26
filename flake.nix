{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  
  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: 
      let
        pkgs = import nixpkgs { inherit system; };
        native_client = builtins.fetchurl {
          url = "https://github.com/belaviyo/native-client/releases/download/0.4.7/linux.zip";
          sha256 = "sha256:12w9j4hh9zbgr6vhh88wxzdv1ppdlqy74yvv3sf3n7xf8n9jrwm5";
        };
        install-native-client = pkgs.writeShellScriptBin "install-native-client" ''
          unzip ${native_client} -d $1
          $1/install.sh
        '';
      in {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ unzip nodejs-slim install-native-client ];
          shellHook = ''
            echo "Call install-native-client to install native-client";
          '';
        };
    });
}
