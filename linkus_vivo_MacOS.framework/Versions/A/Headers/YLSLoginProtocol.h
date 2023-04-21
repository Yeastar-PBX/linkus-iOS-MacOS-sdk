//
//  YLSLoginManagerProtocol.h
//  linkus-vivo
//
//  Created by 杨桂福 on 2023/4/17.
//

#import <Foundation/Foundation.h>

@class YLSHistory;

NS_ASSUME_NONNULL_BEGIN

/**
 *  被踢下线的原因
 */
typedef NS_ENUM(NSInteger, KickReason) {
    KickReasonByDefault                  = 0,
    KickReasonByPasswordChange           = 1,
    KickReasonByNOPERMISSIONS            = 2,
    KickReasonByOtherUserLogin           = 3,
    KickReasonByLoginModeChange          = 4,
    KickReasonByLCSServerDisabled        = 5,
    KickReasonByLCSServerExpires         = 6,
    KickReasonByLCSServerTimeException   = 7,
    KickReasonByDeleteExtension          = 8,
    KickReasonByLoginEmailChange         = 9,
    KickReasonByRASServerDisabled        = 10,
    KickReasonByRASServerExpires         = 11,
    KickReasonByAllowedCountryIp         = 12,
    KickReasonByDeviceInactive           = 13,
};

/**
 *  登录状态
 */
typedef NS_ENUM(NSInteger, LoginStep) {
    LoginStepLogining      = 0,
    LoginStepLoginSuccess  = 1,
    LoginStepLoginFail     = 2,
};

@protocol YLSLoginManagerDelegate <NSObject>

@optional

- (void)onLoginStep:(LoginStep)step;

- (void)onKickStep:(KickReason)code;

@end

@protocol YLSLoginManager <NSObject>

/**
 *  登录
 */
- (void)login:(NSString *)account token:(NSString *)token
   pbxAddress:(NSString *)address completion:(void (^)(NSError * _Nullable error))completion;

/**
 *  自动登录
 */
- (void)autoLogin;

/**
 *  登出
 */
- (void)logout:(void (^)(NSError * _Nullable error))completion;

@end


@protocol YLSHistoryManagerDelegate <NSObject>

@optional

/**
 *  历史记录变更
 */
- (void)historyReload:(NSMutableArray<YLSHistory *> *)historys;

/**
 *  未接来电数量变更
 */
- (void)historyMissCallCount:(NSInteger)count;

@end

@protocol YLSHistoryManager <NSObject>

/**
 *  历史记录信息
 */
- (NSArray<YLSHistory *> *)historys;

/**
 *  删除历史记录
 */
- (void)historyManagerRemove:(NSArray<YLSHistory *> *)historys;

/**
 *  删除所有历史记录
 */
- (void)historyManagerRemoveAll;

/**
 *  标记已读
 */
- (void)checkMissedCalls;

/**
 *  添加委托
 */
- (void)addDelegate:(id<YLSHistoryManagerDelegate>)delegate;

/**
 *  移除委托
 */
- (void)removeDelegate:(id<YLSHistoryManagerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
