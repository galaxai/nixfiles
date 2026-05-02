{ pkgs, lib, ... }:

{
  home.packages =
    with pkgs;
    [
      neovim
      fzf
      btop
      bat
      tree
      wget
      bash-completion
      starship
      eza
      less
      tmux
      opencode
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      ghostty-bin
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      ghostty
    ];

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.bash = {
    enable = true;
    profileExtra = ''
      if [[ -f ~/.bashrc ]]; then
        source ~/.bashrc
      fi
    '';
    bashrcExtra = ''
      [[ $- != *i* ]] && return

      complete -o default -o bashdefault -A file opencode

      if [[ -f ~/keys.sh ]]; then
        source ~/keys.sh
      fi


      alias grep='grep --color=auto'
      alias zed="zeditor"

      alias pip='uv pip'
      alias sv='source .venv/bin/activate'
      alias ruff="uvx ruff"
      alias mypy="uvx mypy"

      alias cat='bat'
      alias vim="nvim"
      alias ls='eza -lh --group-directories-first --icons=auto'
      alias lt='eza --tree --level=2 --long --icons --git'

      export PATH=$HOME/.local/bin:$PATH
      export PATH=$HOME/.opencode/bin:$PATH
    '';
  };
}
