#import "InstabugFlutterPlugin.h"
#if __has_include(<instabug_flutter/instabug_flutter-Swift.h>)
#import <instabug_flutter/instabug_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "instabug_flutter-Swift.h"
#endif

@implementation InstabugFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInstabugFlutterPlugin registerWithRegistrar:registrar];
}
@end
