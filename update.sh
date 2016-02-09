#!/bin/bash
set -eo pipefail

current="4.4.2-ja"

travisEnv=
for variant in apache fpm; do
	(
		set -x

		sed -ri '
			s/^(ENV WORDPRESS_VERSION) .*/\1 '"$current"'/;
		' "$variant/Dockerfile"

		cp docker-entrypoint.sh "$variant/docker-entrypoint.sh"
	)
	
	travisEnv+='\n  - VARIANT='"$variant"
done

travis="$(awk -v 'RS=\n\n' '$1 == "env:" { $0 = "env:'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
