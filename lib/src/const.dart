part of wire;

final String ERROR__MIDDLEWARE_EXISTS =
  'WR:2001 - Middleware already registered, middleware: ';
final String ERROR__WIRE_ALREADY_REGISTERED =
  'WR:1001 - Wire already registered, wireId: ';
final String ERROR__DATA_PROTECTED =
  'WR:3001 - WireData value change not allowed '
    '- data modification protected with token';
final String ERROR__DATA_ALREADY_CLOSED =
  'WR:3002 - WireData already protected with toke'
    ' - call open method first with proper token';
final String ERROR__DATA_CANNOT_OPEN =
    'WR:3002 - WireData tokens do not match'
    ' - to open data for modification use proper token';
