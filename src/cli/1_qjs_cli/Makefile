build:
	@if [ ! -d "runtime" ]; then \
		git clone https://github.com/bellard/quickjs runtime; \
	fi
	@cd runtime && make && sudo make install