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
        [[[YLSSDK sharedYLSSDK] callManager] addDelegate:self];
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
        CallViewController *audioCall = [[CallViewController alloc] init];
        UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:audioCall];
        [TopestViewController presentViewController:mainNav animated:NO completion:nil];
    },^(NSError *error){
        //提示用户来电失败的原因，例如系统免打扰、黑名单等
        NSLog(@"发起callKit失败，状态码是：%@ (Code: 0.Unkonwn 1.Unentitled 2.CallUUIDAlreadyExists, 3.DND, 4.BlockList)",error);
    });
}

#pragma mark - 发起通话
+ (void)baseCallByNumber:(NSString *)number {
    YLSSipCall *sipCall = [[YLSSipCall alloc] init];
    sipCall.call_num = number;
    sipCall.call_ID = DefaultSipCallID;
    sipCall.call_in = NO;
    sipCall.status = CallStatusConnect; //CallStatusConnect;
    sipCall.linkedid = nil;
    Contact *model = [[Contact alloc] init];
    model.name = number;
    sipCall.contact = model;
    
    [[CallTool shareCallTool] startCall:sipCall completion:^(NSError *error) {
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

@end
