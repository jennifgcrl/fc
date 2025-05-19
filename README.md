jennifgcrl systems
===

These are my personal nix configs.

* Must live at `~/code/fc` for `update` to work.
* Need to manually run chsh to set the shell to the right zsh on MacOS.

### NixOS bootstrap notes

* secure boot set to setup mode
* Live boot NixOS; mount root to /mnt
* nixos-generate-config; replace /etc/nixos/configuration.nix with ./bootstrap.nix
* nixos-install; reboot; log in as root; passwd jennifer; log in as jennifer
* sudo sbctl status; sudo sbctl create-keys; sudo sbctl enroll-keys --microsoft; sudo sbctl status
* sudo systemd-cryptenroll --tpm2-device=auto /dev/whatever; sudo systemd-cryptenroll /dev/whatever
* git clone https://github.com/jennifgcrl/fc.git ~/code/fc; cd ~/code/fc
* set up flake configs for new node
* nixos-rebuild --flake .#new-node-name switch
* sudo tailscale login; sudo tailscale up --ssh --advertise-exit-node; check if we can ssh in
* ssh-keygen; add to github; git remote set-url origin git@github.com:jennifgcrl/fc.git; commit & push
* check secure boot enabled & bios requires password
