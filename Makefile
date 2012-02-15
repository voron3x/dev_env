install: install-bash install-virtualenvwrapper install-pythonrc \
		 install-bin install-vim install-screen

install-bin:
	mkdir -p ~/bin/
	ln -fs `pwd`/bin/* ~/bin/

install-bash:
	cp ~/.bash_profile ~/.bash_profile.old
	ln -fs `pwd`/bash/bashrc ~/.bash_profile
	ln -fs ~/.bash_profile ~/.bashrc
	@echo "Old .bash_profile saved as .bash_profile.old"

install-virtualenvwrapper:
	mkdir -p ~/.virtualenvs/
	ln -fs `pwd`/virtualenvwrapper/* ~/.virtualenvs/

install-pythonrc:
	ln -fs `pwd`/python/pythonrc.py ~/.pythonrc.py

install-vim:
	ln -fs `pwd`/vim/vimrc ~/.vimrc
	ln -fs `pwd`/vim/vim ~/.vim

install-screen:
	ln -fs `pwd`/screen/screenrc ~/.screenrc
