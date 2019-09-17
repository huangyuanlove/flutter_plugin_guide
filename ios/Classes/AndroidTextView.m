//
//  AndroidTextView.m
//  flutter_plugin_open_native
//
//  Created by huangyuan on 2019/9/16.
//

#import "AndroidTextView.h"

@implementation FlutterAndroidTextViewFactory{
    NSObject<FlutterBinaryMessenger>*_messenger;
}


- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    AndroidTextView * androidTextView = [[AndroidTextView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    
    return androidTextView;
    
}

@end


@implementation AndroidTextView{
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    UILabel * _label;
    
}

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([super init]) {
        
        
        NSLog(@"进行初始化 initWithWithFrame");
        
        _label = [[UILabel alloc] init];
        
        
        _label.textColor = UIColor.redColor;
        _label.backgroundColor = UIColor.blueColor;

        _label.font = [UIFont fontWithName:@"Arial" size:30];
        
        
        _viewId = viewId;
        NSString* channelName =  @"me.chunyu.textview/textview";
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
        
    }
    
    return self;
}

-(UIView *)view{
    NSLog(@"invoke view()");
    return _label;
    
}

-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    
    
    if ([[call method] isEqualToString:@"setText"]) {
        _label.text = [call arguments];
        NSLog(@"%@", call.arguments);
    }
}

@end
