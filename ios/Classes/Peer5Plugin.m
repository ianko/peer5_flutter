#import "Peer5Plugin.h"
#if __has_include(<peer5/peer5-Swift.h>)
#import <peer5/peer5-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "peer5-Swift.h"
#endif

@implementation Peer5Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPeer5Plugin registerWithRegistrar:registrar];
}
@end
