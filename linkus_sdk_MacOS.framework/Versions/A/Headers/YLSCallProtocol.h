//
//  YLSCallManagerProtocol.h
//  linkus-vivo
//
//  Created by 杨桂福 on 2023/4/17.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@class YLSSipCall;
@class YLSCallManager;
@class YLSCaptureDevice;
@class YLSCallStatusManager;

NS_ASSUME_NONNULL_BEGIN

@protocol YLSContactProtocol <NSObject>

- (NSString *)sipName;

- (NSString *)sipNumber;

#if TARGET_OS_IPHONE
- (UIImage *)sipImage;
#endif

@end

@protocol YLSCallManagerDelegate <NSObject>

@optional

/**
 *  来电
 */
- (void)callManager:(YLSCallManager *)callManager contact:(void (^)(id<YLSContactProtocol> (^block)(NSString *number)))contact completion:(void (^)(void (^controllerBlock)(void),void (^errorBlock)(NSError * _Nullable error)))completion;

/**
 *  通话信息
 */
- (void)callManager:(YLSCallManager *)callManager callInfoStatus:(NSMutableArray<YLSSipCall *> *)currenCallArr;

/**
 *  Sip错误码
 */
- (void)callManager:(YLSCallManager *)callManager callFaild:(NSError *)error;

/**
 *  录音状态
 */
- (void)callManagerRecordType:(YLSCallManager *)callManager;

/**
 *  当前通话质量
 */
- (void)callManager:(YLSCallManager *)callManager callid:(int)callid callQuality:(BOOL)quality;

/**
 *  呼叫等待回调
 */
- (BOOL)callWaitingSupport;

@end

@protocol YLSCallManager <NSObject>

/**
 *  处理Voip推送
 */
- (void)receiveIncomingPushWithPayload:(NSDictionary *)dictionaryPayload;

/**
 *  处理Miss Call未接来电
 */
- (BOOL)didReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 *  正在进行的通话信息
 */
- (YLSSipCall *)currentSipCall;

/**
 *  所有通话信息
 */
- (NSArray<YLSSipCall *> *)currentSipCalls;

/**
 *  多方通话信息
 */
- (NSArray<YLSSipCall *> *)multiSipCalls;

/**
 *  获取MacOS 麦克风与扬声器
 */
- (NSArray<YLSCaptureDevice *> *)audioALLDevice API_AVAILABLE(macos(10.13));

/**
 *  设置MacOS 麦克风与扬声器
 */
- (void)audioSetDevice:(NSInteger)microphone speaker:(NSInteger)speaker API_AVAILABLE(macos(10.13));

/**
 *  Sip 注册状态
 */
- (BOOL)sipRegister;

/**
 *  录音功能是否可用
 */
- (BOOL)enableRecord;

/**
 *  管理员录音功能
 */
- (BOOL)adminRecord;

/**
 *  来电委托
 */
- (void)setIncomingCallDelegate:(id<YLSCallManagerDelegate>)delegate;

/**
 *  添加委托
 */
- (void)addDelegate:(id<YLSCallManagerDelegate>)delegate;

/**
 *  移除委托
 */
- (void)removeDelegate:(id<YLSCallManagerDelegate>)delegate;

@end

@protocol YLSCallStatusManagerDelegate <NSObject>

@optional

/**
 *  挂断所有通话
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
              callWaiting:(nullable YLSSipCall *)callWaitingCall transferCall:(nullable YLSSipCall *)transferCall;

/**
 *  多方通话
 */
- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager multiCall:(YLSSipCall *)multiCall
                       waitingCall:(nullable YLSSipCall *)waitingCall;

@end

@protocol YLSCallStatusManager <NSObject>

/**
 *  呼叫等待切换通话
 */
- (void)callChange:(YLSSipCall *)waitingCall;

/**
 *  添加委托
 */
- (void)addDelegate:(id<YLSCallStatusManagerDelegate>)delegate;

/**
 *  移除委托
 */
- (void)removeDelegate:(id<YLSCallStatusManagerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
