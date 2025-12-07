import 'package:flutter/material.dart';
import 'package:project_mobile/services/notification_service.dart';

class LifecycleManager extends StatefulWidget {
  final Widget child;

  const LifecycleManager({super.key, required this.child});

  @override
  State<LifecycleManager> createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends State<LifecycleManager> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      NotificationService().cancelScheduledRetention();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      NotificationService().scheduleAppClosedNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}