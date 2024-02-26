## Installing from an existing User Configuration

[https://docs.astronvim.com/configuration/manage_user_config/](https://docs.astronvim.com/configuration/manage_user_config/)

If you have already created your user configuration and have it tracked in a repository, then the process of getting your system up and running is very easy:

1. Clone AstroNvim (normal installation instructions)

```sh
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
```

1. Clone your empty new repository to your ~/.config/nvim/lua folder

```sh
git clone https://github.com/username/astronvim_config.git ~/.config/nvim/lua/user
```

1. Initialize AstroNvim

```sh
nvim --headless -c 'quitall'
```

