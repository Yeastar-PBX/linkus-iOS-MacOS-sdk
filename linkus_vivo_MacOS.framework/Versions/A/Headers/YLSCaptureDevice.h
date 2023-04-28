//
//  YLSCaptureDevice.h
//  linkus-vivo
//
//  Created by 杨桂福 on 2023/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DeviceType) {
    DeviceTypeMicrophone = 0, //麦克风
    DeviceTypeSpeaker    = 1, //扬声器
};

@interface YLSCaptureDevice : NSObject

@property (nonatomic,copy) NSString *deviceName;

@property (nonatomic,assign) NSInteger devid;

@property (nonatomic,assign) DeviceType type;

@end

NS_ASSUME_NONNULL_END
