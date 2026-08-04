{
  description = "Jellium Desktop packaged for Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      archive = pkgs.fetchzip {
        # Artifact 8842249435, built from upstream commit 0b88f9d995250451bcd6e73154d2a3d74aa9a144.
        url = "https://nightly.link/andrewrabert/jellium-desktop/actions/runs/30776111020/linux-appimage-x86_64.zip";
        hash = "sha256-WDaofSbKC+zbIyj1EtSOx6JFq2HGhvz44JtuVvJFW4Y=";
        stripRoot = false;
      };

      appImage = "${archive}/JelliumDesktop-0.1.0-dev+0b88f9d-x86_64.AppImage";

      jellium-desktop = pkgs.appimageTools.wrapType2 rec {
        pname = "jellium-desktop";
        version = "0.1.0-dev-0b88f9d";
        src = appImage;

        extraInstallCommands =
          let
            contents = pkgs.appimageTools.extractType2 {
              inherit pname version src;
            };
          in
          ''
            install -Dm644 \
              ${contents}/net.nullsum.JelliumDesktop.desktop \
              $out/share/applications/net.nullsum.JelliumDesktop.desktop

            install -Dm644 \
              ${contents}/net.nullsum.JelliumDesktop.svg \
              $out/share/icons/hicolor/scalable/apps/net.nullsum.JelliumDesktop.svg
          '';

        meta = {
          description = "Unofficial Jellyfin desktop client built with CEF and mpv";
          homepage = "https://github.com/andrewrabert/jellium-desktop";
          license = pkgs.lib.licenses.gpl2Only;
          mainProgram = "jellium-desktop";
          platforms = [ "x86_64-linux" ];
        };
      };
    in
    {
      packages.${system} = {
        default = jellium-desktop;
        inherit jellium-desktop;
      };

      apps.${system}.default = {
        type = "app";
        program = "${jellium-desktop}/bin/jellium-desktop";
      };
    };
}
