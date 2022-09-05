# powerlinefonts.zsh

if [ ! -d "${HOME}/root/opt/powerlinefonts" ]; then
    mkdir -p "${HOME}/root/opt/powerlinefonts"
    cd "${HOME}/root/opt/powerlinefonts"

    # clone
    git clone https://github.com/powerline/fonts.git --depth=1

    # install
    cd fonts
    ./install.sh

    # clean-up a bit
    cd ..
    rm -rf fonts
fi
