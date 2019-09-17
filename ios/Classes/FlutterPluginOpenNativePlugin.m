#import "FlutterPluginOpenNativePlugin.h"
#import "AndroidTextView.h"
@implementation FlutterPluginOpenNativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    [registrar registerViewFactory:[[FlutterAndroidTextViewFactory alloc] initWithMessenger:registrar.messenger] withId:@"me.chunyu.textview/textview"];
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_plugin_open_native"
                                     binaryMessenger:[registrar messenger]];
    FlutterPluginOpenNativePlugin* instance = [[FlutterPluginOpenNativePlugin alloc] init];
    
    [registrar addMethodCallDelegate:instance channel:channel];
    
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    }
    else if([@"openOSView" isEqualToString:call.method]){
        NSString * phoneUri = call.arguments;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUri]];
    }
    
    else {
        result(FlutterMethodNotImplemented);
    }
}

@end
