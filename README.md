# Wire (WIP) - Pub/Sub on Strings "signals" with data container
Dart pub/sub library - communication layer (or bus) where responses associated with "keys" called - signals. Simplest possible API - add, remove and send.

Also it has data layer,  universal container (Map) with key-value, where value is a wrapper - WireData - hold dynamic value and can be subscribed for updates, something like Redis.

## API
Wire:
```
Wire Wire.add(Object scope, String signal, WireListener listener, [int replies = 0])
bool Wire.send(String signal, [args])
bool Wire.remove(String signal, {Object scope, WireListener listener})
WireData Wire.data(String param, [dynamic value]) - optional value update object it can be function that return value
```
`WireListener = void Function(Wire wire, dynamic data)`

WireData:
```
void remove() // emit null value before remove all subscribers, use isSet property to to distinguish between newly created (false) and removed (value still maybe be null thus isSet is false)
WireData subscribe(Object scope, WireDataListener listener)
WireData unsubscribe(Object scope, [WireDataListener listener])
```
`WireDataListener = void Function(dynamic value)`

![UML](uml/configuration.png)

Generate UML with dcdg (PlantUML): pub global run dcdg -o ./uml/configuration

## Examples
1. Counter (web):
- Open IDEA
- Select build target - Dart Web, point to example/counter/index.html
- Run Debug

2. API calls variations (console):
- Open IDEA
- Select build target - Dart Command Line App, point to example/api/wire_api_example.dart
- Run Debug

3. Todo MVC (web):
- Open IDEA
- Select build target - Dart Web, point to example/todo/index.html
- Run Debug

##Licence

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


