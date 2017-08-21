---
layout:     post
title:      How Underscore Extends Object
abstract:   Share my survey to underscore js source code about extend object
comments:   true
tags:       js underscore extend
---

## Abstract

  I've planning to learn to write efficient js code.
  Learning from open source is a good idea.
  Also, I've been confused about how `_.extend()` differs from `extends` from ES6
  So let's jump into the really famous JavaScript Utility Library [Underscore.js][http://underscorejs.org/]!

---

## Underscore Source
  - version: *v1.8.3*
  - description:
      - *Shallowly copy all of the properties in the source objects over to the destination object, and return the destination object. Any nested objects or arrays will be copied by reference, not duplicated. It's in-order, so the last source will override properties of the same name in previous arguments.*
  - usage:
      - `_.extend({name: 'moe'}, {age: 50});
      => {name: 'moe', age: 50}`

---

## Reviews from code
  - `_.extend = createAssigner(_.allKeys)` returns a function ([*L99*][L99])
  - `createAssigner` is a closure accessing `keysFunc` as helper function
      - in this case `keysFunc` is `_.allKeys`
      - `_.allKeys` used to get keys from an object ([*L939~L945*][L939])
  - flow of `_.extend`
      - it first check `arguments.length`, when it's one it returns the object itself ([*L100~L101*][L100])
      - looping from 2nd object to last object ([*L102*][L102])
          - for each object get keys and length of keys, looping ([*L106*][L106])
              - for each key, set property onto first object ([*L108*][L108])
                  - shallow copy
                  - *Any nested objects or arrays will be copied by reference, not duplicated*

```js
// An internal function for creating assigner functions.
var createAssigner = function(keysFunc, undefinedOnly) {
  return function(obj) {
    var length = arguments.length;
    if (length < 2 || obj == null) return obj;
    for (var index = 1; index < length; index++) {
      var source = arguments[index],
          keys = keysFunc(source),
          l = keys.length;
      for (var i = 0; i < l; i++) {
        var key = keys[i];
        if (!undefinedOnly || obj[key] === void 0) obj[key] = source[key];
      }
    }
    return obj;
  };
};
```

---

## Summary

  we can find that what `_.extend()` does is basically looping over property of objects from second one to last one, grabbing properties and put them on first objects. Worth noticing is that it's shallow copy and it's copied by reference if source property is object or array


[L99]: https://github.com/jashkenas/underscore/blob/1.8.3/underscore.js#L99 "L99"
[L939]: https://github.com/jashkenas/underscore/blob/1.8.3/underscore.js#L939 "L939"
[L100]: https://github.com/jashkenas/underscore/blob/1.8.3/underscore.js#L100 "L100"
[L102]: https://github.com/jashkenas/underscore/blob/1.8.3/underscore.js#L102 "L102"
[L106]: https://github.com/jashkenas/underscore/blob/1.8.3/underscore.js#L106 "L106"
[L108]: https://github.com/jashkenas/underscore/blob/1.8.3/underscore.js#L108 "L108"
