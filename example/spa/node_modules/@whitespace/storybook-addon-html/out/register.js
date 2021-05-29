"use strict";

var _react = _interopRequireDefault(require("react"));

var _components = require("@storybook/components");

var _addons = require("@storybook/addons");

var _Panel = _interopRequireDefault(require("./Panel"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var ADDON_ID = 'html';
var PANEL_ID = "".concat(ADDON_ID, "/panel");

_addons.addons.register(ADDON_ID, function () {
  _addons.addons.add(PANEL_ID, {
    title: 'HTML',
    type: _addons.types.PANEL,
    render: function render(_ref) {
      var active = _ref.active,
          key = _ref.key;
      return /*#__PURE__*/_react.default.createElement(_components.AddonPanel, {
        active: active,
        key: key
      }, /*#__PURE__*/_react.default.createElement(_Panel.default, null));
    }
  });
});