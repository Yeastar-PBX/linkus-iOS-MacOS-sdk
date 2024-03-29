//
//  CallViewController.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//

#import "CallViewController.h"
#import "AdminTableViewController.h"
#import "QualityView.h"
#import "NotifyView.h"
#import "MenuPanView.h"
#import "DialKeypadView.h"
#import "CallMemberView.h"
#import "CallTransferView.h"
#import "CallWaitingView.h"
#import "Contact.h"

@interface CallViewController ()<YLSCallStatusManagerDelegate,YLSCallManagerDelegate,
                                 DialKeypadViewDelegate,CallWaitingViewDelegate,MenuPanViewDelegate>

@property (nonatomic,strong) UIImageView *backgroundView;

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) UIButton *qualityButton;

@property (nonatomic,strong) UIButton *adminButton;

@property (nonatomic,strong) CallMemberView *memberView;

@property (nonatomic,strong) CallTransferView *transferView;

@property (nonatomic,strong) CallWaitingView *waitingView;

@property (nonatomic,strong) MenuPanView *menuView;

@property (nonatomic,strong) DialKeypadView *keypadView;

@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfigurator];
    [self setupControls];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupConfigurator {
    [[[YLSSDK sharedYLSSDK] callManager] addDelegate:self];
    [[[YLSSDK sharedYLSSDK] callStatusManager] addDelegate:self];
}

- (void)setupData {
    YLSSipCall *currentCall = [[YLSSDK sharedYLSSDK] callManager].currentSipCall;
    self.backgroundView.image = currentCall.contact.sipImage;
    [self.memberView callNormal:currentCall];
    [self.menuView callNormal:currentCall waitingCall:nil transferCall:nil];
    self.transferView.hidden = YES;
    self.waitingView.hidden = YES;
    self.qualityButton.hidden = NO;
}

- (void)dealloc {
    [[[YLSSDK sharedYLSSDK] callManager] removeDelegate:self];
    [[[YLSSDK sharedYLSSDK] callStatusManager] removeDelegate:self];
}

#pragma mark - CallStatusManagerDelegate
- (void)callStatusManagerDissmiss:(YLSCallStatusManager *)callStatusManager {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager currentCall:(YLSSipCall *)currentCall {
    self.backgroundView.image = currentCall.contact.sipImage;
    [self.memberView callNormal:currentCall];
    [self.menuView callNormal:currentCall waitingCall:nil transferCall:nil];
    self.transferView.hidden = YES;
    self.waitingView.hidden = YES;
    self.qualityButton.hidden = NO;
    self.adminButton.hidden = YES;
}

- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager currentCall:(YLSSipCall *)currentCall callWaiting:(YLSSipCall *)callWaitingCall transferCall:(YLSSipCall *)transferCall {
    self.backgroundView.image = currentCall.contact.sipImage;
    [self.memberView callNormal:currentCall];
    [self.waitingView callNormal:callWaitingCall];
    [self.transferView callNormal:transferCall];
    [self.menuView callNormal:currentCall waitingCall:callWaitingCall transferCall:transferCall];
    self.waitingView.hidden = !callWaitingCall;
    self.transferView.hidden = !transferCall;
    [self dialKeypadViewAnimation:NO];
}

- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager multiCall:(YLSSipCall *)multiCall waitingCall:(YLSSipCall *)waitingCall {
    if (!multiCall.contact) {
        Contact *contact = [[Contact alloc] init];
        contact.name = multiCall.callNumber;
        contact.iconImage = [UIImage imageNamed:@"Avatar_CallAdmin"];
        multiCall.contact = contact;
    }
    self.backgroundView.image = multiCall.contact.sipImage;
    [self.memberView callNormal:multiCall];
    [self.transferView callNormal:waitingCall];
    [self.menuView callMulti:multiCall];
    self.adminButton.hidden = ![multiCall.callNumber hasPrefix:MultiCall];
    self.qualityButton.hidden = [multiCall.callNumber hasPrefix:MultiCall];
    self.waitingView.hidden = YES;
    self.transferView.hidden = !waitingCall;
    [self dialKeypadViewAnimation:NO];
}

#pragma mark - CallManagerDelegate
- (void)callManagerRecordType:(YLSCallManager *)callManager {
    YLSSipCall *sipCall = [[YLSSDK sharedYLSSDK] callManager].currentSipCall;
    [self.menuView callReload:sipCall];
}

#pragma mark - PJRegisterDelegate
- (void)callManager:(YLSCallManager *)callManager callid:(int)callid callQuality:(BOOL)quality {
    [NotifyView notifyView:@"Network status is abnormal." showView:self.containerView hidden:!quality];
}

#pragma mark- MenuPanViewDelegate
- (void)menuPanView:(MenuPanView *)menuPanView touch:(MenuPanViewType)type selected:(BOOL)selected {
    if (type == MenuPanViewTypeHold) {
        YLSSipCall *sipCall = [[YLSSDK sharedYLSSDK] callManager].currentSipCall;
        if (sipCall.mute) {//hold住的时候，取消静音
            sipCall.mute = NO;
            [[YLSCallTool shareCallTool] setMute:sipCall];
        }
        sipCall.onHold = !selected;
        [[YLSCallTool shareCallTool] setHeld:sipCall];
        [self.menuView reloadData];
    }else if (type == MenuPanViewTypeMute) {
        YLSSipCall *sipCall = [[YLSSDK sharedYLSSDK] callManager].currentSipCall;
        sipCall.mute = !selected;
        [[YLSCallTool shareCallTool] setMute:sipCall];
        [self.menuView reloadData];
    }else if (type == MenuPanViewTypeHangup) {
        YLSSipCall *sipCall = [[YLSSDK sharedYLSSDK] callManager].currentSipCall;
        sipCall.hangUpType = HangUpTypeByHand;
        [[YLSCallTool shareCallTool] endCall:sipCall];
    }else if (type == MenuPanViewTypeCancelFlip) {
        
    }else if (type == MenuPanViewTypeCamera) {
        
    }else if (type == MenuPanViewTypeRecord) {
        YLSSipCall *sipCall = [[YLSSDK sharedYLSSDK] callManager].currentSipCall;
        if (sipCall.onHold) {
            [self showHUDInfoWithText:@"Please stop holding the call"];
        }else{
            BOOL isSuc = [[YLSCallTool shareCallTool] setRecord:sipCall];
            if (!isSuc) {
                [self showHUDInfoWithText:@"Record failed"];
            }
        }
    }else if (type == MenuPanViewTypeCallFlip) {
        
    }else {
        if (type == MenuPanViewTypeAttended && selected) {
            [[YLSCallTool shareCallTool] transferConsultation];
        }else{
            if (type == MenuPanViewTypeKeypad) {
                self.keypadView.dtmf = YES;
            }else{
                self.keypadView.dtmf = NO;
                YLSSipCall *sipCall = [[YLSSDK sharedYLSSDK] callManager].currentSipCall;
                if (!sipCall.onHold) {
                    sipCall.onHold = YES;
                    [[YLSCallTool shareCallTool] setHeld:sipCall];
                }
                if (sipCall.mute) {
                    sipCall.mute = NO;
                    [[YLSCallTool shareCallTool] setMute:sipCall];
                }
                [self.menuView reloadData];
            }
            if (type == MenuPanViewTypeAttended) {
                [CallProvider shareCallProvider].dialCallType = DialCallTypeTransfer;
            }else if (type == MenuPanViewTypeBlind) {
                [CallProvider shareCallProvider].dialCallType = DialCallTypeBlind;
            }else if (type == MenuPanViewTypeAddCall) {
                [CallProvider shareCallProvider].dialCallType = DialCallTypeMultiCall;
            }
            [self dialKeypadViewAnimation:YES];
        }
    }
}

#pragma mark - CallWaitingViewDelegate
- (void)callWaitingView:(CallWaitingView *)waitingView callInfo:(YLSSipCall *)SipCall {
    if ([[YLSSDK sharedYLSSDK] callManager].currentSipCalls.count == 2) {
        [[[YLSSDK sharedYLSSDK] callStatusManager] callChange:SipCall];
    }
}

#pragma mark - DialKeypadViewDelegate
- (void)dialKeypadViewContacts:(UIButton *)button {
    
}

- (void)dialKeypadViewHistory:(UIButton *)button {
    
}

- (void)dialKeypadViewTransferTo:(NSString *)text {
    [CallProvider baseCallByNumber:text];
}

- (void)dialKeypadViewCancel:(UIButton *)button {
    [self dialKeypadViewAnimation:NO];
    YLSSipCall *sipCall = [[YLSSDK sharedYLSSDK] callManager].currentSipCall;
    if (sipCall.onHold) {
        sipCall.onHold = NO;
        [[YLSCallTool shareCallTool] setHeld:sipCall];
        [self.menuView reloadData];
    }
}

- (void)dialKeypadViewDtmf:(NSString *)str {
    [[YLSCallTool shareCallTool] setDTMF:[[YLSSDK sharedYLSSDK] callManager].currentSipCall string:str];
}

#pragma mark - UI
- (void)setupControls {
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.backgroundView = backgroundView;
    backgroundView.userInteractionEnabled = YES;
    backgroundView.image = [[YLSSDK sharedYLSSDK] callManager].currentSipCall.contact.sipImage;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = backgroundView.frame;
    [backgroundView addSubview:effectView];
    [self.view addSubview:backgroundView];
    
    DialKeypadView *keypadView = [[DialKeypadView alloc] init];
    self.keypadView = keypadView;
    keypadView.hidden = YES;
    keypadView.delegate = self;
    [backgroundView addSubview:keypadView];

    UIView *containerView = [[UIView alloc] init];
    self.containerView = containerView;
    [backgroundView addSubview:containerView];
    
    UIButton *qualityButton = [[UIButton alloc] init];
    self.qualityButton = qualityButton;
    qualityButton.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.24];
    [qualityButton setImage:[UIImage imageNamed:@"Call_Quality"] forState:UIControlStateNormal];
    [qualityButton addTarget:self action:@selector(qualityAction) forControlEvents:UIControlEventTouchUpInside];
    qualityButton.layer.cornerRadius = 4;
    qualityButton.layer.masksToBounds = YES;
    [containerView addSubview:qualityButton];
    
    UIButton *adminButton = [[UIButton alloc] init];
    self.adminButton = adminButton;
    adminButton.hidden = YES;
    adminButton.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.24];
    [adminButton setImage:[UIImage imageNamed:@"Call_Admin"] forState:UIControlStateNormal];
    [adminButton addTarget:self action:@selector(adminAction) forControlEvents:UIControlEventTouchUpInside];
    adminButton.layer.cornerRadius = 4;
    adminButton.layer.masksToBounds = YES;
    [containerView addSubview:adminButton];
            
    CallWaitingView *waitingView = [[CallWaitingView alloc] init];
    self.waitingView = waitingView;
    waitingView.delegate = self;
    [containerView addSubview:waitingView];
    
    CallMemberView *memberView = [[CallMemberView alloc] init];
    self.memberView = memberView;
    [containerView addSubview:memberView];
    
    CallTransferView *transferView = [[CallTransferView alloc] init];
    self.transferView = transferView;
    [containerView addSubview:transferView];
    
    MenuPanView *menuView = [[MenuPanView alloc] init];
    self.menuView = menuView;
    menuView.delegate = self;
    menuView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:menuView];
    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-16-TabBarOffset);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(MenuPanViewHeightMin);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.keypadView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
        
    [self.qualityButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(self.waitingView.isHidden ? (StatusBarHeight + 8) : (StatusBarHeight + 48));
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.height.width.mas_equalTo(32);
    }];
    
    [self.adminButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qualityButton.mas_top);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.height.width.mas_equalTo(32);
    }];
        
    [self.memberView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qualityButton.mas_bottom).offset(4);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(180);
    }];
    
    [self.transferView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(26);
        make.top.mas_equalTo(self.memberView.mas_top);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(84);
    }];
    
    [self.waitingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView.mas_left);
        make.right.mas_equalTo(self.containerView.mas_right);
        make.top.mas_equalTo(self.containerView.mas_top).offset(StatusBarHeight + 4);
        make.height.mas_equalTo(40);
    }];
}

- (void)qualityAction {
    YLSSipCall *sipCall = [[YLSSDK sharedYLSSDK] callManager].currentSipCall;
    if (sipCall.status == CallStatusBridge) {
        [QualityView qualityViewData:^NSString *{
            return [[YLSCallTool shareCallTool] callQuality];
        } showInView:self.view];
    }
}

- (void)adminAction {
    AdminTableViewController *vc = [[AdminTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Private
- (void)dialKeypadViewAnimation:(BOOL)show {
    if (show) {
        CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        anima.fromValue = [NSNumber numberWithFloat:0.0f];
        anima.toValue = [NSNumber numberWithFloat:1.0f];
        anima.duration = 0.25f;
        [self.keypadView.layer addAnimation:anima forKey:@"scaleAnimation"];
    }else{
        CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        anima.fromValue = [NSNumber numberWithFloat:1.0f];
        anima.toValue = [NSNumber numberWithFloat:0.0f];
        anima.duration = 0.25f;
        [self.keypadView.layer addAnimation:anima forKey:@"scaleAnimation"];
    }
    
    if (show) {
        self.keypadView.hidden = NO;
        self.containerView.hidden = YES;
    }else{
        self.keypadView.hidden = YES;
        self.containerView.hidden = NO;
    }
}

@end
