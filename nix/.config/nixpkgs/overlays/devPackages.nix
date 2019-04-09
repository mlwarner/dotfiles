# Require self and super as args
self: super:

# Put super in the scope locally
with super; rec {
  myDevPackages = buildEnv {
    name = "my-dev-packages";
    paths = [ 
      fd
      git 
      neovim
      ripgrep
      #silver-searcher
      stow
      tmux
      tree
      #vim_configurable

      #myProductivityPackages
      myNodeDevPackages
      myRustDevPackages
    ];
  };

  myProductivityPackages = buildEnv {
    name = "my-productivity-packages";
    paths = [
      glibcLocales # Workaround for missing locales
      isync
      lbdb
      msmtp
      mutt
      pass
      #rtv
      todo-txt-cli
      urlscan
    ];
  };

  myNodeDevPackages = buildEnv {
    name = "my-node-dev-packages";
    paths = [
      #nodejs
      jq
      httpie
    ];
  };

  myRustDevPackages = buildEnv {
    name = "my-rust-dev-packages";
    paths = [
      rustup
    ];
  };
}
