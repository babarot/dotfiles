if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi
export PATH=/usr/local/bin:$PATH
echo "FOOO"
eval "$(rbenv init -)"
