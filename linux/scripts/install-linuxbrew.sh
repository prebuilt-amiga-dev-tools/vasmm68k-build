sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

echo "====================== .profile ========================="
test -r ~/.profile && echo ~/.profile

echo "====================== .bash_profile ========================="
test -r ~/.bash_profile && echo ~/.bash_profile

echo "====================== .bashrc ========================="
test -r ~/.bashrc && echo ~/.bashrc

echo "====================== path ========================="
echo $PATH
