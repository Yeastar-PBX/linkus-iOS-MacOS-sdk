//
//  CalllogsViewController.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/21.
//

#import "CalllogsViewController.h"
#import "DialpadView.h"
#import "DialpadCallView.h"
#import "CallProvider.h"

@interface CalllogsViewController ()<DialpadViewDelegate, DialpadCallViewDelegate>

@property (nonatomic,strong) DialpadView                 *dialpadView;

@property (nonatomic,strong) DialpadCallView             *dialpadCallView;

@end

@implementation CalllogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Calls";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login out" style:UIBarButtonItemStylePlain target:self action:@selector(loginOut)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (granted) {
            NSLog(@"同意麦克风权限");
        } else {
            if (status == AVAuthorizationStatusDenied) {
                NSLog(@"不同意麦克风权限");
            } else if (status == AVAuthorizationStatusNotDetermined) {
                NSLog(@"未授权麦克风权限");
            } else if (status == AVAuthorizationStatusRestricted) {
                NSLog(@"AVAuthorizationStatusRestricted");
            }
        }
    }];
    
    DialpadView *dialpadView = [[DialpadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.dialpadView = dialpadView;
    dialpadView.delegate = self;
    [dialpadView presentInView:self.view];
    self.dialpadCallView.hidden = NO;
    [self.view insertSubview:self.dialpadCallView aboveSubview:dialpadView];
    
    DialpadCallView *dialpadCallView = [[DialpadCallView alloc] init];
    self.dialpadCallView = dialpadCallView;
    dialpadCallView.delegate = self;
    [self.view addSubview:dialpadCallView];
    
    [dialpadCallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(56);
    }];
}

#pragma mark - DialpadViewDelegate
-(void)dialpadView:(DialpadView *)dialpadView searchNumber:(NSString *)number {
    
}

- (void)dialpadViewHidden:(DialpadView *)dialpadView {
    self.dialpadCallView.dialpadShow = NO;
    [self.dialpadCallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-24);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(56);
    }];
}

- (void)dialpadView:(DialpadView *)dialpadView personNumberAdd:(NSString *)number {
    
}

#pragma mark - DialpadCallViewDelegate
- (void)dialpadCallViewShowAction:(DialpadCallView *)dialpadCallView {
    [self.dialpadView presentInView:self.view];
    dialpadCallView.dialpadShow = YES;
    [self.view insertSubview:dialpadCallView aboveSubview:self.dialpadView];
    [self.dialpadCallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(56);
    }];
}

- (void)dialpadCallViewCallAction:(DialpadCallView *)dialpadCallView touchAction:(BOOL)longTouch {
    [CallProvider baseCallByNumber:self.dialpadView.number];
}

#pragma mark - DialpadCallViewDelegate
- (void)loginOut {
    [self showHUD];
    [[[YLSSDK sharedYLSSDK] loginManager] logout:^(NSError * _Nullable error) {
        [self hideHUD];
        extern NSString *NotificationLogout;
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NotificationLogout object:nil];
    }];
}

@end
