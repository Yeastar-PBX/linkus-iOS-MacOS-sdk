//
//  YLSCallManager.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/28.
//

#import <YeastarLinkus/YLSCallProtocol.h>

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
