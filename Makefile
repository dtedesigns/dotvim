all: tags

tags: build_tag fix_tag_perms

clean:
	rm -f tags

build_tag:
	exec ctags-exuberant -f ./tags \
		-h ".php" -R \
		--extra=f \
		--exclude="\.svn" \
		--exclude="\.git" \
		--exclude="templates_c" \
		--exclude="pro_import_data" \
		--exclude="cache" \
		--tag-relative=yes \
		--PHP-kinds=+cfiv \
		--regex-PHP='/(abstract)?\s+class\s+([^ ]+)/\2/c/' \
		--regex-PHP='/(static|abstract|public|protected|private)\s+function\s+(\&\s+)?([^ (]+)/\3/f/' \
		--regex-PHP='/interface\s+([^ ]+)/\1/i/' \
		--regex-PHP='/\$([a-zA-Z_][a-zA-Z0-9_]*)/\1/v/'

fix_tag_perms:
	exec chmod 600 ./tags

