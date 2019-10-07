# Wire
Dart publish-subscribe library, with static layer beneath, where responses associated with "keys" called - signals. Simplest possible API - add, remove and send.

```
const String
    SIGNAL_1 = "signal_1",
    SIGNAL_ONCE = "signal_1_ONCE",
    SIGNAL_2 = "signal_2";
    
  /// SUBSCRIBER EXAMPLE ======================================
  Wire.add(SIGNAL_1, (data) {
    print("> signal 1 (subscriber 1) -> Hello: " + data);
  });

  Wire.add(SIGNAL_1, (data) {
    print("> signal 1 (subscriber 2) -> Hello: " + data);
  });

  Wire.send(SIGNAL_1, "World");
  Wire.send(SIGNAL_1, "Dart");
  Wire.send(SIGNAL_1, "Vladimir");
  Wire.remove(SIGNAL_1);
  /// SUBSCRIBER END =========================================

  /// ONCE EXAMPLE ===========================================
  Wire.add(SIGNAL_ONCE, (data) {
    print("> signal 1 (limit 1) -> Goodbye: " + data);
  }, 1);

  print("\tNo ends: " + Wire.send(SIGNAL_ONCE, "World").toString());
  print("\tNo ends: " + Wire.send(SIGNAL_ONCE, "Dart").toString());
  print("\tNo ends: " + Wire.send(SIGNAL_ONCE, "Vladimir").toString());
  /// ONCE END ===============================================

  Wire.add(SIGNAL_2, (data) {
    print("> signal 2 -> I do: " + data);
  });

  Wire.add(SIGNAL_2, (data) {
    print("> signal 2 (limit 2) -> I do: " + data);
  }, 2);

  print("\tNo ends: " + Wire.send(SIGNAL_2, "Code").toString());
  print("\tNo ends: " + Wire.send(SIGNAL_2, "Gym").toString());
  print("\tNo ends: " + Wire.send(SIGNAL_2, "Eat (sometimes)").toString());
  print("\tNo ends: " + Wire.send(SIGNAL_2, "Sleep").toString());
  print("\tNo ends: " + Wire.send(SIGNAL_2, "Repeat").toString());
  ```
