//
//  YLSContactProtocol.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YLSSipCall;
@class YLSCallManager;
@class YLSCallStatusManager;
@class YLSPJRegister;

@protocol YLSContactProtocol <NSObject>

- (NSString *)sipName;

- (UIImage *)sipImage;

@end

@protocol CallManagerDelegate <NSObject>

@optional

//系统来电
- (void)callManager:(YLSCallManager *)callManager systemCall:(BOOL)systemCall;

//来电
- (void)callManager:(YLSCallManager *)callManager contact:(void (^)(id<YLSContactProtocol> (^block)(NSString *number)))contact completion:(void (^)(void (^controllerBlock)(void),void (^errorBlock)(NSError *error)))completion;

//通话状态
- (void)callManager:(YLSCallManager *)callManager callInfoStatus:(NSMutableArray<YLSSipCall *> *)currenCallArr;

//录音状态
- (void)callManagerRecordType:(YLSCallManager *)callManager;

@end


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
              callWaiting:(nullable YLSSipCall *)callWaitingCall transferCall:(nullable YLSSipCall *)transferCall;

@end


@protocol PJRegisterDelegate <NSObject>

@optional

/**
 *  通话质量回调
 *  @param quality  Yes 差   No 好
 *  @discussion 通话质量变化每三秒调用一次
 */
- (void)pjRegister:(YLSPJRegister *)pjRegister callid:(int)callid callStatus:(BOOL)quality;

@end

NS_ASSUME_NONNULL_END
