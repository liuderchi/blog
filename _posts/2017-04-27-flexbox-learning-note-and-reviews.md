---
layout:     post
title:      Flexbox Learning Note And Reviews
abstract:   Learning note of CSS3 flexbox and review
comments:   true
tags:       css css3 flexbox
---

### Abstract

  - 簡單的紀錄學習 Flexbox 的心得，還有一些 Flexbox 的小套路
  - 我學習的課程資源是 Udemy 的 [The Complete Flexbox Tutorial: Learn CSS3 Flexbox in 2017][Course link]
  - 這篇文章適合已經了解 flexbox 基本用法的人閱讀，並非從頭開始介紹 flexbox 屬性有什麼效果

### What to solve?

  - 簡單的說，就是讓 "排版" 更方便
      - 比方說購物網站的商品列表，我可能想要置中排列，或是分散的排列
      - 這些需求使用可以使用一些 CSS 框架完成，例如 bootstrap 的 [grid][twbs grid]
      - 現在 CSS3 的 flexbox 也提供了同樣的功能，從某些角度來說使用起來可能更簡便

### flexbox katas

  - flex 屬性的分類：可以從對象來看，分為：父元素（container），以及子元素（item）
      - 排版的對象就是子元素，只是 flexbox 屬性會下在父元素或子元素，均有可能
  - 對容器下 flexbox 的基本流程
      1.  `display:flex`
      2. 下 `flex-direction` 決定主軸方向
          - *row*, *column*, *column-reverse*
      3. 下 `justify-content` 將元素作軸向調整間距 (main-axis)
          - *flex-start*, *space-between*...
      4. 下 `align-item` 對元素做垂直方向移動或伸展 (cross-axis 方向)
          - *stretch*, *baseline*, *flex-start*, *center*...
      5. 下 `flex-wrap` 折行，處理主軸的元素 overflow
          - *nowrap*, *wrap*, *wrap-reverse*
          - *NOTE* 2. 和 5. 可以用簡短表示法 `flex-flow: row nowrap`
      6. 下 `align-content`，調整折行後元素之間的間隔
          - *flex-start*, *space-between*...
  - 對子元素下 flex 的使用情境
      - `flex: [flex-grow] [flex-shrink] [flex-basis]`
          - `flex-grow` 講的是如果容器有多餘空間，如何瓜分它（膨脹量的比例值）
          - `flex-shrink` 講的是如果容器空間不足，怎麼壓縮子元素（壓縮量的比例值）
          - `flex-basis` 講的是依據 `flex-direction` 設定的方向設定子元素尺寸
      - 子元素的尺寸計算流程
          1. 依據 flex-basis 算出基本尺寸
          2. 考慮有無 a.容器空間有多餘 b.容器空間不夠
              - 如果有，計算對應的膨脹或壓縮
          3. 將膨脹或壓縮量加到基本尺寸上
      - 如果要更動少數幾個子元素的順序，下 `order`

### Use cases

  - 模擬 bootstrap grid 的排版：
      - 對子元素下 `flex: 1`
      - 對特定想要加強寬度的子元素修改 `flex-grow`
          - 例如 `flex-grow: 3`

![demo-flexbox-grid](https://cloud.githubusercontent.com/assets/4994705/25486849/02594416-2b95-11e7-9c3c-c1d37e5410b1.png)

### Summary

  - CSS3 的 flexbox 提供了方便的排版功能，也可以模擬 bootstrap grid 達到 responsive

[Course link]: https://www.udemy.com/flexbox-tutorial/ "course link"
[twbs grid]: https://v4-alpha.getbootstrap.com/layout/grid/ "bootstrap grid"
