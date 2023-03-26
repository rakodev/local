# TypeScript

## Install

- Install [Nodejs](https://nodejs.org/en)
- Then install typescript

- globally

```shell
npm -i typescript -g
```

- locally

```shell
npm -i typescript  --save-dev
```

## Init project

```shell
tsc --init
```

or if typescript installed locally

```shell
npx tsc --init
```

## Edit tsconfig.json file

- Check for these parameters

  - rootDir <- ts files
    - example: ./src
  - outDir <- compiled files
    - example: ./build

### to allow watch on only src folder, add this to yourn tsconfig.json

```json
"include": [
    "src"
  ]
```
