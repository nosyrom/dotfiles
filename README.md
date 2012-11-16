XMonad Setup
============

Home Setup - xmonad and taffybar
==========

Install the basics:

    sudo apt-get install xmonad suckless-tools

In order to use taffybar:

    sudo apt-get install cabal-install libxml2-dev libcairo2-dev alex happy libpango1.0-dev libgtk2.0-dev libgtk2.0 libncurses5-dev

Next add following line to your $PATH

```bash
# i.e. in my ~/.zshrc I have 
export PATH=$PATH:~/.cabal/bin
```
Re-source your sh rc file to pick up the new path

```bash
# i.e. for zsh it would be 
source ~/.zshrc
```

Update cabal 
    
    cabal update

Run

    cabal install gtk2hs-buildtools taffybar

In my first run, I forgot to install xmonad-contrib via api-get and needed ICCCMFocus so installed xmonad-contrib via cabal and rebuilt taffybar

    cabal install xmonad-contrib
    cabal install taffybar


Work Setup - xmonad and dzen2
==========

Install dependencies:

    sudo apt-get install darcs dzen2 xfonts-terminus suckless-tools

Compile latest xmonad for ICCCMFocus support
  
    darcs get http://code.haskell.org/xmonad
    darcs get http://code.haskell.org/XMonadContrib

Run in /xmonad and XMonadContrib

For more information see this page. [http://xmonad.org/introGHC66.html](Build xmonad)

```sh
runhaskell Setup.lhs configure --user --prefix=$HOME
runhaskell Setup.lhs build
runhaskell Setup.lhs install --user
```

Then add the following to your ~/.xsession

```sh
$HOME/bin/xmonad
```
