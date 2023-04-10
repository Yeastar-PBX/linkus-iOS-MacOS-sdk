//
//  YLSCallStatusManager.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/28.
//

#import <linkus_vivo/YLSCallProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLSCallStatusManager : NSObject

@property (nonatomic,strong,readonly) YLSSipCall *transferCall;

+ (instancetype)shareCallStatusManager;

- (void)callChange:(YLSSipCall *)waitingCall;

- (void)holdResetCall:(YLSSipCall *)callInfo hold:(BOOL)hold;

- (void)muteResetCall:(YLSSipCall *)callInfo mute:(BOOL)mute;

- (void)addDelegate:(id<CallStatusManagerDelegate>)delegate;

- (void)removeDelegate:(id<CallStatusManagerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
