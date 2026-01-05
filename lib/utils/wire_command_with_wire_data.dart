library wire;

import 'package:wire/abstract/abstract_wire_command.dart';
import 'package:wire/mixin/mixin_with_wire_data.dart';

abstract class WireCommandWithWireData<T> extends WireCommandAbstract<T> with WireMixinWithWireData {}
