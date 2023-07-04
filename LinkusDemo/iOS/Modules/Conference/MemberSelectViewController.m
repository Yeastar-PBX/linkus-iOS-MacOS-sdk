//
//  MemberSelectViewController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/4.
//

#import "MemberSelectViewController.h"

@interface MemberSelectViewController ()

@property (nonatomic,strong) UITextField *textField;

@end

@implementation MemberSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGB:0xFFFFFF];
    self.navigationItem.title = @"Select The Contact";
    
    UITextField *textField = [[UITextField alloc] init];
    self.textField = textField;
    textField.placeholder = @"请输入号码";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightMedium];
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
    [textField becomeFirstResponder];
    [self.view addSubview:textField];
    [textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.top).offset([UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44 + 64);
        make.width.mas_equalTo(200);
    }];
    

    UIButton *okButton = [[UIButton alloc] init];
    okButton.backgroundColor = [UIColor colorWithRGB:0x0070C0];
    [okButton setTitle:@"Sure" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    okButton.layer.cornerRadius = 4;
    okButton.layer.masksToBounds = YES;
    [okButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    [okButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(16);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(88);
    }];
}

- (void)sureAction {
    if (self.block && self.textField.text.length > 0) {
        self.block(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
