//
//  ConferenceBeginController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/4.
//

#import "ConferenceBeginController.h"

@interface ConferenceBeginController ()<YLSConfManagerDelegate,YLSCallStatusManagerDelegate>

@end

@implementation ConferenceBeginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfigurator];
    [self setupControls];
    [self setupData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupConfigurator {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor colorWithRGB:0x3D4A59];
}

- (void)setupData {
    [[[YLSSDK sharedYLSSDK] callStatusManager] addDelegate:self];
    [[[YLSSDK sharedYLSSDK] confManager] addDelegate:self];
}

- (void)dealloc {
    [[[YLSSDK sharedYLSSDK] callStatusManager] removeDelegate:self];
    [[[YLSSDK sharedYLSSDK] confManager] removeDelegate:self];
}

#pragma mark - YLSConfManagerDelegate
- (void)conferenceManager:(YLSConfManager *)manager callStatus:(YLSSipCall *)sipCall {
    if (sipCall.hangUpType != 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//    self.conferenceTopView.conferenceInfo = currenCall.conferece;
//    self.conferenceInfo = currenCall.conferece;
//    [self refreshDate];
}

- (void)conferenceManager:(YLSConfManager *)manager conferenceInfo:(YLSConfCall *)confCall {
//    self.conferenceTopView.conferenceInfo = conferenceInfo;
//    self.conferenceInfo = conferenceInfo;
//    [self refreshDate];
}

#pragma mark - UI
- (void)setupControls {
    
}

@end
