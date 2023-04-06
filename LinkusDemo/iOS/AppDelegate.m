//
//  AppDelegate.m
//  Linkus
//
//  Created by 杨桂福 on 2023/3/19.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CalllogsViewController.h"
#import <PushKit/PushKit.h>
#import "CallProvider.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    if (1) {
        CalllogsViewController *calllogsVC = [[CalllogsViewController alloc] init];
        self.window.rootViewController = calllogsVC;
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        self.window.rootViewController = loginVC;
    }

    [CallProvider shareCallProvider];
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_global_queue(0, 0)];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];

//    [[NetWorkStatusObserver sharedNetWorkStatusObserver] startMonitoring];
    
    return YES;
}

@end
