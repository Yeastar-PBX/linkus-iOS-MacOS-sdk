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
    [YLSSDKConfig sharedConfig].localizedName = @"LinkusDemo";
    [YLSSDKConfig sharedConfig].iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:@"AppCallMaskIcon"]);
    [YLSSDKConfig sharedConfig].hangupAudioFileName = @"Hangup.wav";
    [YLSSDKConfig sharedConfig].alertAudioFileName = @"Alerting.wav";
    
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
    [[[YLSSDK sharedYLSSDK] callManager] receiveIncomingPushWithPayload:payload.dictionaryPayload];
    completion();
}

@end
