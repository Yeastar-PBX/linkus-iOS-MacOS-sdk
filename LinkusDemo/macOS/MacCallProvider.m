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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate popCallView];
    });
}

- (BOOL)callWaitingSupport {
    return NO;
}

- (void)callManager:(YLSCallManager *)callManager callFaild:(NSError *)error {
    NSString *text = @"";
    switch (error.code) {
        case 488:{
            text = @"Not acceptable here";
        }
            break;
        case 486:{
            text = @"The person you have called is busy. Please try again later.";
        }
            break;
        case 408:{
            text = @"Request Timeout";
        }
            break;
        case 480:{
            text = @"The person you have called is not answering. Please try again later.";
        }
            break;
        case 484:{
            text = @"Invalid Number";
        }
            break;
        case 403:{
            text = @"Forbidden";
        }
            break;
        case 400:{
            text = @"Bad request";
        }
            break;
        case 404:
        case 603:{
            text = @"You have dialed a wrong number.";
        }
            break;
        case 502:{
            text = @"Unable to connect to Internet. Please check your Internet connection.";
        }
            break;
        case 503:{
            text = @"All lines are busy now. Please try again later.";
        }
            break;
        case 402:
        case 405:
        case 406:
        case 407:
        case 413:
        case 414:
        case 415:
        case 416:
        case 420:
        case 421:
        case 423:
        case 481:
        case 482:
        case 483:
        case 485:
        case 491:
        case 493:
        case 500:
        case 501:
        case 504:
        case 505:
        case 513:
        case 600:
        case 604:
        case 606: {
            text = [NSString stringWithFormat:@"%ld%@",(long)error.code,@"Unknown"];
        }
            break;
        default:
            break;
    }
    NSLog(@"%@",text);
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
