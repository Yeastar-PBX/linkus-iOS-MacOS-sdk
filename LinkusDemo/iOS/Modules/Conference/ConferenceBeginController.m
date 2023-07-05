//
//  ConferenceBeginController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/4.
//

#import "ConferenceBeginController.h"

@interface ConferenceBeginController ()

@end

@implementation ConferenceBeginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor colorWithRGB:0x3D4A59];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
