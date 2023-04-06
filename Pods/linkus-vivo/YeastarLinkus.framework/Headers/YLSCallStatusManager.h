//
//  YLSCallStatusManager.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/28.
//

#import <Foundation/Foundation.h>
#import "YLSSipCall.h"

@class YLSCallStatusManager;

@protocol CallStatusManagerDelegate <NSObject>

@optional

/**
 *  界面消失，没有通话
 */
- (void)callStatusManagerDissmiss:(YLSCallStatusManager *)callStatusManager;

/**
 *  普通来电
 */
- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager currentCall:(YLSSipCall *)currentCall;

/**
 *  呼叫等待转移
 */
- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager currentCall:(YLSSipCall *)currentCall
              callWaiting:(YLSSipCall *)callWaitingCall transferCall:(YLSSipCall *)transferCall;

@end

@interface YLSCallStatusManager : NSObject

@property (nonatomic,strong,readonly) YLSSipCall *transferCall;

+ (instancetype)shareCallStatusManager;

- (void)callChange:(YLSSipCall *)waitingCall;

- (void)holdResetCall:(YLSSipCall *)callInfo hold:(BOOL)hold;

- (void)muteResetCall:(YLSSipCall *)callInfo mute:(BOOL)mute;

- (void)addDelegate:(id<CallStatusManagerDelegate>)delegate;

- (void)removeDelegate:(id<CallStatusManagerDelegate>)delegate;

@end
