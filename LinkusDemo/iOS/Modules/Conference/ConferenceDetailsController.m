//
//  ConferenceDetailsController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/3.
//

#import "ConferenceDetailsController.h"
#import "ConfNameLabel.h"
#import "ConfHeaderView.h"

@interface ConferenceDetailsController ()

@end

@implementation ConferenceDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    
    self.view.backgroundColor = [UIColor colorWithRGB:0xFFFFFF];
    
    ConfNameLabel *nameLabel = [[ConfNameLabel alloc] init];
    [self.view addSubview:nameLabel];
    [nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.top).offset([UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44);
        make.height.mas_equalTo(56);
    }];
    
    ConfHeaderView *headerView = [[ConfHeaderView alloc] init];
    [self.view addSubview:headerView];
    [headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.height.mas_equalTo(100);
    }];
    
}

@end
