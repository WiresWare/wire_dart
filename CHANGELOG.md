## 1.5.4
- Wire.data listeners copied to Set before traverse them on value change/update

## 1.5.3
- Parameter of `WireSendResults.dataList` was renamed to `WireSendResults.list`
- Errors thrown while `Wire.send` transfer signal will captured and placed in results `WireSendResults` as `WireSendError`, and the results now has method to check for errors `hasError` 
- Docs updated, tests extended to cover more cases and new methods

## 1.5.2
- Method remove in WireDataContainerLayer became private.
- Wire listener became private and can be compared through method listenerEqual, which is used in remove and getByListener.
- In order to call middleware on WireData.remove call the method reset called instead of nulling value.
- Examples and tests updated
 
## 1.5.1
- New error `ERROR__SUBSCRIBE_TO_DATA_GETTER` thrown on `WireData` subscribe method called when its a getter - `isGetter == true`, thus its not possible to listen for getter updates!
- In `WireData.refresh()` method the value stored to local variable before traverse the array of listeners passing getting value for each (because value could be getter).
- `WireData` with new property `numberOfListeners`
- Minor improvements and code reorganizations, `Wire.add` async.

## 1.5.0
- API update: return `WireSendResults` when `Wire.send` instead of boolean value of numbers of subscribers left for the signal.

## 1.4.10
- README updated

## 1.4.9
- New abstracts - `WireCommandAbstract` and `WireDatabaseServiceAbstract`
- New utilities mixins - `WireMixinWithDatabase` and `WireMixinWithWhenReady`
- New utilities commands - `WireCommandWithRequiredData` and `WireCommandWithWireData`
- Prefix "Wire" was added to all utilities and mixins related to Wire
- New method "remove" in `WireMixinWithWireData`, which simplify `Wire.data(dataKey).remove()`
- Additional example of Todo application with use of commands to process signal without model but with
  `StorageMiddleware` which store all changes in `WireData` layer to `shared_preferences`
- Dart version increased to 2.17.5

## 1.4.8
- Reset of WireData propagated to middleware layer
- Refactoring and code improvements (types)
- Mixins (utilities) MixinWithWireData moved from Wire Flutter

## 1.4.7
- API updated with new methods: `addMany` which allow to add (create) wires from Map<String, WireListener>
- Wire.remove rewritten to allow remove all wires related to scope without specifying each signal with scope
- Tests updated with coverage of new method `addMany`

## 1.4.6
- API updated with two new methods: `put` which store an instance of the object by it's type, and lock it, so it can't be overwritten, and `find` returns an instance of an object by its type, throw an error in case it is not set

## 1.4.5
- Print removal

## 1.4.4
- Working version on await Wire.send
- Code refactoring and clarifications

## 1.4.3
- Reset WireData value to null with and call listeners: Wire.data(DataKey.SOMETHING).reset()
- WireViewer in progress

## 1.4.2
- Examples shared code updated to work with wire_flutter (https://pub.dev/packages/wire_flutter)
- Angular Example is deprecated

## 1.4.1
- Wire.add method made async
- Throw exception from Wire.data when setting value on WireData.isGetter
- Additional check for null listener before transfer data
- License year updated
- Unused NodeJS files removed

## 1.4.0
- Getter implementation in WireData: getter is method returned in result of getting wireData.value, in this case wireData instance is locked and can't be changed (new value by key won't be set).

## 1.3.0
- Async API implementation
- Examples modified to be async
- SPA example with states (WIP)

## 1.2.0
- Transition to Dart null-safety
- Clarification of the API and minor renaming
- Corrections in variables names in examples

## 1.1.0
- WireData new lock API: Now the owner of data can lock write operation with a special token - an instance of WireDataLockToken.
- bool WireData.lock(WireDataLockToken token)
- bool WireData.unlock(WireDataLockToken token)
- bool get WireData.isLocked

## 1.0.2
- Changes in WireListener: parameter name "wid" was replaced to "wireId" for better
- Counter example structure updated
- README update

## 1.0.1
- Commented out overrides for wire in example/_shared
- Removed wire_example_shared from dependencies in pubspec, pubspec.lock added to gitignore
- Shared examples - TodoController updated. Todo example Model initialization with isFlutter false for proper components update on web.
- README updated with "Few words about FLUX" section. Also README in example folder updated with how to setup IDEA

## 1.0.0
- Typed Wire<T> and WireListener<T>, WireData<T> and WireDataListener<T>.
- WireListener optional property was renamed - data -> payload.
- Method Wire.send has new optional parameter - Object scope, if it's not null then only Wire instances with this scope value will receive the payload.
- README updated

## 0.9.81  (pre-release)
- Shared folder extracted as pub library and added to subrepo on separate branch with "git subrepo" extension. Changes to examples applied.

## 0.9.8
- Todo example with AngularDart using shared code from symlink.

## 0.9.7
- README update

## 0.9.6
- Wire's property "hash" renamed to "wid" - unique integer number which is just counter of created Wires in runtime.
- Parameters of WireListener was changed - instance of Wire removed, first parameter now is data from `Wire.send(signal, data)`, second parameter is a "wid" using it associated Wire can be retrieved from communication layer with `Wire.get(wid:wid).single`.
- Internal renaming to match layers concept
- README update with Flutter widget example
- Examples updates according changes

## 0.9.1
- In Wire.data first parameter renamed from 'param' to 'key' and related changes applied.
- Method subscribe for WireDataListener has only listener, and scope was removed
- New tests for "Counter Signal" and API example update
- README update, Haxe version linked in README

## 0.5.0
- Tests, changes according test results, documentation update
- Implementation .clear() method in Wire instance, which is called after wire removed from communication layer

## 0.4.0
- Introduction of middleware - class that extends WireMiddleware is able to listen for things happen inside communication and data container layers
- `Wire.attach` and `Wire.detach`. Wire instance can be created solely but it won't be included in communication layer, and `attach` method introduced to manually add Wire instance to the communication layer, and `detach` to remove it.
- `Wire.get` modified to return instances only on one of params: signal, scope or listener
- `Wire.purge` clear all entities on communication and data container layers
- In code documentation for API
- Examples update with middleware use
- Graphics of how to use Wire in decoupled system

## 0.3.3
- New API methods: `has` signal or wire and `get` list of wires by signal, scope or listener

## 0.3.2
- dartfmt style fixes

## 0.3.1
- WireListener has first parameter Wire that holds signal, scope, listener itself and replies

## 0.3.0
- In method Wire.add replies parameter is named
- APACHE LICENSE, VERSION 2.0
- UML diagram from StartUML
- Examples correction

## 0.2.2
- Introduction of WireListener and WireDataListener to force correct listeners method's params signature
- Implementation of "remove" from Wire by scope or/and by listener
- WireData has new property "isSet" which help to distinguish between newly created with value null and deleted when null distributed to listeners
- Todo MVC example completed!
- Other examples update and style fixes

## 0.2.1
- Implementation of SCOPE for signals, data viewers subscribers. Counter example changed to use Specter CSS instead of Coral components.
- WireData.remove implementation. Todo MVC with Wire: only basic operations create and delete.

## 0.2.0
- Data "layer" implemented. It's a container, universal container (Map) with key-value, where value is a wrapper - WireData - hold dynamic value and can be listened for updates.
- Counter example was added based on web (Using idea - create build target Dart Web with HTML file - example/counter/index.html, then debug)

## 0.1.7
- Minor changes in internal naming

## 0.1.5
- Initial version, with base API: add / send / remove
