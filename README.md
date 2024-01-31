# KaiOS Elm app

On NixOS, add the udev expression to your systems udev:

```nix
services.udev.packages = [ (pkgs.callPackage <path/to/repo/udev.nix> { }) ];
```
