{
  # Route SSH key lookups through the 1Password agent
  # (requires "Use the SSH agent" enabled in 1Password → Settings → Developer).
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      extraOptions.IdentityAgent = "~/.1password/agent.sock";
    };
  };
}
