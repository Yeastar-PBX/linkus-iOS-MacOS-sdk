//
//  YLSConfProtocol.h
//  linkus-sdk
//
//  Created by 杨桂福 on 2023/7/5.
//

#import <Foundation/Foundation.h>
#import "YLSCallProtocol.h"

@class YLSSipCall;
@class YLSConfCall;
@class YLSConfManager;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ConferenceError) {
    ConferenceErrorUnreachable              = 1,
    ConferenceErrorNoNetwork                = 2,
    ConferenceErrorUnknown                  = 3,
    ConferenceErrorTimeOut                  = 4,
    ConferenceErrorServer                   = 5,
    ConferenceErrorCustom                   = 6,
    ConferenceErrorIllegal                  = 7,
};

typedef NS_ENUM(NSInteger, ConferenceOperation) {
    ConferenceOperationMute                  = 1,
    ConferenceOperationUnmute                = 2,
    ConferenceOperationRemoveMember          = 3,
    ConferenceOperationMuteAllMembers        = 4,
    ConferenceOperationUnmuteAllMembers      = 5,
    ConferenceOperationClosingConference     = 6,
    ConferenceOperationRecoveryConference    = 7,
    ConferenceOperationCallAgain             = 8,
};

@protocol YLSConfManagerDelegate <NSObject>

@optional

/**
 *  会议室来电
 */
- (void)conferenceManager:(YLSConfManager *)manager
               callStatus:(YLSSipCall *)sipCall
       reportIncomingCall:(void (^)(void (^controllerBlock)(void),void (^errorBlock)(NSError * _Nullable error)))completion;

/**
 *  会议室通话状态
 */
- (void)conferenceManager:(YLSConfManager *)manager callStatus:(YLSSipCall *)sipCall;

/**
 *  会议室成员状态
 */
- (void)conferenceManager:(YLSConfManager *)manager conferenceInfo:(YLSConfCall *)confCall;

/**
 *  异常会议室
 */
- (void)conferenceManager:(YLSConfManager *)manager abnormal:(nullable YLSConfCall *)confCall;

@end

@protocol YLSConfManager <NSObject>

/**
 *  正在进行的会议室通话信息
 */
- (YLSSipCall *)currentConfSipCall;

/**
 *  创建会议室
 */
- (void)createConference:(YLSConfCall *)confCall
                complete:(void(^)(NSError * _Nullable error,NSString *confid))complete;
/**
 *  邀请成员
 */
- (void)inviteConferenceMembers:(NSArray<NSString *> *)contacts
                         confid:(NSString *)confid
                       complete:(void(^)(NSError * _Nullable error))complete;

/**
 *  操作成员
 */
- (void)operationConferenceMember:(NSString *)member
                           confid:(NSString *)confid
                    operationType:(int)type
                         complete:(void(^)(NSError * _Nullable error))complete;

/**
 *  获取会议室状态
 */
- (void)conferenceInfo:(NSString *)confid
                notify:(BOOL)notify
              complete:(void(^)(NSError * _Nullable error,NSString *meetName,NSString *host,NSString *members))complete;

/**
 *  获取异常会议室
 */
- (void)conferenceStatusComplete:(void(^)(NSError * _Nullable error,NSString *allConfid))complete;

/**
 *  会议室来电委托
 */
- (void)setIncomingCallDelegate:(id<YLSConfManagerDelegate>)delegate;

/**
 *  添加委托
 */
- (void)addDelegate:(id<YLSConfManagerDelegate>)delegate;

/**
 *  移除委托
 */
- (void)removeDelegate:(id<YLSConfManagerDelegate>)delegate;

@end

@protocol YLSConfHistoryBuildDelegate <NSObject>

/**
 *  更新会议室记录
 */
- (void)conferenceHistoryUpdate:(NSArray<YLSConfCall *> *)conferenceHistorys;

@end

@protocol YLSConfHistoryBuild <NSObject>

/**
 *  会议室记录
 */
- (NSArray<YLSConfCall *> *)conferenceHistorys;

/**
 *  删除会议室记录
 */
- (void)conferenceHistoryDelete:(YLSConfCall *)model;

/**
 *  添加委托
 */
- (void)addDelegate:(id<YLSConfHistoryBuildDelegate>)delegate;

/**
 *  移除委托
 */
- (void)removeDelegate:(id<YLSConfHistoryBuildDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
