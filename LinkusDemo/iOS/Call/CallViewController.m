//
//  CallViewController.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//

#import "CallViewController.h"
#import "QualityView.h"
#import "NotifyView.h"
#import "MenuPanView.h"
#import "DialKeypadView.h"
#import "CallMemberView.h"
#import "CallTransferView.h"
#import "CallWaitingView.h"

@interface CallViewController ()<CallStatusManagerDelegate,CallManagerDelegate,
                                 DialKeypadViewDelegate,CallWaitingViewDelegate,MenuPanViewDelegate>

@property (nonatomic,strong) UIImageView *backgroundView;

@property (nonatomic,strong) UIView *containerView;

@property (nonatomic,strong) UIButton *qualityButton;

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
    [[YLSCallManager shareCallManager] addDelegate:self];
    [[YLSCallStatusManager shareCallStatusManager] addDelegate:self];
//    [[PJRegister sharePJRegister] addDelegate:self];
//    [[NetWorkStatusObserver sharedNetWorkStatusObserver] addDelegate:self];
}

- (void)setupData {
    [self callStatusManager:[YLSCallStatusManager shareCallStatusManager] currentCall:[YLSCallManager shareCallManager].currentSipCall];
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
}

- (void)callStatusManager:(YLSCallStatusManager *)callStatusManager currentCall:(YLSSipCall *)currentCall callWaiting:(YLSSipCall *)callWaitingCall transferCall:(YLSSipCall *)transferCall {
    self.backgroundView.image = currentCall.contact.sipImage;
    [self.memberView callNormal:currentCall];
    [self.waitingView callNormal:callWaitingCall];
    [self.transferView callNormal:transferCall];
    [self.menuView callNormal:currentCall waitingCall:callWaitingCall transferCall:transferCall];
    self.waitingView.hidden = !callWaitingCall;
    self.transferView.hidden = !transferCall;;
}

#pragma mark - UI
- (void)setupControls {
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.backgroundView = backgroundView;
    backgroundView.userInteractionEnabled = YES;
    backgroundView.image = [YLSCallManager shareCallManager].currentSipCall.contact.sipImage;
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
//    [qualityButton addTarget:self action:@selector(qualityAction) forControlEvents:UIControlEventTouchUpInside];
    qualityButton.layer.cornerRadius = 4;
    qualityButton.layer.masksToBounds = YES;
    [containerView addSubview:qualityButton];
            
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

@end
