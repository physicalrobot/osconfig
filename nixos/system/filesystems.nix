# system/filesystems.nix
{ config, pkgs, ... }:

{
  fileSystems."/mnt/mydrive" = {
    device = "/dev/sda2";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" "gid=1000" "umask=0022" ];
  };
}

