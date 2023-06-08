//
//  CallProvider.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//

#import "CallProvider.h"
#import "Contact.h"
#import "CallViewController.h"

@interface CallProvider ()<YLSCallManagerDelegate>

@end

@implementation CallProvider

+ (instancetype)shareCallProvider {
    static CallProvider *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CallProvider alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[[YLSSDK sharedYLSSDK] callManager] setIncomingCallDelegate:self];
    }
    return self;
}

#pragma mark - CallManagerDelegate来电
- (void)callManager:(YLSCallManager *)callManager contact:(void (^)(id<YLSContactProtocol> (^block)(NSString *number)))contact completion:(void (^)(void (^controllerBlock)(void),void (^errorBlock)(NSError *error)))completion {
    contact((id)^(NSString *number){
        Contact *model = [[Contact alloc] init];
        model.name = number;
        return model;
    });
    completion(^(void){
        UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:[[CallViewController alloc] init]];
        mainNav.modalPresentationStyle = UIModalPresentationFullScreen;
        [TopestViewController presentViewController:mainNav animated:NO completion:nil];
    },^(NSError *error){
        //提示用户来电失败的原因，例如系统免打扰、黑名单等
        NSLog(@"发起callKit失败，状态码是：%@ (Code: 0.Unkonwn 1.Unentitled 2.CallUUIDAlreadyExists, 3.DND, 4.BlockList)",error);
    });
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
    [TopestViewController showHUDErrorWithText:text];
}

#pragma mark - 发起通话
+ (void)baseCallByNumber:(NSString *)number {
    YLSSipCall *sipCall = [[YLSSipCall alloc] init];
    sipCall.callNumber = number;
    Contact *model = [[Contact alloc] init];
    model.name = number;
    sipCall.contact = model;
    
    if ([CallProvider shareCallProvider].dialCallType == DialCallTypeBlind) {
        [[YSLCallTool shareCallTool] tranforBlind:sipCall];
    }else {
        [[YSLCallTool shareCallTool] startCall:sipCall completion:^(NSError *error) {
            if (!error) {
                dispatch_async_main_safe(^ {
                    //通话界面点击"转移"按钮，在“转移”界面选择”通讯录“,选择联系人拨打的时候需退回到通话界面
                    BOOL find = NO;
                    for (UIViewController *vc in TopestNavigationController.viewControllers) {
                        if ([vc isKindOfClass:[CallViewController class]]) {
                            find = YES;
                            CallViewController *audioVC = (CallViewController *)vc;
                            [TopestNavigationController popToViewController:audioVC animated:YES];
                        }
                    }
                    if (!find) {
                        CallViewController *audioCall = [[CallViewController alloc] init];
                        UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:audioCall];
                        mainNav.modalPresentationStyle = UIModalPresentationFullScreen;
                        [TopestViewController presentViewController:mainNav animated:YES completion:nil];
                    }
                })
            }else{
                NSLog(@"创建通话失败 Error requesting transaction: %@",error);
            }
        }];
    }
    [CallProvider shareCallProvider].dialCallType = DialCallTypeNormal;
}

@end
