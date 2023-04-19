//
//  AppDelegate.m
//  Linkus
//
//  Created by 杨桂福 on 2023/3/19.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CalllogsViewController.h"
#import "CallProvider.h"
#import <PushKit/PushKit.h>
#import <UserNotifications/UserNotifications.h>

NSString *NotificationLogout = @"NotificationLogout";

@interface AppDelegate () <PKPushRegistryDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    [CallProvider shareCallProvider];
    [[YLSSDK sharedYLSSDK] initApp];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"EVER_LOGIN"]) {
        [[[YLSSDK sharedYLSSDK] loginManager] autoLogin];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CalllogsViewController alloc] init]];
    }else{
        self.window.rootViewController = [[LoginViewController alloc] init];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:NotificationLogout object:nil];
    
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_global_queue(0, 0)];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    return YES;
}

- (void)logout:(NSNotification *)note {
    self.window.rootViewController = [[LoginViewController alloc] init];
}

#pragma mark - 远程通知(推送)回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[YLSSDK sharedYLSSDK] updateApnsToken:deviceToken];
}

#pragma mark - PKPushRegistryDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type {
    if ([type isEqualToString:PKPushTypeVoIP]) {
        NSData *tokenData = credentials.token;
        [[YLSSDK sharedYLSSDK] updatePushKitToken:tokenData];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void(^)(void))completion {
    NSDictionary *dic = payload.dictionaryPayload[@"custom"];
    
    YLSSipCall *sipCall = [[YLSSipCall alloc] init];
//    sipCall.call_num = dic[@"Caller"];
//    sipCall.call_ID = DefaultSipCallID;
////    sipCall.callPrefix = nil;
//    sipCall.call_in = YES;
//    sipCall.status = CallStatusConnect;
//    sipCall.linkedid = dic[@"Linkedid"];
//    sipCall.serverName = @"Name";
//
//    
//    sipCall.startTimeStamp = dic[@"starttimestamp"];
    
//    PushModel *infoClear = [PushModel yy_modelWithJSON:payload.dictionaryPayload[@"clearpush"]];
//    DDLogInfo(@"pushRegistry %@", payload.dictionaryPayload[@"clearpush"]);
//
//    if (infoClear.clearuser.length > 0 && (![infoClear.clearuser isEqualToString:[LoginManager sharedLoginManager].userNumber] || ![info.serverSN isEqualToString:[ServerInformation sharedServerInformation].serverSN] || ![LoginManager sharedLoginManager].isLogined)) {
//        [LoginManager clearPushFlag:infoClear.localaddr remoteAddress:infoClear.externaladdr lcsAddress:infoClear.lcs extension:infoClear.clearuser];
//        callInfo.hangUpType = HangUpTypeByHand;
//    }else{
//        //保活、发起注册登录
//        [[NetWorkStatusObserver sharedNetWorkStatusObserver] applicationReceivePush];
//    }
//
//    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
//        if ([info.pushType isEqualToString:@"NewCall"]) {
//            [[CallManager shareCallManager] callManagerDealIncomingCall:callInfo];
//        } else if ([info.pushType isEqualToString:@"Conference"]) {
//            if (info.confId > 0) {
//                ConferenceInfo *model = [[ConferenceInfo alloc] init];
//                model.confid = info.confId;
//                model.host   = [[info.confInfo componentsSeparatedByString:@"="] lastObject];
//                model.meetname = info.confName;
//                model.datetime = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
//                model.inviteMembers = [NSMutableArray arrayWithArray:[info.confMemberInfo componentsSeparatedByString:@"-"]];
//                callInfo.conferece = model;
//                [[ConferenceManager shareConferenceManager] conferenceManagerDealIncomingCall:callInfo];
//            } else {
//                [[CallManager shareCallManager] callManagerDealIncomingCall:callInfo];
//            }
//        }
//    } else {
//        DDLogInfo(@"过滤前台推送");
//    }
//
    completion();
}

@end
