//
//  AppDelegate.m
//  Linkus
//
//  Created by 杨桂福 on 2023/3/19.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TabBarController.h"
#import "CallProvider.h"
#import <PushKit/PushKit.h>
#import <UserNotifications/UserNotifications.h>

NSString *NotificationLogout = @"NotificationLogout";

@interface AppDelegate () <PKPushRegistryDelegate,UNUserNotificationCenterDelegate,YLSLoginManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    [YLSSDKConfig sharedConfig].localizedName = @"LinkusDemo";
    [YLSSDKConfig sharedConfig].iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:@"AppCallMaskIcon"]);
    [YLSSDKConfig sharedConfig].hangupAudioFileName = @"Hangup.wav";
    [YLSSDKConfig sharedConfig].alertAudioFileName = @"Alerting.wav";
//    [YLSSDKConfig sharedConfig].logPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [[YLSSDK sharedYLSSDK] initApp];
    [CallProvider shareCallProvider];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"EVER_LOGIN"]) {
        [[[YLSSDK sharedYLSSDK] loginManager] autoLogin];
        self.window.rootViewController = [[TabBarController alloc] init];
    }else{
        self.window.rootViewController = [[LoginViewController alloc] init];
    }

    [[YLSSDK sharedYLSSDK].loginManager addDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:NotificationLogout object:nil];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    // 必须写代理，不然无法监听通知的接收与点击
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 点击允许
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            }];
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_global_queue(0, 0)];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    return YES;
}

- (void)logout:(NSNotification *)note {
    self.window.rootViewController = [[LoginViewController alloc] init];
}

#pragma mark - 远程通知(推送)回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    [[YLSSDK sharedYLSSDK] updateApnsToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    BOOL notification = [[[YLSSDK sharedYLSSDK] callManager] didReceiveRemoteNotification:userInfo];
    if (notification) {
        [NSString pushNotificationWithTitle:userInfo[@"custom"][@"Caller"] body:@"Missed Call" identifier:userInfo[@"custom"][@"Linkedid"]];
    }
}

#pragma mark - PKPushRegistryDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)pushCredentials forType:(PKPushType)type {
    if ([type isEqualToString:PKPushTypeVoIP]) {
        NSData *tokenData = pushCredentials.token;
        [[YLSSDK sharedYLSSDK] updatePushKitToken:tokenData];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void(^)(void))completion {
    [[[YLSSDK sharedYLSSDK] callManager] receiveIncomingPushWithPayload:payload.dictionaryPayload];
    completion();
}

#pragma mark - LoginDataDelegate
- (void)onKickStep:(KickReason)code {
    NSString *reason = [NSString stringWithFormat:@"Login information expired. Please log in again. (%ld)",code];
    [[[YLSSDK sharedYLSSDK] loginManager] logout:^(NSError * _Nullable error) {
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NotificationLogout object:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tip" message:reason preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [RootTabBarController presentViewController:alert animated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"EVER_LOGIN"];
    }];
}

@end
