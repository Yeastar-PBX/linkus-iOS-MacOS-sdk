//
//  ConferenceBeginController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/4.
//

#import "ConferenceBeginController.h"
#import "MemberSelectViewController.h"
#import "ConfTopView.h"
#import "ConfCenterViewCell.h"
#import "ConfBottomView.h"
#import "NotifyView.h"

@interface ConferenceBeginController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, YLSConfManagerDelegate, YLSCallStatusManagerDelegate, YLSCallManagerDelegate, ConfTopViewDelegate, ConfBottomViewDelegate>

@property (nonatomic,strong) ConfTopView *topView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) ConfBottomView *bottomView;

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
    [[[YLSSDK sharedYLSSDK] callManager] addDelegate:self];
    [[[YLSSDK sharedYLSSDK] callStatusManager] addDelegate:self];
    [[[YLSSDK sharedYLSSDK] confManager] addDelegate:self];
}

- (void)dealloc {
    [[[YLSSDK sharedYLSSDK] callManager] removeDelegate:self];
    [[[YLSSDK sharedYLSSDK] callStatusManager] removeDelegate:self];
    [[[YLSSDK sharedYLSSDK] confManager] removeDelegate:self];
}

#pragma mark - YLSConfManagerDelegate
- (void)conferenceManager:(YLSConfManager *)manager callStatus:(YLSSipCall *)sipCall {
    if (sipCall.hangUpType != 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    self.topView.confCall = sipCall.confCall;
    self.confCall = sipCall.confCall;
    [self.collectionView reloadData];
}

- (void)conferenceManager:(YLSConfManager *)manager conferenceInfo:(YLSConfCall *)confCall {
    self.topView.confCall = confCall;
    self.confCall = confCall;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.confCall.confMembers.count == 8) {
        return 8;
    }else {
        return self.confCall.confMembers.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ConfCenterViewCell *cell = [ConfCenterViewCell dequeueCellWithCollectionView:collectionView
    indexPath:indexPath];
    if (indexPath.row == self.confCall.confMembers.count && self.confCall.confMembers.count != 8) {
        @weakify(self)
        cell.clickPicture = ^(YLSConfMember *member) {
            @strongify(self)
            MemberSelectViewController *vc = [[MemberSelectViewController alloc] init];
            @weakify(self)
            vc.block = ^(NSString *number) {
                @strongify(self)
                [self showHUD];
                [[YLSSDK sharedYLSSDK].confManager inviteConferenceMembers:@[number] confid:self.confCall.confid complete:^(NSError * _Nullable error) {
                    if (error) {
                        [self showHUDErrorWithText:@"Server Connection Failure"];
                    }else{
                        [self hideHUD];
                    }
                }];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        [cell.iconButton setBackgroundImage:[UIImage imageNamed:@"ConferenceBegin_add_Normal"] forState:UIControlStateNormal];
        cell.nameLabel.text = [NSString stringWithFormat:@"%d more",(int)(8 - self.confCall.confMembers.count)];
        cell.member = nil;
    }else{
        @weakify(self)
        cell.clickPicture = ^(YLSConfMember *member) {
            @strongify(self)
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            if (member.status == ConferenceCallingStatusBridge && [self.confCall.host isEqualToString:[YLSSDK sharedYLSSDK].loginManager.ylsUserNumber]) {
                [alert addAction:[UIAlertAction actionWithTitle:member.operate != ConferenceSpeakerOperateMute?@"Mute":@"Unmute" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [self showHUD];
                    [[YLSSDK sharedYLSSDK].confManager operationConferenceMember:member.number confid:self.confCall.confid operationType:member.operate != ConferenceSpeakerOperateMute?ConferenceOperationMute:ConferenceOperationUnmute complete:^(NSError *error) {
                        if (error) {
                            [self showHUDErrorWithText:@"Server Connection Failure"];
                        }else{
                            [self hideHUD];
                        }
                    }];
                }]];
            }
            if (member.status == ConferenceCallingStatusMissedCall) {
                [alert addAction:[UIAlertAction actionWithTitle:@"Call Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [self showHUD];
                    [[YLSSDK sharedYLSSDK].confManager operationConferenceMember:member.number confid:self.confCall.confid operationType:ConferenceOperationCallAgain complete:^(NSError *error) {
                        if (error) {
                            [self showHUDErrorWithText:@"Server Connection Failure"];
                        }else{
                            [self hideHUD];
                        }
                    }];
                }]];
            }
            if ([self.confCall.host isEqualToString:[YLSSDK sharedYLSSDK].loginManager.ylsUserNumber]) {
                [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [self showHUD];
                    [[YLSSDK sharedYLSSDK].confManager operationConferenceMember:member.number confid:self.confCall.confid operationType:ConferenceOperationRemoveMember complete:^(NSError *error) {
                        if (error) {
                            [self showHUDErrorWithText:@"Server Connection Failure"];
                        }else{
                            [self hideHUD];
                        }
                    }];
                }]];
            }
            if (alert.actions.count > 0) {
                [alert addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil])];
                [self presentViewController:alert animated:YES completion:nil];
            }
        };
        YLSConfMember *member = self.confCall.confMembers[indexPath.row];
        cell.member = member;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.width/3 - 20, self.view.width/3 * 22/25);;
}

#pragma mark - ConfTopViewDelegate
- (void)clickAvatar {
    if ([self.confCall.host isEqualToString:[YLSSDK sharedYLSSDK].loginManager.ylsUserNumber]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"Mute All" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self showHUD];
            [[YLSSDK sharedYLSSDK].confManager operationConferenceMember:self.confCall.host confid:self.confCall.confid operationType:ConferenceOperationMuteAllMembers complete:^(NSError *error) {
                if (error) {
                    [self showHUDErrorWithText:@"Server Connection Failure"];
                }else{
                    [self hideHUD];
                }
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Unmute All" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self showHUD];
            [[YLSSDK sharedYLSSDK].confManager operationConferenceMember:self.confCall.host confid:self.confCall.confid operationType:ConferenceOperationUnmuteAllMembers complete:^(NSError *error) {
                if (error) {
                    [self showHUDErrorWithText:@"Server Connection Failure"];
                }else{
                    [self hideHUD];
                }
            }];
        }]];
        [alert addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil])];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - CallStatusManagerDelegate
- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager currentCall:(YLSSipCall *)currentCall {
    self.bottomView.muteButton.selected = currentCall.mute;
}

- (void)callManager:(YLSCallManager *)callManager callQuality:(BOOL)quality {
    [NotifyView notifyView:@"Network status is abnormal." showView:self.view hidden:!quality];
}

#pragma mark - ConfBottomViewDelegate
- (void)conferenceHangup {
    YLSSipCall *sipCall = [YLSSDK sharedYLSSDK].confManager.currentConfSipCall;
    sipCall.hangUpType = HangUpTypeByHand;
    [[YLSCallTool shareCallTool] endCall:sipCall];

    if (!sipCall) {
        [self showHUD];
        [[YLSSDK sharedYLSSDK].confManager operationConferenceMember:self.confCall.host confid:self.confCall.confid operationType:ConferenceOperationClosingConference complete:^(NSError *error) {
            if (!error) {
                [self hideHUD];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self showHUDErrorWithText:@"Server Connection Failure"];
            }
        }];
    }
}

- (void)conferenceMute:(BOOL)select {
    self.bottomView.muteButton.selected = !select;
    YLSSipCall *sipCall = [YLSSDK sharedYLSSDK].confManager.currentConfSipCall;
    sipCall.mute = !select;
    [[YLSCallTool shareCallTool] setMute:sipCall];
}

#pragma mark - UI
- (void)setupControls {
    ConfTopView *topView = [[ConfTopView alloc] init];
    self.topView = topView;
    topView.delegate = self;
    topView.confCall = self.confCall;
    [self.view addSubview:topView];
    [topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo(160);
    }];
    
    ConfBottomView *bottomView = [[ConfBottomView alloc] init];
    self.bottomView = bottomView;
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    [bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor colorWithRGB:0x3D4A59];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delaysContentTouches = NO;
    collectionView.scrollEnabled = NO;
    [self.view addSubview:collectionView];
    [collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.width);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
}

@end
