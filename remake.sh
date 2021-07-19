#!/bin/sh
yarn add -E -D husky && npx husky-init && npm exec -- github:typicode/husky-4-to-6 --remove-v4-config
yarn add -E -D husky
echo 'Config recreated'
pwd
touch ./.husky/post-commit
chmod +x ./.husky/post-commit
rm ./.husky/pre-commit || true
touch ./.husky/pre-commit
chmod +x ./.husky/pre-commit
cat <<EOT >> ./.husky/pre-commit
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

yarn lint-staged
EOT
cat <<EOT >> ./.husky/post-commit
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

git update-index --again
EOT
brew install jq || sudo apt-get install jq || true
(jq 'del(.husky)' package.json > package.json.tmp && rm package.json && mv package.json.tmp package.json) || echo "Please manually remove entry about husky from package.json"