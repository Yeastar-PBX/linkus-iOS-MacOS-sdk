//
//  MacCallProvider.m
//  LinkusDemo (macOS)
//
//  Created by 杨桂福 on 2023/4/25.
//

#import "MacCallProvider.h"

@interface MacCallProvider ()<YLSCallManagerDelegate, YLSCallStatusManagerDelegate, YLSLoginManagerDelegate>

@end

@implementation MacCallProvider

+ (instancetype)shareCallProvider {
    static MacCallProvider *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MacCallProvider alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[[YLSSDK sharedYLSSDK] callManager] addDelegate:self];
        [[[YLSSDK sharedYLSSDK] callManager] setIncomingCallDelegate:self];
        [[[YLSSDK sharedYLSSDK] callStatusManager] addDelegate:self];
        [[[YLSSDK sharedYLSSDK] loginManager] addDelegate:self];
    }
    return self;
}

#pragma mark - YLSCallManagerDelegate来电
- (void)callManager:(YLSCallManager *)callManager contact:(void (^)(id<YLSContactProtocol> (^block)(NSString *number)))contact completion:(void (^)(void (^controllerBlock)(void),void (^errorBlock)(NSError *error)))completion {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.delegate popCallView];
    });
}

- (BOOL)callWaitingSupport {
    return NO;
}

#pragma mark - YLSCallStatusManagerDelegate
- (void)callStatusManagerDissmiss:(YLSCallStatusManager *)callStatusManager {
    [self.delegate dismissCallView];
}

- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager currentCall:(YLSSipCall *)currentCall {
    [self.delegate reloadCurrentCall:currentCall];
}

- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager currentCall:(YLSSipCall *)currentCall callWaiting:(YLSSipCall *)callWaitingCall transferCall:(YLSSipCall *)transferCall {
    [self.delegate reloadCurrentCall:currentCall];
}

#pragma mark - YLSLoginManagerDelegate
- (void)onKickStep:(KickReason)code {
    NSLog(@"Login information expired. Please log in again. (%ld)",code);
    [[[YLSSDK sharedYLSSDK] loginManager] logout:^(NSError * _Nullable error) {
        [self.delegate loginOut];
    }];
}

@end
