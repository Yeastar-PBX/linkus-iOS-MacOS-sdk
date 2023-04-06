//
//  AudioRouteHandler.h
//  Linkus
//
//  Created by 杨桂福 on 2022/11/28.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AudioRouteType) {
    AudioRouteTypeMic        = 0,
    AudioRouteTypeSpeaker    = 1,
    AudioRouteTypeBluetooth  = 2,
    AudioRouteTypeHeadset    = 3,
};

@class AudioRouteHandler;

@protocol AudioRouteHandlerDelegate <NSObject>

@optional

- (void)audioRouteHandlerRefresh:(AudioRouteHandler *)handler;

@end

@interface AudioRouteHandler : NSObject

@property (nonatomic,weak) id<AudioRouteHandlerDelegate> delegate;

@property (nonatomic,assign) AudioRouteType type;

@property (nonatomic,assign) BOOL bluetoothHeadsetConnected;

@property (nonatomic,assign) BOOL selected;

@property (nonatomic,assign) BOOL videoSpeaker;

@end
