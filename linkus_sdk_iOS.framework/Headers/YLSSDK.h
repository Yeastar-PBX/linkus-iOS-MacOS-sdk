//
//  YLSSDK.h
//  linkus-vivo
//
//  Created by 杨桂福 on 2023/4/13.
//

#import <Foundation/Foundation.h>
#import "YLSLoginProtocol.h"
#import "YLSCallProtocol.h"
#import "YLSConfProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLSSDK : NSObject

/**
 *  登录管理类 负责登录,注销和相关操作的通知收发
 */
@property (nonatomic,strong,readonly)   id<YLSLoginManager> loginManager;

/**
 *  通话管理类,负责来电,录音状态和通话质量
 */
@property (nonatomic,strong,readonly)   id<YLSCallManager> callManager;

/**
 *  通话状态管理类,负责挂断、呼叫等待、转移展示
 */
@property (nonatomic,strong,readonly)   id<YLSCallStatusManager> callStatusManager;

/**
 *  会议室管理类,负责发起、邀请、结束
 */
@property (nonatomic,strong,readonly)   id<YLSConfManager> confManager;

/**
 *  通话记录
 */
@property (nonatomic,strong,readonly)   id<YLSHistoryManager> historyManager;

+ (instancetype)sharedYLSSDK;

- (void)initApp;

/**
 *  更新 PushKit Token
 */
- (void)updatePushKitToken:(NSData *)token;

/**
 *  更新APNS Token
 */
- (void)updateApnsToken:(NSData *)token;

@end

NS_ASSUME_NONNULL_END
