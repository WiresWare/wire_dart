"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.withHTML = void 0;

var _addons = require("@storybook/addons");

var _shared = require("../shared");

var withHTML = (0, _addons.makeDecorator)({
  name: 'withHTML',
  parameterName: 'html',
  skipIfNoParametersOrOptions: false,
  wrapper: function wrapper(storyFn, context, _ref) {
    var _ref$parameters = _ref.parameters,
        parameters = _ref$parameters === void 0 ? {} : _ref$parameters;
    setTimeout(function () {
      var channel = _addons.addons.getChannel();

      var rootSelector = parameters.root || '#root';
      var root = document.querySelector(rootSelector);
      var html = root ? root.innerHTML : "".concat(rootSelector, " not found.");

      if (parameters.removeEmptyComments) {
        html = html.replace(/<!--\s*-->/g, '');
      }

      channel.emit(_shared.EVENT_CODE_RECEIVED, {
        html: html,
        options: parameters
      });
    }, 0);
    return storyFn(context);
  }
});
exports.withHTML = withHTML;

if (module && module.hot && module.hot.decline) {
  module.hot.decline();
}