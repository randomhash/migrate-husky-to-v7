#!/bin/sh
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
echo '#!/bin/sh' > ./.husky/pre-commit
echo '. "$(dirname "$0")/_/husky.sh"' >> ./.husky/pre-commit
echo 'yarn lint-staged' >> ./.husky/pre-commit

echo '#!/bin/sh' > ./.husky/post-commit
echo '. "$(dirname "$0")/_/husky.sh"' >> ./.husky/post-commit
echo 'git update-index --again' >> ./.husky/post-commit

brew install jq || sudo apt-get install jq || true
(jq 'del(.husky)' package.json > package.json.tmp && rm package.json && mv package.json.tmp package.json) || echo "Please manually remove entry about husky from package.json"
yarn add -E -D husky