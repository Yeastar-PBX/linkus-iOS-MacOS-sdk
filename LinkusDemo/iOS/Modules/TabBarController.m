//
//  TabBarController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/3.
//

#import "TabBarController.h"
#import "CalllogsViewController.h"
#import "ConferenceListController.h"
#import "MeListViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CalllogsViewController *rootCallsVC = [[CalllogsViewController alloc] init];
    rootCallsVC.tabBarItem = [self tabbar:@"TabBarItem_Calls_Normal" selectedImage:@"TabBarItem_Calls_Select" title:@"Calls"];
    UINavigationController *rootCallsNav = [[UINavigationController alloc] initWithRootViewController:rootCallsVC];

    ConferenceListController *conferenceVC = [[ConferenceListController alloc] init];
    conferenceVC.tabBarItem = [self tabbar:@"TabBarItem_Conference_Normal" selectedImage:@"TabBarItem_Conference_Select"  title:@"Conference"];
    UINavigationController *conferenceNav = [[UINavigationController alloc] initWithRootViewController:conferenceVC];
    
    MeListViewController *meVC = [[MeListViewController alloc] init];
    meVC.tabBarItem = [self tabbar:@"TabBarItem_Conference_Normal" selectedImage:@"TabBarItem_Conference_Select"  title:@"Me"];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:meVC];

    self.viewControllers = @[rootCallsNav,conferenceNav,meNav];
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.shadowColor = [UIColor clearColor];
        appearance.backgroundColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
        self.tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
        }
    }else{
        self.tabBar.shadowImage = [UIImage new];
        self.tabBar.backgroundImage = [UIImage new];
        self.tabBar.backgroundColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
    }
    self.tabBar.layer.shadowColor = [UIColor colorWithRGB:0x000000 alpha:0.13].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0,-0.5);
    self.tabBar.layer.shadowOpacity = 1;
    self.tabBar.layer.shadowRadius = 0;
}

#pragma mark - Private
- (UITabBarItem *)tabbar:(NSString *)imageName selectedImage:(NSString *)selImageName title:(NSString*)title {
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:selImageName]];
    item.titlePositionAdjustment = UIOffsetMake(0, -5);
    
    if (@available(iOS 13.0, *)) {
        self.tabBar.tintColor = [UIColor colorWithRGB:0x0070C0];
        self.tabBar.unselectedItemTintColor = [UIColor colorWithRGB:0x000000 alpha:0.38];
    } else {
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:0x0070C0]} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRGB:0x000000 alpha:0.38]} forState:UIControlStateNormal];
    }
    return item;
}

@end
