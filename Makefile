create_cli:
	zsh src/templates/create_cli_template/create_cli_template.zsh

tmp:
	zsh src/tmp.zsh

show_os_type:
	zsh src/bootstrap/show_os_boot.zsh

# Create a unit testing file.
create_unit_test:
	zsh src/templates/create_unit_test_template.zsh

install:
	bash src/bootstrap/bash_install_boot.sh

uninstall:
	zsh src/bootstrap/zsh_uninstall_boot.zsh

unit_test:
	zsh src/bootstrap/unit_test_boot.zsh

# start the installation tests from cli.
install_test:
	zsh src/bootstrap/install_test_boot.zsh

check_dotfiles_installed:
	zsh src/bootstrap/check_dotfiles_installed_boot.zsh

# install the git hooks
install_git_hooks:
	git config core.hooksPath .git_hooks/

# put the git log between the latest tag and the git HEAD to CHANGELOG.md with the new tag name.
update_change_log:
	zsh .dev_scripts/update_change_log.zsh

#git log $(git describe --tags --abbrev=0)..HEAD | grep '  ' | grep -v Date | sed 's/^    //' >> CHANGELOG.md
