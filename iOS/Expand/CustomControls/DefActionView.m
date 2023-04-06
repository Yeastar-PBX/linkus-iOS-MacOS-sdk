//
//  DefActionView.m
//  Linkus
//
//  Created by 杨桂福 on 2022/12/6.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "DefActionView.h"

@implementation DefActionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    UIButton *actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56 * ScreenScale, 56 * ScreenScale)];
    self.actionBtn = actionBtn;
    actionBtn.layer.cornerRadius = 28 * ScreenScale;
    actionBtn.layer.masksToBounds = YES;
    [self addSubview:actionBtn];

    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
    nameLabel.font = [UIFont systemFontOfSize:14.f * ScreenScale weight:UIFontWeightRegular];
    [self addSubview:nameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.actionBtn.mas_bottom).offset(10);
    }];
}

@end
