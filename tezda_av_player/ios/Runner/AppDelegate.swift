import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      
      guard let pluginRegistrar = self.registrar(forPlugin: "plugin-name") else { return false }

      let FLNativefactory = FLNativeViewFactory(messenger: pluginRegistrar.messenger())
      pluginRegistrar.register(
          FLNativefactory,
          withId: "<platform-view-type>")
          print("factory registered")
      
      let VideoPluginFactory = NativeVideoPlayerViewFactory(messenger: pluginRegistrar.messenger())
      pluginRegistrar.register(
        VideoPluginFactory,
        withId: NativeVideoPlayerViewFactory.id)
        print("native factory registered")

       
   
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
