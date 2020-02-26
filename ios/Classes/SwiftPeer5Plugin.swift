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
      result(initialize())
    case "streamUrl":
      let url: String? = (call.arguments as? [String: Any])?["url"] as? String
      result(streamURL(url))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func initialize() -> Any? {
    /// sdk was already initialized
    if (sdk != nil) {
      return nil
    }

    /// get the token from the Info.plist
    let token = Bundle.main.object(forInfoDictionaryKey: "Peer5ApiKey") as? String

    if (token == nil) {
      return FlutterError(
        code: "argument_error",
        message: "Peer5ApiKey not found in the Info.plist",
        details: "Please refer to the Flutter Peer5 plugin documentation on how to add the Peer5ApiKey to your app's Info.plist")
    }

    /// init the local server
    sdk = Peer5Sdk.init(token: token!)
    return nil
  }

  private func streamURL(_ urlString: String?) -> Any? {
    if (sdk == nil) {
      return FlutterError(
        code: "initialization_error",
        message: "Peer5 server was not initialized",
        details: "You need to call Peer5.init() before calling the getStreamUrl() function.")
    }

    guard let unwrappedURLString = urlString,
      let url = URL.init(string: unwrappedURLString)
    else {
      return invalidURLError(urlString)
    }

    let streamURL = sdk?.streamURL(forURL: url)
    return streamURL?.absoluteString
  }
}

/// Returns an error for the case where a URL string can't be parsed as a URL.
private func invalidURLError(_ url: String?) -> FlutterError {
  return FlutterError(
    code: "argument_error",
    message: "Unable to parse URL",
    details: "Provided URL: \(String(describing: url))")
}
