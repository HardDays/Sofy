
#import "CustomVibrationPluginRegistrant.h"
#import <Runner-Swift.h>

@implementation CustomVibrationPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [CustomSwiftVibrationPlugin registerWithRegistrar:[registry registrarForPlugin:@"CustomSwiftVibrationPlugin"]];
}
@end
