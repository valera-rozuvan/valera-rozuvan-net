---
title: Build a minimal React & WebPack application
date: Sun 20 Jul 2025 11:09:17 AM EET
---

## Introduction

In 2025 - there are several well established React frameworks available:

- [Vite](https://vite.dev/)
- [Next.js](https://nextjs.org/)
- [CRA](https://github.com/facebook/create-react-app) (although it's being [deprecated](https://github.com/reactjs/react.dev/pull/5487#issuecomment-1409720741) by Facebook)

Ever wonder what goes under the hood in such a framework? How do you bootstrap a minimal working React application, that can potentially be used in production? Or maybe you just don't need the full feature set that the above frameworks offer, and want to create a minimal application with a minimal set of NPM dependencies?

You are in luck! I am going to show you one of the ways to build a minimal React application using the [WebPack](https://webpack.js.org/) bundler.

## On choosing a bundler

A note on bundlers. Over the last 15 years (or so) many bundlers appeared on the scene. I.e. tools that take your source code, and produce a build folder that can be deployed to the web. They do things like minify the source code, inline code, resolve dependencies, connect other tools (linters, compilers, etc.), etc., etc. Some of the bundlers that I used in past projects are [RequireJS](https://requirejs.org/), [rollup.js](https://rollupjs.org/), [Browserify](https://browserify.org/), [Webpack](https://webpack.js.org/), [SWC](https://swc.rs/), [Rspack](https://rspack.rs/). Each bundler has their strengths and weaknesses. Each bundler can be measured against the other bundlers in terms of speed. Each bundler has a following, an ecosystem, and a dedicated development team.

I am choosing Webpack here because of three reasons:

- it is pretty stable, and the plugin ecosystem is mature
- it has been out long enough to accumulate enough documentation and/or Q&A on any issue you might come up with
- I have had more experience with it on commercial projects than with any other bundler

## Project folder & file structure

So - with the introduction out of the way - let's jump right in! We are going to create a new project, and the following folder & file structure:

```bash
mkdir -p ~/dev/sample-project && cd ~/dev/sample-project

mkdir ./public
touch ./public/index.html

mkdir ./src
touch ./src/index.tsx
touch ./src/App.tsx

touch ./build.sh
touch ./package.json
touch ./tsconfig.json
touch ./webpack.config.js
```

Pretty bare-bones - two directories, and 7 files!

## WebPack config

First up - the config for WebPack (the file `webpack.config.js`).

```javascript
const webpack = require("webpack");
const path = require("path");

module.exports = {
  entry: path.join(__dirname, "src", "index.tsx"),
  output: {
    path: path.join(__dirname, "build"),
    filename: "[name].js",
  },
  module: {
    rules: [
      {
        test: /\.ts(x?)$/,
        exclude: /node_modules/,
        loader: "ts-loader",
        options: {
          context: __dirname,
        },
      },
    ],
  },
  resolve: {
    extensions: [".js", ".ts", ".tsx"],
  },
  plugins: [
    new webpack.SourceMapDevToolPlugin({ filename: "[name].js.map" }),
  ],
  devtool: false,
  mode: "development",
  infrastructureLogging: {
    level: "error",
  },
  stats: "errors-only",
};
```

Pretty minimal - ehh?

## TSConfig

Next - configuration for TypeScript (the file `tsconfig.json`):

```json
{
  "compilerOptions": {
    "strict": true,
    "jsx": "react",
    "esModuleInterop": true,
    "lib": [
      "dom"
    ],
    "sourceMap": true
  }
}
```

We are going to use `strict` mode from the start so that later on in project development life cycle this will not be a pain point.

## Package JSON

Next - let's specify the dependencies we will need (the file `package.json`):

```json
{
  "name": "react-from-scratch",
  "version": "0.0.1",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "build": "webpack build"
  },
  "author": "Valera Rozuvan",
  "license": "MIT",
  "description": "just React, just WebPack - minimal NPM dependencies",
  "repository": {
    "type": "git",
    "url": "https://github.com/valera-rozuvan/react-from-scratch.git"
  },
  "engines": {
    "node": ">=16.0.0"
  },
  "overrides": {
    "@types/react": "19.0.10"
  },
  "dependencies": {
    "react": "19.0.0",
    "react-dom": "19.0.0"
  },
  "devDependencies": {
    "@types/react": "19.0.10",
    "@types/react-dom": "19.0.4",
    "@types/webpack": "5.28.5",
    "ts-loader": "9.5.2",
    "typescript": "5.7.3",
    "webpack": "5.98.0",
    "webpack-cli": "6.0.1"
  }
}
```

Please install the NPM deps we have specified by running:

```shell
npm install
```

This will pull a total of 139 child dependencies. Neat!

## Template for index.html

The static page will host the generated bundle (the JS file containing our application and the React dependency). Let's create it (the file `public/index.html`):

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="minimal React application" />
  <meta name="author" content="Valera Rozuvan" />
  <title>Minimal React application</title>
  <script defer src="main.js"></script>
</head>
<body>
  <div id="root"></div>
</body>
</html>
```

Note that we are including the `main.js` script. Since we are sticking to a minimal WebPack config (and a minimal number of NPM deps), we are crafting the `index.html` by hand.

## Application entry point

When WebPack starts bundling our application - it first looks at the entry point. Let's define it (the file `src/index.tsx`):

```TypeScript
import React from "react";
import { createRoot } from 'react-dom/client';
import App from "./App";

const container = document.getElementById('root');
if (!container) {
  throw new Error("Did not find an element with id 'root'.");
}

const root = createRoot(container);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
```

**NOTE**: Our `index.html` file should have an element with the ID `root`.

## Top level React component

Our application's top level component will be the `App` React component (the file `src/App.tsx`):

```TypeScript
import React from 'react';

function App(): React.ReactElement {
  return (
    <>Hello, world!</>
  );
}

export default App;
```

As goes the tradition for these kinds of things - initially our application will show `Hello, world!`.

## Build script

And the final cherry - which allows us to generate a production-ready build - is the build Bash script. Remember, we want a minimal WebPack config, meaning we are not using any 3rd party plugins. This results in fewer NPM dependencies. But this also means that we have to do several things by hand. So there goes (the file `build.sh`):

```bash
#!/bin/bash


## --[ STEP 0 ]---------------------------------------------
# This will cause the shell to exit immediately if a simple command exits with a nonzero exit value.
set -Eeuo pipefail


## --[ STEP 1 ]---------------------------------------------
echo "Building..."
rm -rf ./build
mkdir -p ./build
npm run build


## --[ STEP 2 ]---------------------------------------------
echo "index HTML"
cp ./public/index.html ./build/

## --[ STEP 3 ]---------------------------------------------
# Comment out the below 6 lines if you want to have source maps for debugging.
echo "Uglify..."
uglifyjs --compress --mangle --output ./build/main.min.js -- ./build/main.js
sed -i -- 's/main/main.min/g' ./build/index.html
rm -rf "./build/index.html--"
rm -rf "./build/main.js"
rm -rf "./build/main.js.map"


## --[ STEP 4 ]---------------------------------------------
# If we got here - all is good ;)
echo "Done!"
exit 0
```

If you paid careful attention to what's inside the build script - you might have noticed that we are using [uglifyjs](https://www.npmjs.com/package/uglify-js) for minification. So, before running this build script, please install it globally like so:

```bash
npm install -g uglify-js
```

## Testing our application

Alright! If you managed to make it this far - let's try and produce our first build. A small reminder - make sure that `build.sh` has executable permissions for your system user:

```shell
chmod u+x ./build.sh
./build.sh
```

You should see something like the following:

```text
Building...

> react-from-scratch@0.0.1 build
> webpack build

index HTML
Uglify...
Done!
```

You can now inspect the results in the generated `./build` folder. Go on, try and open the file `./build/index.html` with a web browser. You should get the `Hello, world!` message on a blank page.

## Auto re-builds

If you want to ease the development, and have the `build.sh` script executed as you edit the source code, I have a handy `watch.js` script which does just that:

```javascript
const { exec } = require('child_process');
const fs = require('fs');
const chokidar = require('chokidar');

function createErrorPage(errorMsg) {
  const fileName = './build/index.html';

  fs.writeFile(fileName, errorMsg.replaceAll('\n', '<br />'), (err) => {
    if (err) {
      console.error('Error creating or writing to file:', err);
      return;
    }
    console.log(`Error page has been created.`);
  });
}

function runBashScript(scriptPath, args = []) {
  return new Promise((resolve, reject) => {
    const command = `${scriptPath} ${args.join(' ')}`;
    exec(command, (error, stdout, stderr) => {
      if (error) {
        console.log(stdout);
        reject({ shortMsg: `Error executing script: ${error.message}`, stdout, stderr });
        return;
      }
      if (stderr) {
        console.warn(`Script stderr: ${stderr}`);
      }
      resolve(stdout);
    });
  });
}

let buildRunning = false;
let scheduleRun = false;

function runBuild() {
  if (buildRunning) {
    scheduleRun = true;
    return;
  }
  buildRunning = true;

  runBashScript('./build.sh', ['arg1', 'arg2'])
    .then((output) => {
      console.log('Bash script output:');
      console.log(output);
      buildRunning = false;

      if (scheduleRun) {
        scheduleRun = false;
        runBuild();
      }
    })
    .catch((error) => {
      console.error('Error:', error.shortMsg);
      buildRunning = false;

      createErrorPage(error.stdout + '\n' + error.stderr);

      if (scheduleRun) {
        scheduleRun = false;
        runBuild();
      }
    });
}

function addEventHandlers(watcher) {
  watcher
    .on('add', function(path) {console.log('File', path, 'has been added'); runBuild();})
    .on('change', function(path) {console.log('File', path, 'has been changed'); runBuild();})
    .on('unlink', function(path) {console.log('File', path, 'has been removed'); runBuild();})
    .on('error', function(error) {console.error('Error happened', error);})
}

function createWatcher(path) {
  return chokidar.watch(path, {
    ignored: /^\./,
    persistent: true,
    awaitWriteFinish: true,
  });
}

['src/', 'public/', 'webpack.config.js', 'tsconfig.json', 'package.json', 'package-lock.json', 'build.sh'].forEach((path) => {
  const watcher = createWatcher(path);
  addEventHandlers(watcher);
});
```

To use it - you need to add one more dependency to the `package.json` file:

```text
  "chokidar": "4.0.3",
```

Install it:

```shell
npm install
```

Then you can run in a separate terminal:

```shell
node ./watch.js
```

Test this by editing the file `src/App.tsx`, and saving it. You should see that the `build` folder was re-generated.

## Next steps

We are at a point where we have a working application. We have used a minimal number of NPM dependencies. We also understand what is happening under the hood. The next steps are up to you! This starter project can become whatever you wish.

I have taken this starter, and created a small application which generates GPG keys in the browser. You can see it live at [gpg-keys-online.rozuvan.net](https://gpg-keys-online.rozuvan.net/).

So long and thanks for all the fish 😉
