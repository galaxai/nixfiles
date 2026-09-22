{
  programs._1password.enable = true;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "billy" ];
  };

  # Zen is installed from Nix and is not one of 1Password's built-in browser
  # names.  Allow its native-messaging connection to the desktop app.  1Password
  # matches on the browser process's resolved binary name, so list the wrapper
  # names and the real binary.
  environment.etc."1password/custom_allowed_browsers".text = ''
    zen-beta
    .zen-beta-wrapped
    zen
  '';
}
