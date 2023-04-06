//
//  UIViewController+Hierarchy.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//

#import "UIViewController+Hierarchy.h"

@implementation UIViewController (Hierarchy)

#pragma mark Public Method
+ (UIViewController *)topViewController {
    return [self topViewControllerWithRootViewController:nil];
}

#pragma mark Private Method
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if (!rootViewController) {
        rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    }
    
    if (rootViewController.presentedViewController) {
        UIViewController *controller = rootViewController.presentedViewController;
        if (!controller ||
            controller == rootViewController) {
            return rootViewController;
        }
        return [self topViewControllerWithRootViewController:controller];
    }
    else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *) rootViewController;
        UIViewController *controller = tabBarController.selectedViewController ? : tabBarController.viewControllers.firstObject;
        if (!controller ||
            controller == rootViewController) {
            return rootViewController;
        }
        return [self topViewControllerWithRootViewController:controller];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *) rootViewController;
        UIViewController *controller = navigationController.visibleViewController ? : navigationController.viewControllers.firstObject;
        if (!controller ||
            controller == rootViewController) {
            return rootViewController;
        }
        return [self topViewControllerWithRootViewController:controller];
    }
    else {
        return rootViewController;
    }
}

@end
