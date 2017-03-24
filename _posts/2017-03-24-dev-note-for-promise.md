---
layout:     post
title:      Dev Note for Promise
abstract:   Understand Promise behavior and how to make it as chain
comments:   true
tags:       promise js
---

## Abstract

  第一次接觸 Promise 的時候是在使用 AngularJS 提供的 `$http`，它是一個基於 `XMLHttpRequest` 的包裝，
  回傳的物件是符合 [Promise/A+][promise/A+] 的 Promise，因此要理解 Promise 的特性與表現，
  才能夠正確的實作網頁應用中的非同步操作與使用者介面變化流程。

  然而在面對多個具有相依性的非同步操作，程式碼結構會變得複雜難以維護（波動拳式回呼）。
  因此，希望藉著這個機會好好檢視 [MDN 文件][mdn ref] 並學習如何撰寫風格良好的 Promise 程式碼。

---

## Promise Behavior Review

  - Prmoise 就是用一個物件來表示未來會有執行的結果的工作，其 **狀態** 包含 3 種可能：
      - pending: 執行中
      - fulfilled：做了結果成功
      - rejected：做了結果失敗（不一定做完）
      - Prmoise 剛建立的時候是 pending，未來只可能會變成 fulfilled 或是 rejected **其中一種**

  - 可以對 Promise 繫結你想要的 *Callback* 來針對狀態的改變執行對應函式
      - `myPromise.then(onFulfilled, onRejected)`
      - *Q：* 什麼時候呼 Callback？
          - 看 `myPromise` 狀態
          - 變成 fulfilled 時呼 `onFulfilled`
          - 變成 rejected 時呼 `onRejected`
          - 該 Promise 有結果的時候，狀態就會變
      - *Q：* 這兩個 Callback 可以做什麼？
          - 接收 `myPromise` 提供的訊息並處理，舉例來說
              - `myPromise` 成功的話寫 `onFulfilled(val)` 處理執行結果
              - `myPromise` 失敗寫 `onRejected(reason)` 印出失敗原因

  - Promise 可以串聯
      - 因為 `myPromise.then()` **必定會回傳一個 Promise 給你接著用**，不論該 Callback 的結果是成功還是失敗
      - *Q：* `.then()` 回傳什麼狀態的 Promise？
          - 如果執行 Callback 的時候拋錯（不論是 `onFulfilled` 還是 `onRejected`），或是最後回傳了另一個 *做了結果失敗的 Promise （rejected）* ，
              - 那 `.then()` 就會回傳一個狀態為 rejected 的 Promise
          - 如果執行 Callback 的時候（不論是 `onFulfilled` 還是 `onRejected`）回傳了任何值（包含 undefined），或是最後回傳了另一個 *做了結果成功的 Promise （fulfilled）*
              - 那 `.then()` 就會回傳一個狀態為 fulfilled 的 Promise
      - 所以 `.then()` 回傳什麼樣的 Promise 要等 Callback 的結果才會知道
          - 因為要等，所以這樣就能夠讓多個 Async 的工作有一定的執行順序
      - 所以 `.then(...)` 可以串聯接著用，像是鎖鏈
      - 練習以 Promise 鎖鏈造句：家長對小孩的期待

```js
beGoodKid
  .then(beGoodStudent, ...)
  .then(workSuccess, ...)
```

---

## Promise Chain Practice

  - 好習慣：`onFulfilled` 函式回傳一個 Promise
      - 因為根據上一段，`.then()` 在內部的 Callback 如果回傳了 rejected Promise，那 `.then()` 最後就會回傳該 rejected Promise
      - 這樣可以讓鎖鏈的下一個 `.then()` 根據上一個 Promise 的狀態來做對應處理
  - 所以可以這樣說，`.then()` 要提供 `onRejected`，才可以處理前面產生的 rejected 的 Promise
  - 但是，每一個 `myPromise.then().then()` 裏面都要寫一個 `onRejected` 實在是不好維護
  - *Q：* 如果不提供 `onRejected` 的話會怎樣？
      - 例如：`myPromise.then(onFulfilled)`
          - `myPromise` 最後 fulfilled 的話就照原先，執行 `onFulfilled`
          - `myPromise` 最後 rejected 的話 `.then()` 就會回傳原本就是 rejected 的 `myPromise`
      - 按：你不提供處理辦法，我就丟給下一位
  - 所以，這裡提供另一個好習慣：在鎖鏈的尾端要有 `onRejected` 處理先前任一 Promise 所產生的失敗結果
      - 或者使用只處理 rejected 狀態的 `myPromise.catch(onRejected)`
      - 這樣可以寫出好讀的 Promise 鎖鏈
  - 鎖鏈造句：家長對小孩的期待範例（二）

```js
beGoodKid()
  .then(() => {
    return beGoodStudent()  // it's async
  })
  .then(() => {
    return workSuccess()    // it's async
  })
  .catch() => {
    console.warn('your parents are angry')
  }
```
  - 按：只要一件事情沒做好，後面就沒機會了。

  - 一個很喜歡的簡潔範例，以 Promise 結合 array 的 `reduce()`，依序於 Atom 編輯器開啟多個檔案

```js
const path = require('path');
const os = require('os');
const paths = ['file.one', 'file.two', 'file.three'];

paths.reduce((cur, nextPath) => {
  return cur.then(() => {  // return .then() for next promise
    return atom.workspace.open(nextPath);  // return an open job as a promise
  });
}, Promise.resolve('start'));  // init promise
```

---

## Summary

  - Promise 專門用來處理未來才會完成的工作，以狀態來表現工作結果
  - 使用 `.then(onFulfilled, onRejected)` 讓 Promise 的狀態變化會觸發對應的 Callback
  - `.then()` 和 `.catch()` 必定回傳一個 Promise ，這個特性讓你可以把 Promise 串成鎖鏈，有相依性的執行數個非同步工作
  - 養成良好的 Promise 鎖鏈習慣可以讓你撰寫好維護的程式碼


  [mdn ref]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise
  [從Promise開始的JavaScript異步生活]: https://eyesofkids.gitbooks.io/javascript-start-es6-promise/content/contents/anti_pattern.html
  [promise/A+]: https://promisesaplus.com/
  [sequentially]: http://stackoverflow.com/questions/20100245/how-can-i-execute-array-of-promises-in-sequential-order "sequentially"
