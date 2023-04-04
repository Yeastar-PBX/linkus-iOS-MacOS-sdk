//
//  LoginAutoObserver.h
//  Linkus
//
//  Created by 杨桂福 on 2023/3/14.
//

#import <Foundation/Foundation.h>

/**
 *  网络类型
 */
typedef NS_ENUM(NSInteger, NetWorkStatus) {
    NetWorkStatusWWAN = 2,
    NetWorkStatusWifi = 3,
    NetWorkStatusNone = 4,
};

/**
 *  网络协议
 */
typedef NS_ENUM(NSInteger, NetWorkProtocol) {
    NetWorkProtocolNone  = 0,
    NetWorkProtocolIPV4  = 1,
    NetWorkProtocolIPV6  = 2,
};

@interface NetWorkStatusObserver : NSObject

/**
 *  获取登录实例
 */
+ (instancetype)sharedNetWorkStatusObserver;

- (void)startMonitoring;

- (void)stopMonitoring;

- (void)applicationReceivePush;

@end
