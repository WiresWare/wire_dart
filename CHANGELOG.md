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
