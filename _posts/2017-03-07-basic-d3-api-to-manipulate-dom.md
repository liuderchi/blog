---
layout:     post
title:      Basic D3 API to Manipulate DOM
abstract:   Notes about concept of D3 API usage flow.
comments:   true
tags:       d3 visualization review
---

## Preface

  - 在網頁前端技術領域中，資料視覺化是一個重要的技術
      - 而 [`D3.js`][1] 是非常有名的資料視覺化函式庫，GitHub 上有六萬顆星
      - 從官方網頁提供了[大量的範例][2]中，看出它功能強大
  - 好奇 D3.js 的原理到底是什麼？程式碼寫起來感覺如何？
      - 這篇文章提供了閱讀網路上資料的小小心得，希望能對於觀望 D3.js 的人能有所幫助
          1. 這篇 [SVG D3.js - 淺談 D3.js 的資料處理][3]
          2. 官方版本 3.x 的 [介紹 selection 的 API 文件][4]
          3. 資料視覺化的 [網頁視覺化利器 － D3.js 簡介][5]

---

## Intro of D3.js
  - D3.js 是？
      - 用 JavaScript 在瀏覽器上視覺化資料的函式庫
  - D3 要解決的問題是？
      - 使用 HTML 元素來視覺化資料的手續繁雜
          - 動手刻需要很多冗長的處理（遍歷陣列，產生新元素）
          - 用 `<svg>` 畫出一個圖形需要很多手續（定義座標，樣式）
          - D3 可以包辦這些處理，節省開發者很多時間
      - 換句話說，D3 希望讓資料能輕鬆的被用來 *建立* 和 *連結* HTML 元素
  - 讓資料 *連結* HTML 元素：包含圖表的 *樣式*，舉個例子：
      - 有個 JavaScript 陣列裝的是學生資料，有性別和年齡。
      - 圖表需求是：
          - 我想要畫長條圖。（用 `<svg>` 或 `<div>` 畫長方形）
          - 男性用藍色，女性用紫色。（套用 css `background-color`）
          - 年紀愈大，長條圖越長。（套用 css `width`）
          - 每個長條圖標記學生姓名。（元素裏面要塞文字）
      - D3 能夠提供方便的介面來完成這些功能，讓程式碼比較好維護。

---

## Common Flow of Drawing using D3.js API

  - 網路上的文章中，常見的例子之一就是[將矩陣資料畫成直方圖][3]
      - 看了一些範例之後，
      - 整理了 D3 API 常見的流程，在這裡留下一些心得和紀錄

  - 首先，畫圖的資料一定是 Array 但元素可以是 Array 或是物件，這裡取名為 `myArr`


  1. `d3.select()` 輸入 css selector 決定圖表的位置
      - 回傳 `selection`，供之後使用
      - `selection` 是個 array，裏面裝 array of elements，以及 parentNode 資訊
          - 詳細的 [selection 定義][4]

  2. `selection.data(myArr[, key])` 讓 `myArr` 和 `selection` 接在一起
      - 把 `myArr` 資料放在 DOM Node 的屬性 `__data__` 中
      - 回傳 *update-selection*, 之後就可以呼叫 `.enter()`
      - `key` 是個函式，可以客制化要連結的陣列元素的屬性
      - 如果圖表位置沒有子元素要先用 `.selectAll()` 再呼叫 `.data()`

  3. `selection.enter()` 選擇 *沒有與 HTML 元素連結的資料*
      - 回傳 *enter-selection*
      - 只有 enter-selection 才可以呼叫 `.append()` 和 `.insert()`

  4. `selection.append()` 對 *enter-selection* 建立新 HTML 元素

  5. 對 *update-selection* 呼叫 `.exit().remove()`
      - 選擇 *沒有和資料連結的 HTML 元素* 並移除
      - [官方文件解釋 `exit()` 的用法](https://github.com/d3/d3-3.x-api-reference/blob/master/Selections.md#exit)
      - `enter()` 對比 `exit()`
          - 「沒有與 HTML 元素連結的資料」與「沒有和資料連結的 HTML 元素」

  6. `selection.text()` 遍歷 *update-selection* 為元素建立文字

  7. `selection.style()` 遍歷 *update-selection* 設定元素樣式


  - 程式碼 API 風格是 method chaining，簡化的[範例程式碼 fiddle][6]：

```js
var myArr = [['John', 'm', 18 ], ['Mary', 'f', 20 ], ['Ivy', 'f', 27 ]]
// name, gender, age

var divSelection = d3.select("body")                   // 1.
                     .selectAll("div")
                     .data(myArr, (e)=>{ return e })   // 2.

divSelection.enter().append("div")        // 3. 4.
divSelection.exit().remove()              // 5.

divSelection.text((e)=>{ return e[0] })   // 6.
            .style({                      // 7.
              margin: "5px",
              "background-color": (e)=>{return (e[1] === 'm')? '#A9D0F5':'#D0A9F5'},
              width: (e)=>{return (e[2]*10)+"px"}  // calculate by age
            })
```

  - 畫出來的圖：

<img style="display: block; margin: 0 auto"  src="https://cloud.githubusercontent.com/assets/4994705/23652719/ef6a028a-0364-11e7-8402-ef654661996b.png">

---

## Summary

  - d3 強大之處在於處理了資料與 HTML 元素的連結，省下非常多的開發時間。
  - 用一句話講完 `d3.js` 基本範例的流程：
      - 選擇了適當的位置(1.)，將該選擇與資料陣列連結在一起(2.)，產生對應數量的 HTML 元素(3.4.5.)，最後根據資料套用樣式於元素上(6.7.)。



[1]: https://d3js.org/ "D3.js"
[2]: https://github.com/d3/d3/wiki/Gallery "d3 examples"
[3]: http://www.oxxostudio.tw/articles/201411/svg-d3-01-data.html "SVG D3.js - 淺談 D3.js 的資料處理"
[4]: https://github.com/d3/d3-3.x-api-reference/blob/master/Selections.md "API 文件"
[5]: http://blog.infographics.tw/2015/03/d3js-the-introduction/ "網頁視覺化利器 － D3.js 簡介"
[6]: https://jsfiddle.net/dom7twuv/5/ "Sample code"


[demod3div]: https://cloud.githubusercontent.com/assets/4994705/23652719/ef6a028a-0364-11e7-8402-ef654661996b.png "demod3div"
