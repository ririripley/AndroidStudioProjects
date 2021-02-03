import UIKit
import Flutter
// MARK - usage in flutter
/**
 static const platform = const MethodChannel('samples.flutter.io/battery');
 String batteryLevel = 'Unknown battery level.';
  
 try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
  }
  on PlatformException catch (e)
  {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
  }
*/

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    GeneratedPluginRegistrant.register(with: self);

    
    /**
     * Dart execution, channel communication, texture registration, and plugin registration are all
     * handled by `FlutterEngine`. Calls on this class to those members all proxy through to the
     * `FlutterEngine` attached FlutterViewController.
     */
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    
    
    /**
     * The channel name logically identifies the channel; identically named channels
     * interfere with each other's communication :  "samples.flutter.io/battery"
     *
     * The binary messenger is a facility for sending raw, binary messages to the
     * Flutter side. This protocol is implemented by `FlutterEngine` and `FlutterViewController`.
     */
    // intialize a flutterMethodChannel
    /**
     * flutterMethodChannel:
     * A channel for communicating with the Flutter side using invocation of
     * asynchronous methods.
     */
    let batteryChannel = FlutterMethodChannel.init(name: "samples.flutter.io/battery",
                                                   binaryMessenger: controller as! FlutterBinaryMessenger);
    
    // `FlutterMethodChannel`, which supports communication using asynchronous method calls, can
    // implement FlutterBinaryMessenger to send binary messages
    
    
    // setMethodCallHandler:  Registers a handler for method calls from the Flutter side.
    // invokeMethod：   Invokes the specified Flutter method 
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
        
        batteryChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: FlutterResult) -> Void in
          if ("getBatteryLevel" == call.method) {
            receiveBatteryLevel(result: result);
          } else {
            result(FlutterMethodNotImplemented);
          }
        });
        
        
      // Handle battery messages.
    });

    return super.application(application, didFinishLaunchingWithOptions: launchOptions);
  }
    
}
private func receiveBatteryLevel(result: FlutterResult) {
  let device = UIDevice.current;
  device.isBatteryMonitoringEnabled = true;
    if (device.batteryState == UIDevice.BatteryState.unknown) {
    result(FlutterError.init(code: "UNAVAILABLE",
                             message: "电池信息不可用",
                             details: nil));
  } else {
    result(Int(device.batteryLevel * 100));
  }
}
