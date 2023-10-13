//
//  LoginViewController.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/19.
//

#import "LoginViewController.h"
#import "YLSUnderlineTextField.h"
#import "CalllogsViewController.h"

@interface LoginViewController ()

@property (nonatomic,strong) UITextField *userNameTF;

@property (nonatomic,strong) UITextField *passwordTF;

@property (nonatomic,strong) UITextField *localIPTF;

@property (nonatomic,strong) UITextField *localPortTF;

@property (nonatomic,strong) UITextField *remoteIPTF;

@property (nonatomic,strong) UITextField *remotePortTF;

@property (nonatomic,strong) UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    YLSUnderlineTextField *userNameTF = [[YLSUnderlineTextField alloc] initWithFrame:CGRectMake(10, 140, self.view.frame.size.width - 20, 60)];
    self.userNameTF = userNameTF;
    userNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameTF.returnKeyType = UIReturnKeyDone;
    userNameTF.text = @"1000";
    userNameTF.textColor = [UIColor grayColor];
    [self.view addSubview:userNameTF];
    
    YLSUnderlineTextField *passwordTF = [[YLSUnderlineTextField alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, 60)];
    self.passwordTF = passwordTF;
    passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTF.returnKeyType = UIReturnKeyDone;
    passwordTF.text = @"eyJleHBpcmUiOjAsInNpZ24iOiJFLzBmY1J1YjZDVlhXdFNRWS8xQWpHMzRGNVBGUEw4cE52Zm4wNzA3K3BrPSIsInVzZXJuYW1lIjoiMTAwMCIsInZlcnNpb24iOiIxLjAifQ__";
    passwordTF.secureTextEntry = YES;
    passwordTF.textColor = [UIColor grayColor];
    [self.view addSubview:passwordTF];
    
    YLSUnderlineTextField *localIPTF = [[YLSUnderlineTextField alloc] initWithFrame:CGRectMake(10, 260, self.view.frame.size.width - 140, 60)];
    self.localIPTF = localIPTF;
    localIPTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Local Hostname/IP" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    localIPTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    localIPTF.returnKeyType = UIReturnKeyDone;
    localIPTF.text = @"192.168.21.252";
    localIPTF.textColor = [UIColor grayColor];
    [self.view addSubview:localIPTF];
    
    YLSUnderlineTextField *localPortTF = [[YLSUnderlineTextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, 260, 110, 60)];
    self.localPortTF = localPortTF;
    localPortTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Local Port" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    localPortTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    localPortTF.returnKeyType = UIReturnKeyDone;
    localPortTF.text = @"8111";
    localPortTF.textColor = [UIColor grayColor];
    [self.view addSubview:localPortTF];
    
    YLSUnderlineTextField *remoteIPTF = [[YLSUnderlineTextField alloc] initWithFrame:CGRectMake(10, 320, self.view.frame.size.width - 140, 60)];
    self.remoteIPTF = remoteIPTF;
    remoteIPTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"External Hostname/IP" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    remoteIPTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    remoteIPTF.returnKeyType = UIReturnKeyDone;
    remoteIPTF.text = @"";
    remoteIPTF.textColor = [UIColor grayColor];
    [self.view addSubview:remoteIPTF];
    
    YLSUnderlineTextField *remotePortTF = [[YLSUnderlineTextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 120, 320, 110, 60)];
    self.remotePortTF = remotePortTF;
    remotePortTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"External Port" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
    remotePortTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    remotePortTF.returnKeyType = UIReturnKeyDone;
    remotePortTF.text = @"";
    remotePortTF.textColor = [UIColor grayColor];
    [self.view addSubview:remotePortTF];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 380, self.view.frame.size.width - 20, 45)];
    self.loginButton = loginButton;
    [loginButton addTarget:self action:@selector(loginEvent:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed:28 / 255.0 green:119 / 255.0 blue:211 / 255.0 alpha:0.95];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 3;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:23];
    [self.view addSubview:loginButton];
}

#pragma mark - action
- (void)loginEvent:(UIButton *)sender {
    [self showHUD];
    [[[YLSSDK sharedYLSSDK] loginManager] login:self.userNameTF.text token:self.passwordTF.text
    localIP:self.localIPTF.text localPort:self.localPortTF.text remoteIP:self.remoteIPTF.text remotePort:self.remotePortTF.text completion:^(NSError * _Nullable error) {
        [self hideHUD];
        if (!error) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EVER_LOGIN"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CalllogsViewController alloc] init]];
        }else{
            [self showHUDErrorWithText:[NSString stringWithFormat:@"Failed to connect to server (%ld)",error.code]];
        }
    }];
}

@end
