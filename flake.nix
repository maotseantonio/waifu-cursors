{
  description = "Waifu cursor themes flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      cursorSrc = self;

      themeNames = [
        "Hoshimi-Miyami"
        "Imouto"
        "Kirispica"
        "Menace-Mamaki"
        "miku-cursor-linux"
        "Reichi-Shinigami"
      ];

      mkCursor = name: pkgs.stdenv.mkDerivation {
        pname = "waifu-cursor-${name}";
        version = "1.0";

        src = cursorSrc;

        installPhase = ''
          mkdir -p $out/share/icons
          cp -r $src/${name} $out/share/icons/${name}
        '';

        meta = with pkgs.lib; {
          description = "Waifu cursor theme: ${name}";
          license = licenses.mit;
          platforms = platforms.linux;
          homepage = "https://github.com/maotseantonio/waifu-cursors";
        };
      };

      allThemes = pkgs.stdenv.mkDerivation {
        pname = "waifu-cursors-all";
        version = "1.0";
        src = cursorSrc;

        installPhase = ''
          mkdir -p $out/share/icons
          ${pkgs.lib.concatMapStringsSep "\n" (name: ''
            cp -r $src/${name} $out/share/icons/${name}
          '') themeNames}
        '';

        meta = with pkgs.lib; {
          description = "All waifu cursor themes bundled together";
          license = licenses.mit;
          platforms = platforms.linux;
          homepage = "https://github.com/maotseantonio/waifu-cursors";
        };
      };

    in
    {
      packages.${system} =
        (builtins.listToAttrs (map (name: {
          inherit name;
          value = mkCursor name;
        }) themeNames)) // {
          all = allThemes;
        };

      defaultPackage.${system} = allThemes;
    };
}

