---
layout:     post
title:      Learning Less From Atom
abstract:   Share my Atom style sheet and related less syntax
comments:   true
tags:       atom style less
---

### 前言

  [Atom 編輯器][atom]的其中一個最大的特色就是 "Hackable"
  讓使用者可以使用 Web 技術來客制化 Atom

  而在編輯器外觀方面也不例外，Atom 使用 CSS 來客制化樣式
  編輯器的佈景主題也是由許多的樣式表組成

  然而隨著時間，在習慣的佈景主題中，
  總是會有一些小地方想要依照自己的喜好調整。

  今天要介紹的是使用 `style.less` -- 官方提供的空白樣式表
  作為輸入點，來修改現有的佈景主題

  一方面分享自己喜愛的樣式調整，一方面也複習相關的 `scss` 語法。

  [我的 style.less 原始檔][style.less]

---

### less import

  首先看到的是使用 `@` 符號作為輸入外部檔案或定義變數
  這裡我定了一些喜歡的顏色和字型大小，讓這份樣式表更為語意化。

```scss
// atom built-in
@import "ui-variables";     
@import "syntax-variables";

@_lightGreen: rgba(59,255,0,.85);
@_greyGreen: hsl( 95, 38%, 62%);
@_atomGreen: #5FB57D;

@_treeViewFontSize: @font-size + 6px;  // from ui-variables
```

---

### Tree View

  首先客制化的是 tree-view ，Atom 用來顯示檔案的 side bar

  改進一： 我覺得預設的字型太小了。所以套用了自訂的 `@_treeViewFontSize`
  改進二： 我希望滑鼠移到檔案圖示上時，可以有酷炫的放大效果，最好像蘋果電腦桌面那樣(遠望)。

  有查到相關的文章，但是牽涉較多的計算與限制，所以目前只有先使用 css `transition` 做。
  這裡也有運用到了 less 的 `&` 運算子，用來表示外部的選擇器，符合 DRY 精神。

```scss
.tree-view {  // hover on item
  font-size: @_treeViewFontSize;

  // animation of file entry, folder entry
  li.file, .header.list-item {
    transition: padding 1.5s, font-size 1.5s; // HOVER-OFF
    padding: 0px;
    &:hover {
      transition: padding 1s, font-size 1s;   // HOVER-ON
      padding: 15px 0px;
      font-size: @_treeViewFontSizeHovered;
    }
  }
}
```

  套用後的效果(請想像這是 hover 1.5 秒後的樣子)

  ![treeview01][treeview01]

---

### Find and Replace

  Find and Replace 是搜尋檔案用的套件，
  搜尋結果會以樹狀的方式顯示，右上角頁面會有按鈕可以展開或合併樹狀圖的節點。

  ![find01][find01]

  改進：覺得按鈕文字前方如果有圖示，就能夠更直覺的點選按鈕(對我真的常常會猶豫)。

  遇到了一個挑戰：`button` 沒有套 `class` 屬性，一時無法選到正確的元素。
  之後發現還好 CSS 有提供 `first-of-type` 和 `nth-of-type()`

  選擇器搭配使用了 `font-awesome` 還是可以成功套用圖示

```scss
.preview-header {  // search result summary
  font-size: @_projFindResFontSizeSummary;

  button.btn:first-of-type {  // collapse all button
    font-size: @_projFindResFontSizeMatchCount;
    &::before {  content: "\f066\ ";  }  // fa-expand
  }
  button.btn:nth-of-type(2) {  // expand all button
    font-size: @_projFindResFontSizeMatchCount;
    &::before {  content: "\f065\ ";  }  // fa-compress
  }
}
```

  同時調整了一些字型大小後的結果：

  ![find02][find02]

---

### 檔案編碼

  狀態列中會有一個元素 `encoding-selector-status` 顯示目前檔案的編碼，
  我想要在其屬性 `data-encoding` 不是 `utf8` 的時候換成警告的顏色。

```scss
status-bar{
  encoding-selector-status a:not([data-encoding="utf8"]) {
    color: @text-color-warning;
  }
}
```

  運用了 `:not` 選擇器之後，看起來變成這樣

  ![statusbar01][statusbar01]

---

### 程式碼折疊

  Atom 提供了程式碼折疊的功能，讓你把不想要注意的程式碼暫時 "藏起來"。
  折疊起來的部份變成了一個 `.fold-marker`，看起來會是這樣。

  ![fold01][fold01]

  改進一：想要把這個 `span` 換成顯眼的圖示，搭配顯眼的顏色，方便閱讀。

  這裡使用了另一個 less 的功能 **mixin**，讓你可以撰寫可重複使用的 "函數"
  呼叫了 mixin 就會把該函數中的規則注入。你可以把常重複的選擇器包成 mixin，簡化代碼。

  為了讓折疊後的樣式可以客制化，我提供了變數 `@content` `@color` 給 mixin

```scss
._fold-marker-content(@content, @color) {  // folded function code
  &::after {
    content: @content;
    color: @color;
    font-size: 1.25em;
  }
}
.fold-marker {  // folded code
  ._fold-marker-content("\f141", @text-color-success);
}
```

  輸入了 font-awesome 圖示後，變得真的更清楚了！

  ![fold02][fold02]

---

### 結語

  - DIY 改 Atom 很好玩，一邊練習 less 一邊改進自己的開發環境。
  - Atom 的討論區會有人[分享自己的 style sheet][discussion]，有時會去上面找靈感。
  - 有些元件實在是無法單純用 css 就能達到修改（沒有 class，元素屬性不會變動）
      - 要用 DOM API 來完成
      - 還好 Atom 提供了 `init.coffee` 作為另一個客制化的位置
          - 可以讓外掛開發者以 `coffeescript` 測試 Atom API
  - 下次來分享自己的 `init.coffee` 如何完成更多客制化


[atom]: https://atom.io/ "atom"
[style.less]: https://github.com/liuderchi/dot-atom-files/blob/master/styles.less "style.less"
[treeview01]: https://cloud.githubusercontent.com/assets/4994705/23910182/cc33b72a-0913-11e7-84d0-d52382509a4a.png "treeview01"
[find01]: https://cloud.githubusercontent.com/assets/4994705/23910186/d197f3e8-0913-11e7-9643-281e1ac895ba.png "find01"
[find02]: https://cloud.githubusercontent.com/assets/4994705/23910189/d376fc9a-0913-11e7-89d5-ea3813a636bf.png "find02"
[statusbar01]: https://cloud.githubusercontent.com/assets/4994705/23910192/d6740a32-0913-11e7-95cd-bcfd9826f85c.png "statusbar01"
[fold01]: https://cloud.githubusercontent.com/assets/4994705/23910200/d947f020-0913-11e7-9e55-bb77c435ab7e.png "fold01"
[fold02]: https://cloud.githubusercontent.com/assets/4994705/23910203/dafa1f74-0913-11e7-899a-f37070f87b6c.png "fold02"
[discussion]: https://discuss.atom.io/t/share-your-stylesheet/21653 "share your style sheet"
