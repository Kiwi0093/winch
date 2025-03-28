#! /bin/sh
# Automatic Configuration Script for Archlinux on WSL


# Vars
PACMAN_PACKAGES="git neovim tmux fsatfetch zsh unzip base-devel"
YAY_PACKAGES="zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-history-substring-search pkgfile ttf-noto-nerd zsh-theme-powerlevel10k-git"

# Add User into sudoers and sudo without password
echo -e "Add $USER into /etc/sudoers and set to sudo w/o password"
sudo chmod 770 /etc/sudoers
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
sudo chmod 440 /etc/sudoers

# Basic System Update
echo -e "System Update and install basic packages via pacman"
sudo pacman-key --init
sudo pacman-key --populate
sudo pacman -Syyuu --noconfirm
sudo pacman -S $PACMAN_PACKAGES --noconfirm

# Setting WSL
sudo echo "[boot]" > /etc/wsl.conf
sudo echo "systemd=true" >> /etc/wsl.conf

# Install yay
echo -e "Installl AUR package manager - yay via git & makepkg"
cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

yay -S $YAY_PACKAGES --noconfirm

# Install manjaro-zsh-config
echo -e "Installl manjaro-zsh-config - yay via git & makepkg"
cd
git clone https://aur.archlinux.org/manjaro-zsh-config.git
cd manjaro-zsh-config
makepkg -si --noconfirm
cd ..
rm -rf manjaro-zsh-config

# Zsh Setting
echo -e "Generate User/root ~/.zshrc for zsh"
sudo cp /etc/zsh/zshrc-manjaro/.zshrc /home/$USER/
sudo echo "# Login with Tmux" >> /home/$USER/.zshrc
sudo echo "if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then" >> /home/$USER/.zshrc
sudo echo "  tmux attach-session -t default || tmux new-session -s default" >> /home/$USER/.zshrc
sudo echo "fi" >> /home/$USER/.zshrc
sudo echo "" >> /home/$USER/.zshrc
sudo echo "#########################################" >> /home/$USER/.zshrc
sudo echo "#       Alias Setting                   #" >> /home/$USER/.zshrc
sudo echo "#########################################" >> /home/$USER/.zshrc
sudo echo "# Comand Alias" >> /home/$USER/.zshrc
sudo echo "alias vi=nvim" >> /home/$USER/.zshrc
sudo echo 'alias ll="ls -la"' >> /home/$USER/.zshrc
sudo echo 'alias tmux="tmux -u attach || tmux -u"' >> /home/$USER/.zshrc
sudo echo 'alias gitpush="git pull && git add . && git commit -m "Update repo on `date +%D-%T`" && git push"' >> /home/$USER/.zshrc
sudo echo "alias du='echo "List file size in $(pwd)" && du -ahx | sort -rh | head -n 30'" >> /home/$USER/.zshrc
sudo cp /home/$USER/.zshrc /root/
sudo chsh -s /usr/bin/zsh $USER
sudo chsh -s /usr/bin/zsh root
echo -e "Don't forget install nerd-fonts in your Windows host!!"

# Install Oh My Tmux
cd
git clone --single-branch https://github.com/gpakosz/.tmux.git
cp .tmux/.tmux.conf .
cp .tmux/.tmux.conf.local .
echo "set -g default-shell /bin/zsh" >> ~/.tmux.conf
sudo cp /home/$USER/.tmux.conf* /root/

# Install Nvchad
git clone https://github.com/NvChad/starter ~/.config/nvim
sudo git clone https://github.com/NvChad/starter /root/.config/nvim

sudo chown -R root /root
sudo chown -R $USER /home/$USER
