import UIKit
import Flutter
import Firebase
import Braintree

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    BTAppSwitch.setReturnURLScheme("com.zamzamapp.ConnectingHearts.payments")
    GeneratedPluginRegistrant.register(with: self)
    // FirebaseApp.configure()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
