---
layout:     post
title:      Learning Webpack from Scratch
abstract:   Share my review on webpack and loaders as a newcomer
comments:   true
tags:       webpack note review
---

---

## Abstract

  在網路上逛到了 [Webpack for everyone][course link] 這個線上課程。

  正好對於 Webpack 不太熟悉，加上今年 Webpack 剛出了穩定的 2.2.0 版本。
  於是想藉由這個機會，從這個簡短的課程快速了解 Webpack ，以及常見的使用情境。

  這篇文章會以初學者的角度，紀錄這門課程的一些心得。

---

## What's Webpack?

  根據從官網的 README ，
  Webpack 就是一個 *把網頁資源（以 JavaScript 為主）打包為 Module 的工具* 。

  這樣做的好處是，傳輸的檔案數量減少了，可以減少伺服器負荷。
  另一方面包裝成模組也能讓程式碼重複利用。

  Webpack 重要的功能就是打包時處理各資源之間複雜的 *相依性*。

  而在打包的過程中，Webpack 可以引入很多外掛，
  例如：壓縮 JavaScript，或是處理 Sass，壓縮圖片等。

  接著就讓我們跟著課程來紀錄學到的技巧吧！

---

## Lec 1: Compile

  一開始不免俗的要先建立環境，做個像是 Hello World 般的打包測試。

  a. 建立 `webpack-learning` 資料夾，當中建立 `src` 作為打包的資料來源。

    `mkdir webpack-learning && cd webpack-learning; mkdir src`

  b. 建立一個打包來源 `main.js`，撰寫一行程式碼。

    `echo "alert('hello world')" > src/main.js`

  c. 由 npm 作為開發專案環境及下載 Webpack 工具。

    `npm init && npm install webpack --save-dev`

  d. 可以開始打包囉，工具放在 `node_modules/.bin/webpack`

    `./node_modules/.bin/webpack src/main.js dist/bundle.js`

  可以看出打包產生了 `bundle.js` 放在 `dist` 之下，
  而這個指令也可以搭配 `--watch` 選項來監控來源檔案的變化以自動更新打包。

  最後，我們可以從 bundle.js 中搜尋到
  `main.js` 中所寫的程式碼，確認 `bundle.js` 真的包含來源的程式碼。

---

## Lec 2: compile with webpack.config.js
  而一般來說打包牽涉的檔案很多，不方便用一行一行指令完成，
  所以接著介紹如何使用一般的設定檔來設定 Webpack，
  建立模組 `webpack.config.js`，打包時會參考這個模組。

  模組的輸出（export）會包含來源以及目標，之後還會加入規則（rule）。
  這就是打包流程的核心所在。

```js
// webpack.config.js
const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: path.resolve('src', 'main.js'), // abs path
  output: {
    path: path.resolve('dist'), // abs path
    filename: 'bundle.js'
  }
};
```

---

## Lec 3: Modules Are Simply Files
  這堂課主要是在說
  如果來源的 `main.js` 如果有 import 其他模組，
  Webpack 也會一並將該模組帶入處理，

  可以從 `bundle.js` 看到所引入的模組的程式碼。

  例外講者另外介紹了 Node 模組與 ES6 模組的語法差異。
  兩者引入模組與輸出模組使用了不同的語法。
  而 Webpack 對兩者都可以支援。

---

## * Lec 4: Loaders Are Transformers
  這堂課介紹了兩個核心觀念：`Loader` 和 `rule`

  首先介紹 `Loader`，功能是讓 JavaScript 以外的檔案也能夠被處理，打包成模組。
  有了各種 `Loader` 我們就可以打包其他資源，像是圖片，CSS 等等。

  接著使用 `npm install css-loader --save-dev` 來安裝 css-loader 和 style-loader
  這兩個 Loader 的功能分別是：
    * css-loader 讓 Webpack 讀懂 CSS
    * style-loader 讓 Webpack 知道如何將 CSS 帶入到模組中

  接著我們還要將 `Loader` 帶進 `webpack.config.js`
  方法就是建立一個 `rule`，讓 Webpack 知道哪些副檔名的檔案要套用 `css-loader`。

  在 `module.exports` 建立 `module.rules`，塞入一個 object literal，
  當中包含 `test` 和 `use` ，指定檔名和 `loader`。

  要注意 `use` 陣列所輸入的 loader 順序和打包處理順序是相反的。
  打包的順序應該是先經過 `css-loader` 再經過 `style-loader`，
  但是輸入的陣列卻要反過來寫：

  `use: ['style-loader', 'css-loader']`

  結果就是這樣：

```js
// webpack.config.js
const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: path.resolve('src', 'main.js'), // abs path
  output: {
    path: path.resolve('dist'), // abs path
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.css$/,  // css file path regex
        use: ['style-loader', 'css-loader']  // NOTE right to left
  }]}};
```

---

## Lec 5: ES2015 Compilation With Babel
  打包的過程中也可以借助 `Babel` 將 ES6 轉譯，以支援更多瀏覽器。
  這時候要使用 Webpack plugin，首先下載對應的套件與 Babel preset

  `npm install --save-dev babel-loader babel-core babel-preset-es2015`

  建立 `.babelrc`

  `echo "{\"presets\":[\"es2015\"]}" > .babelrc`

  就可以讓打包工作支援 ES6 了！

```js
// webpack.config.js
const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: path.resolve('src', 'main.js'), // abs path
  output: {
    path: path.resolve('dist'), // abs path
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
  }]}};
```

---

## Lec 6: Minification and Environments

  這堂課介紹在 `Webpack.config.js` 中加入 plugin

  `webpack.optimize.UglifyJsPlugin()`

  就能夠將打包的檔案進行壓縮處理（minify）。

  我們也可以由環境變數來控制是否打包的時候要壓縮。

```js
const webpack = require('webpack');
const path = require('path');
const inProduction = (process.env.NODE_ENV === 'production');

module.exports = {
  entry: path.resolve('src', 'main.js'), // abs path
  output: {
    path: path.resolve('dist'), // abs path
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
  }]},
  plugins: []
};

if (inProduction) {
  module.exports.plugins.push(
    new webpack.optimize.UglifyJsPlugin()
  );
}
```

---

## Lec 7: Sass Compilation

  介紹如何使用 `sass-loader` 將 Sass 檔案轉成 CSS 並套用在網頁上

  現在應該可以發現愈來愈能抓到 Webpack 使用的模式了

  就是安裝對應的 Loader 然後加一個對應的 Rule

  `npm install --save-dev sass-loader node-sass`

  在 `use` 的部份要想一下 loader 如何串起來。
  處理 Sass 檔案的 rule 應該會是這樣：

```js
{
  test: /\.s[ac]ss$/,  // sass, scss
  use: ['style-loader', 'css-loader', 'sass-loader']
},
```

  一樣處理順序是從最後開始，先經過 sass-loader 處理 Sass 成 CSS，
  再經過 css-loader 理解 CSS，
  最後再經過 style-loader 將樣式帶到 `bundle.js` 中。

---

## * Lec 8: Extract CSS to a Dedicated File
  這一堂課討論的情境是，
  有時你還是希望 Sass 檔案不要被包進模組，
  而是以獨立 CSS 檔案的方式輸出，以供他人維護。

  也就是說，你想要 Webpack 處理 Sass 成為 CSS，
  但是最後又不要將它包到最終的 `bundle.js`
  而是以 `app.css` 輸出。

  這時候我們要再裝一個新的外掛 `extract-text-webpack-plugin`

  `npm install --save-dev extract-text-webpack-plugin`

  這個外掛可以將現有的 loader 組成一個新的 "Extract Loader"。
  接著將特定的資源從來源中抽取出來，以不同的方式輸出。
  新的 `module.rules` 項目變成這樣：

```js
const ExtractTextPlugin = require('extract-text-webpack-plugin');

// ...
{
  test: /\.s[ac]ss$/,  // sass, scss
  use: ExtractTextPlugin.extract({
    use: ['css-loader', 'sass-loader'],
    fallback: 'style-loader'
  })
},
```
  可以發現它使用了 `css-loader` 和 `sass-loader` ，將之組成一個 "Extract Loader" 。
  畢竟 Webpack 還是需要這兩個 loader 才能轉換 Sass 成 CSS。
  而 `fallback` 設定 `style-loader` 是針對沒有辦法被抽取出來的 CSS，
  要繼續用 `style-loader` 將樣式帶進 `bundle.js`。

  接著在 `plugins` 指定 CSS 輸出的名稱：

```js
//...
plugins: [
  new ExtractTextPlugin('app.css')
]
```

  大功告成啦！最後得到了 `dist/bundle.js` 和 `dist/app.css`

---

## Summary

  - Webpack 主要功能就是幫你把資源打包成 JavaScript 模組。
  - Webpack 打包時會處理相依性，像是 js 裡的 `require` 和 CSS 裡的 `url` 都會被處理。
  - Webpack 藉由 *Loader* 在打包時幫你對各種格式的資源做處理，像 Sass, ES6，圖片。
  - Webpack 藉由 *Plugin* 客制化一些功能，像是抽取出 CSS 資源。


[course link]: https://laracasts.com/series/webpack-for-everyone "course link"
