## Examples

For every project in example folder you have to run `pub get` from terminal or from IDE opened `pubspec.yaml`
###### (you might need to change the port number if you want to run multiple web apps simultaneously)

### 1. Counter (web): Simple "Increase/Decrease/Output" example of Wire use 
- Open IDEA or WebStorm
- Select build target - Dart Web, 
- Set "HTML file" to: example/counter/index.html
- Run Debug

### 2. Todo MVC (web): Complex Todo application based on TodoMVC CSS
![Todo with Wire](../assets/wire_example_todo_web.gif)
- Open IDEA or WebStorm
- Select build target - Dart Web 
- Path to: example/todo/index.html
- Run Debug

In case an error like: 
```
Building package executable...
Failed to build webdev:webdev:
../../.pub-cache/hosted/pub.dartlang.org/dds-2.1.6/lib/src/cpu_samples_manager.dart:54:21: Error: Type 'CpuSamplesEvent' not found.
void cacheSamples(CpuSamplesEvent samples) {
^^^^^^^^^^^^^^^
../../.pub-cache/hosted/pub.dartlang.org/dds-2.1.6/lib/src/cpu_samples_manager.dart:54:21: Error: 'CpuSamplesEvent' isn't a type.
void cacheSamples(CpuSamplesEvent samples) {
```
Edited cpu_samples_manager.dart in ~/.pub-cache/hosted/pub.dartlang.org/dds-2.1.6/lib/src/ and remove type CpuSamplesEvent.

### 3. API calls variations (console): Possible variation of Wire API use
- Open IDEA
- Select build target - Dart Command Line App, point to example/api/wire_api_example.dart
- Run Debug

### 4. Todo with AngularDart web 
#### (**NO SUPPORT FOR NULL-SAFETY - DEPRECATED**)

![Todo with Wire](../assets/wire_example_todo_angular.gif)
- Open folder from IDEA
- Create symlink (or anchor on Windows) from "_shared" folder in "example" folder and put the link in to "todo_angular/lib/src/" folder.
- Run DartWeb configuration with index.html

### Setup in IDEA:
To run these examples import them as a module from `File -> Project Structure` in IDEA and enable Dart SDK for each from `Preferences -> Languages & Frameworks -> Dart`

![Import as module](../assets/examples-setup-import-as-a-module.png)
![Import as module](../assets/examples-setup-preferences-enable-dart.png)
