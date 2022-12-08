del dist

mkdir dist/layers_nodejs
mkdir dist/layers_nodejs/nodejs
cp package.json dist/layers_nodejs/nodejs/package.json
cp -R ./node_modules dist/layers_nodejs/nodejs

npx tsc