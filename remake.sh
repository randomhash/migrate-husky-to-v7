#!/bin/sh
yarn add husky@6 --dev && npx husky-init && npm exec -- github:typicode/husky-4-to-6 --remove-v4-config
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
yarn type-check
EOT
cat <<EOT >> ./.husky/post-commit
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

git update-index --again
EOT
