part of wire;

final String ERROR__MIDDLEWARE_EXISTS =
  'WR:2001 - Middleware already registered, middleware: ';
final String ERROR__WIRE_ALREADY_REGISTERED =
  'WR:1001 - Wire already registered, wireId: ';
final String ERROR__DATA_IS_LOCKED =
  'WR:3001 - WireData value change not allowed '
    '- data modification locked with token';
final String ERROR__DATA_ALREADY_LOCKED =
  'WR:3002 - WireData already locked with token'
    ' - call unlock method first with proper token';
final String ERROR__DATA_CANNOT_BE_OPEN =
  'WR:3002 - WireData tokens do not match'
    ' - to unlock data for modification use proper token';
