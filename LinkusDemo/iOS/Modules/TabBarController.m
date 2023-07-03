//
//  TabBarController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/3.
//

#import "TabBarController.h"
#import "CalllogsViewController.h"

@interface TabBarController ()

@property (nonatomic,strong) UINavigationController *conferenceNav;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CalllogsViewController *rootCallsVC = [[CalllogsViewController alloc] init];
    rootCallsVC.tabBarItem = [self tabbar:@"TabBarItem_Calls_Normal" selectedImage:@"TabBarItem_Calls_Select" title:@"Calls"];
    UINavigationController *rootCallsNav = [[UINavigationController alloc] initWithRootViewController:rootCallsVC];
    self.viewControllers = @[rootCallsNav];

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
