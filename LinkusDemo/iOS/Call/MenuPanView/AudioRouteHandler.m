//
//  AudioRouteHandler.m
//  Linkus
//
//  Created by 杨桂福 on 2022/11/28.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "AudioRouteHandler.h"

@implementation AudioRouteHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioRouteChangeListenerCallbackNotification:)   name:AVAudioSessionRouteChangeNotification object:nil];
        if (self.bluetoothHeadsetConnected) {
            _type = AudioRouteTypeBluetooth;
            _selected = NO;
        }else {
            AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
            for (AVAudioSessionPortDescription *desc in [route outputs]) {
                if ([[desc portType] isEqualToString:AVAudioSessionPortBuiltInSpeaker]) {
                    _type = AudioRouteTypeSpeaker;
                    _selected = YES;
                }
            }
        }
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)bluetoothHeadsetConnected {
    for (AVAudioSessionPortDescription *desc in [[AVAudioSession sharedInstance] availableInputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortBluetoothA2DP]
           || [[desc portType] isEqualToString:AVAudioSessionPortBluetoothLE]
           || [[desc portType] isEqualToString:AVAudioSessionPortBluetoothHFP]
           ) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Notification
- (void)onAudioRouteChangeListenerCallbackNotification:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable: {
            NSLog(@"耳机插入");
            [YLSPJRegister audioSendSetDev];
            [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeVoiceChat error:nil];//优化VOIP音频
        }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
            NSLog(@"耳机拔出");
            [YLSPJRegister audioSendSetDev];
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange: {//类别改变了:听筒
            NSLog(@"听筒");
            [YLSPJRegister audioSendSetDev];
        }
            break;
        case AVAudioSessionRouteChangeReasonOverride: {//App重置了输出设置:扬声器
            NSLog(@"扬声器、断开蓝牙耳机");
            [YLSPJRegister audioSendSetDev];
        }
            break;
        case AVAudioSessionRouteChangeReasonUnknown:
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
        case AVAudioSessionRouteChangeReasonRouteConfigurationChange: {
        }
            break;
    }
    
    //外设改变，同步"免提"按钮状态
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription *desc in [route outputs]) {
        NSLog(@"输出源名称：%@ 当前声道：%@",[desc portName],[desc portType]);
        if ([[desc portType] isEqualToString:AVAudioSessionPortBuiltInSpeaker]) {
            self.type = AudioRouteTypeSpeaker;
            self.selected = YES;
        } else if ([[desc portType] isEqualToString:AVAudioSessionPortBluetoothA2DP] || [[desc portType] isEqualToString:AVAudioSessionPortBluetoothLE] || [[desc portType] isEqualToString:AVAudioSessionPortBluetoothHFP]) {
            self.type = AudioRouteTypeBluetooth;
            self.selected = NO;
        } else if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            self.type = AudioRouteTypeHeadset;
            self.selected = NO;
        } else {
            if (self.videoSpeaker) {
                [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
                self.type = AudioRouteTypeSpeaker;
                self.selected = YES;
                self.videoSpeaker = NO;
            }else{
                self.type = AudioRouteTypeMic;
                self.selected = NO;
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioRouteHandlerRefresh:)]) {
            [self.delegate audioRouteHandlerRefresh:self];
        }
    });
}

@end
