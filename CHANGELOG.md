## 0.9.6 (pre-release)
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
