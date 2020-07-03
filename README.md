# Wire - communication and data container layers
### Tool aimed to decouple UI from business logic
![Schema](assets/wire-schema.jpeg)

Pub/sub library - communication layer or "bus" to which you can attach a Wire and listen for signal associated with it.
Wire has simple API - add, send and remove. Also it has data layer (`WireData Wire.data(String param, [dynamic value]);`).
It's a universal container with key-value, where value is an instance of WireData that holds dynamic value and can be subscribed for updates. This "data container" is something like Redis.

Wire also has Flutter Widget that allows to subscribe to data changes: https://pub.dev/packages/wire_flutter

# API
### Wire (static methods):
```
Wire .add(Object scope, String signal, WireListener listener, [int replies = 0])
bool .send(String signal, [args])
bool .remove(String signal, {Object scope, WireListener listener})
bool .has({String signal, Wire wire})
void .attach(Wire wire)
bool .detach(Wire wire)
bool .purge()
void .middleware(WireMiddleware value)

WireData .data(String param, [dynamic value]) - optional value update object it can be function that return value

List<Wire> .get({String signal, Object scope, Function listener})
```

### WireListener:
```
void Function(Wire wire, dynamic data)
```

### WireData:
It is a data container to changes of which anyone can subscribe/unsubscribe. It's associated with param - string key. WireData can't be null and Wire.data(param, value) will always return WireData instance. Initial value will has null value if not present in the Wire.data call
```
WireData subscribe(Object scope, WireDataListener listener)
WireData unsubscribe(Object scope, [WireDataListener listener])
void refresh()
void remove() // emit null value before remove all subscribers, use isSet property to to distinguish between newly created (false) and removed (value still maybe be null thus isSet is false)
```

### WireDataListener
```
void Function(dynamic value)
```

### WireMiddleware
```
abstract class WireMiddleware {
  void onAdd(Wire wire);
  void onSend(String signal, [data]);
  void onRemove(String signal, [Object scope, WireListener listener]);
  void onData(String param, dynamic prevValue, dynamic nextValue);
}
```

![UML](uml/configuration.png)

Generate UML with dcdg (PlantUML): pub global run dcdg -o ./uml/configuration

## Examples
### 1. Counter (web):
- Open IDEA
- Select build target - Dart Web, point to example/counter/index.html
- Run Debug

### 2. API calls variations (console):
- Open IDEA
- Select build target - Dart Command Line App, point to example/api/wire_api_example.dart
- Run Debug

### 3. Todo MVC (web):
- Open IDEA
- Select build target - Dart Web, point to example/todo/index.html
- Run Debug

## Licence

```
Copyright 2020 Vladimir Cores (Minkin)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```


