# Wire (WIP) - Pub/Sub on Strings "signals" with data container
Dart publish-subscribe library, with static layer beneath, where responses associated with "keys" called - signals. Simplest possible API - add, remove and send.

Also it has data layer,  universal container (Map) with key-value, where value is a wrapper - WireData - hold dynamic value and can be listened for updates.

## API
Wire:
```
Wire Wire.add(Object scope, String signal, Function listener, [int replies = 0])
bool Wire.send(String signal, [args])
bool Wire.remove(String signal)
WireData Wire.data(String param, [dynamic value]) - optional value update object it can be function that return value
```
WireData:
```
void remove() // emit null value before remove all subscribers
WireData subscribe(Object scope, Function listener)
WireData unsubscribe(Object scope)
```

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

