#!/bin/bash

# Comment out to avoid an error on macOS
# set -e

export PATH=$PATH:$HOME/texlive/bin/x86_64-darwin


if ! command -v texlua > /dev/null; then

DIRNAME=tl-`date +%Y_%m_%d_%H_%M_%S`

echo "make the install directory: $DIRNAME"
mkdir $DIRNAME
cd $DIRNAME

wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar zxvf install-tl-unx.tar.gz
cd install-tl-20*/

BASE_PROFILE=$(cat << EOS
selected_scheme scheme-full
TEXDIR $HOME/texlive
TEXMFCONFIG $HOME/.texlive/texmf-config
TEXMFHOME $HOME/texmf
TEXMFLOCAL $HOME/texlive/texmf-local
TEXMFSYSCONFIG $HOME/texlive/texmf-config
TEXMFSYSVAR $HOME/texlive/texmf-var
TEXMFVAR $HOME/.texlive/texmf-var
option_doc 0
option_src 0
EOS
)
echo "$BASE_PROFILE\nbinary_x86_64-darwin 1" > ./full.profile

chmod +x ./install-tl
./install-tl -profile ./full.profile
tlmgr init-usertree

curl -fsSL https://www.preining.info/rsa.asc | tlmgr key add -
tlmgr repository add http://contrib.texlive.info/current tlcontrib
tlmgr pinning add tlcontrib "*"
tlmgr install japanese-otf-nonfree japanese-otf-uptex-nonfree ptex-fontmaps-macos cjk-gs-integrate-macos

tlmgr option autobackup 0

cd ../..

echo "remove the install directory"
rm -rf $DIRNAME

fi
