"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _withHTML = require("./withHTML");

Object.keys(_withHTML).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  if (key in exports && exports[key] === _withHTML[key]) return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _withHTML[key];
    }
  });
});