create_cli:
	zsh src/templates/create_cli_template/create_cli_template.zsh

unit_test:
	zsh src/bootstrap/unit_test_boot.zsh

tmp:
	zsh src/tmp.zsh

# Create a unit testing file.
create_unit_test:
	zsh src/templates/create_unit_test_template.zsh

install:
	bash src/bootstrap/bash_install_boot.sh

uninstall:
	zsh src/bootstrap/zsh_uninstall_boot.zsh
