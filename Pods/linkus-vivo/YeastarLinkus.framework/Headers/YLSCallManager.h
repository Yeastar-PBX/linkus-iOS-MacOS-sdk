//
//  YLSCallManager.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/28.
//

#import <Foundation/Foundation.h>
#import "YLSSipCall.h"

@class YLSCallManager;

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

@interface YLSCallManager : NSObject

+ (instancetype)shareCallManager;

@property (nonatomic,weak) id<CallManagerDelegate> delegate;

@property (nonatomic,strong,readonly) NSMutableArray<YLSSipCall *> *currenCallArr;

- (YLSSipCall *)currentSipCall;

- (void)callManagerDealIncomingCall:(YLSSipCall *)sipCall;

- (void)callManagerDealStatus:(YLSSipCall *)sipCall;

- (void)callManagerDealHangUp:(YLSSipCall *)sipCall;

- (YLSSipCall *)callUUID:(NSUUID *)uuid;

- (void)addDelegate:(id<CallManagerDelegate>)delegate;

- (void)removeDelegate:(id<CallManagerDelegate>)delegate;

@end
