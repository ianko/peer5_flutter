import Flutter
import UIKit
import Peer5Kit

public class SwiftPeer5Plugin: NSObject, FlutterPlugin {
  private var sdk: Peer5Sdk?;

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.ianko/peer5",
      binaryMessenger: registrar.messenger())

    let instance = SwiftPeer5Plugin()

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "init":
      let token: String? = (call.arguments as? [String: Any])?["token"] as? String
      sdk = Peer5Sdk.init(token: token!)
      result(nil)
    case "streamUrl":
      let urlString: String? = (call.arguments as? [String: Any])?["url"] as? String

      guard let unwrappedURLString = urlString,
        let url = URL.init(string: unwrappedURLString)
      else {
        result(invalidURLError(urlString))
        return
      }
      result(sdk?.streamURL(forURL: url).absoluteString)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

/// Returns an error for the case where a URL string can't be parsed as a URL.
private func invalidURLError(_ url: String?) -> FlutterError {
  return FlutterError(
    code: "argument_error",
    message: "Unable to parse URL",
    details: "Provided URL: \(String(describing: url))")
}
