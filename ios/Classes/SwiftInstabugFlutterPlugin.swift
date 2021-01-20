import Flutter
import UIKit
import Instabug

public class SwiftInstabugPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.instabug/instabug", binaryMessenger: registrar.messenger())
    let instance = SwiftInstabugPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "start":
      let args = call.arguments as! [String]
      let token = args[0]

      var invocationEvents = 0
      if args.contains("shake") {
        invocationEvents |= IBGInvocationEvent.shake.rawValue
      }
      if args.contains("floatingButton") {
        invocationEvents |= IBGInvocationEvent.floatingButton.rawValue
      }
      if args.contains("screenshot") {
        invocationEvents |= IBGInvocationEvent.screenshot.rawValue
      }
      if args.contains("twoFingerSwipeLeft") {
        invocationEvents |= IBGInvocationEvent.twoFingersSwipeLeft.rawValue
      }

      if invocationEvents == 0 {
        invocationEvents = IBGInvocationEvent.none.rawValue
      }

      Instabug.start(withToken: token, invocationEvents: IBGInvocationEvent(rawValue: invocationEvents))
      result(nil)
      break;
    case "identifyUser":
      let args = call.arguments as! [String?]
      let name = args[0] ?? ""
      let email = args[1] ?? ""

      Instabug.identifyUser(withEmail: email, name: name)
      result(nil)
      break;
    case "setWelcomeMessageMode":
      let mode = call.arguments as! String
      if mode == "live" {
        Instabug.welcomeMessageMode = .live
      } else if mode == "beta" {
        Instabug.welcomeMessageMode = .beta
      } else if mode == "disabled" {
        Instabug.welcomeMessageMode = .disabled
      }
      result(nil)
      break;
    case "showWelcomeMessage":
      let mode = call.arguments as! String
      if mode == "live" {
        Instabug.showWelcomeMessage(with: .live)
      } else if mode == "beta" {
        Instabug.showWelcomeMessage(with: .beta)
      } else if mode == "disabled" {
        Instabug.showWelcomeMessage(with: .disabled)
      }
      result(nil)
      break;
    case "setBrightness":
      let brightness = call.arguments as! String
      if brightness == "dark" {
        Instabug.setColorTheme(.dark)
      } else if brightness == "light" {
        Instabug.setColorTheme(.light)
      }
      result(nil)
      break;
    case "setPrimaryColor":
      let color = call.arguments as! [CGFloat]
      let color2 = UIColor(red: color[1], green: color[2], blue: color[3], alpha: color[0])
      Instabug.tintColor = color2
      result(nil)
      break;
    case "setInAppNotificationEnabled":
      Replies.inAppNotificationsEnabled = call.arguments as! Bool
      result(nil)
      break;
    case "setLocale":
      Instabug.setLocale(.english)
      result(nil)
      break;
    case "logOut":
      Instabug.logOut()
      result(nil)
      break;
    case "show":
      Instabug.show()
      result(nil)
      break;
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
