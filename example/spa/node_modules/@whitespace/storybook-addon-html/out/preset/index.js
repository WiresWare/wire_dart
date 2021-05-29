"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.managerEntries = managerEntries;
exports.config = config;

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && Symbol.iterator in Object(iter)) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function managerEntries() {
  var entry = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
  return [].concat(_toConsumableArray(entry), [require.resolve('../register')]);
}

function config() {
  var entry = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];

  var _ref = arguments.length > 1 ? arguments[1] : undefined,
      _ref$addDecorator = _ref.addDecorator,
      addDecorator = _ref$addDecorator === void 0 ? true : _ref$addDecorator;

  var addonConfig = [];

  if (addDecorator) {
    addonConfig.push(require.resolve('./addDecorators'));
  }

  return [].concat(_toConsumableArray(entry), addonConfig);
}