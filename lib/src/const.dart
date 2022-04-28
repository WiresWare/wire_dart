part of wire;

final String ERROR__WIRE_ALREADY_REGISTERED =
    'WR:1001 - Wire already registered, wireId: ';

final String ERROR__MIDDLEWARE_EXISTS =
    'WR:2001 - Middleware already registered, middleware: ';

final String ERROR__LISTENER_IS_NULL =
    'WR:3000 - Listener is null';
final String ERROR__DATA_IS_LOCKED =
    'WR:3001 - WireData value change not allowed '
    '- data modification locked with token';
final String ERROR__DATA_ALREADY_LOCKED =
    'WR:3002 - WireData already locked with token'
    ' - call unlock method first with proper token';
final String ERROR__DATA_CANNOT_BE_OPEN =
    'WR:3002 - WireData tokens do not match'
    ' - to unlock data for modification use proper token';
final String ERROR__DATA_IS_GETTER =
    'WR:3003 - WireData is a getter'
    ' - it cannot be modified only accessed' ;
final String ERROR__VALUE_IS_NOT_ALLOWED_TOGETHER_WITH_GETTER =
    'WR:3004 - WireData is a getter'
    ' - setting value together with getter is not allowed' ;

final String ERROR__CANT_PUT_ALREADY_EXISTING_INSTANCE =
    'WR:4001 - Cant put already existing instance (unlock first)';
final String ERROR__CANT_FIND_INSTANCE_NULL =
    'WR:4002 - Cant find instance its not set';
