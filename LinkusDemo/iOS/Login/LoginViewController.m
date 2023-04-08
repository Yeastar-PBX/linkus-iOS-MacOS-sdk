//
//  LoginViewController.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/19.
//

#import "LoginViewController.h"
#import "YLSUnderlineTextField.h"

@interface LoginViewController ()

@property (nonatomic,strong) UITextField *userNameTF;

@property (nonatomic,strong) UITextField *passwordTF;

@property (nonatomic,strong) UITextField *identifyTF;

@property (nonatomic,strong) UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    YLSUnderlineTextField *userNameTF = [[YLSUnderlineTextField alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, 60)];
    self.userNameTF = userNameTF;
    userNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameTF.returnKeyType = UIReturnKeyDone;
    userNameTF.secureTextEntry = YES;
    userNameTF.textColor = [UIColor whiteColor];
    [self.view addSubview:userNameTF];
    
    YLSUnderlineTextField *passwordTF = [[YLSUnderlineTextField alloc] initWithFrame:CGRectMake(10, 260, self.view.frame.size.width - 20, 60)];
    self.passwordTF = passwordTF;
    passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTF.returnKeyType = UIReturnKeyDone;
    passwordTF.secureTextEntry = YES;
    passwordTF.textColor = [UIColor whiteColor];
    [self.view addSubview:passwordTF];
    
    YLSUnderlineTextField *identifyTF = [[YLSUnderlineTextField alloc] initWithFrame:CGRectMake(10, 320, self.view.frame.size.width - 20, 60)];
    self.identifyTF = identifyTF;
    identifyTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"域名/SN" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    identifyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    identifyTF.returnKeyType = UIReturnKeyDone;
    identifyTF.secureTextEntry = YES;
    identifyTF.textColor = [UIColor whiteColor];
    [self.view addSubview:identifyTF];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 400, self.view.frame.size.width - 20, 45)];
    self.loginButton = loginButton;
    [loginButton addTarget:self action:@selector(loginEvent:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed:28 / 255.0 green:119 / 255.0 blue:211 / 255.0 alpha:0.95];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 3;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:23];
    loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:loginButton];
}

#pragma mark - action
- (void)loginEvent:(UIButton *)sender {
    [self showHUDWithText:@"登录中"];
    double delayInSeconds = 0.5;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        [self hideHUD];
    });
}

@end
