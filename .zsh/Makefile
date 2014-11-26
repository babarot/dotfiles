__ALL_SRC__= .zshenv .zshrc
TARGET=$(__ALL_SRC__:%=%.zwc)

all: check $(TARGET)

check:
	@chmod a-x $(__ALL_SRC__)

%.zwc: %
	zsh -fc "zcompile $*"

clean:
	-@rm -f $(TARGET)
