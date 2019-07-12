import 'package:event_bus/event_bus.dart';
class LoginEvent{
  var isLogin;
  static EventBus eventBus = new EventBus();
  LoginEvent(this.isLogin);
}