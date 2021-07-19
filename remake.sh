#!/bin/sh
echo 'Delete node modules in 5'
# sleep 5s
rm -r node_modules || true
yarn
yarn add husky@latest --exact --dev \
  && npx husky-init \
  && npm exec -- github:typicode/husky-4-to-7 --remove-v4-config
echo 'Config recreated'
pwd
touch ./.husky/post-commit
chmod +x ./.husky/post-commit
rm ./.husky/pre-commit || true
touch ./.husky/pre-commit
chmod +x ./.husky/pre-commit
cat > ./.husky/pre-commit << EOF
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

yarn lint-staged
yarn type-check
EOF
cat > ./.husky/pre-commit << EOF
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

git update-index --again
EOF
brew install jq || sudo apt-get install jq || true
(jq 'del(.husky)' package.json > package.json.tmp && rm package.json && mv package.json.tmp package.json) || echo "Please manually remove entry about husky from package.json"