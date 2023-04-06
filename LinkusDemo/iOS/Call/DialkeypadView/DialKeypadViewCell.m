//
//  DialKeypadViewCell.m
//  Linkus
//
//  Created by 杨桂福 on 2022/11/24.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "DialKeypadViewCell.h"
#import "UIImage+YLS.h"

@interface DialKeypadViewCell ()

@property (nonatomic,strong)    UIButton       *actionBtn;

@property (nonatomic,strong)    UILabel        *nameLabel;

@property (nonatomic,strong)    UILabel        *numberLabel;

@end

@implementation DialKeypadViewCell

- (void)setupControls {
    UIButton *actionBtn = [[UIButton alloc] init];
    self.actionBtn = actionBtn;
    actionBtn.layer.cornerRadius = 38 * ScreenScale;
    actionBtn.layer.masksToBounds = YES;
    [actionBtn setBackgroundImage:[UIImage imageByColor:[UIColor colorWithRGB:0xFFFFFF alpha:0.13] size:CGSizeMake(self.width, self.height)] forState:UIControlStateNormal];
    [self.contentView addSubview:actionBtn];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
    nameLabel.font = [UIFont systemFontOfSize:26.f * ScreenScale weight:UIFontWeightMedium];
    [self.contentView addSubview:nameLabel];
    
    UILabel *numberLabel=[[UILabel alloc] init];
    self.numberLabel = numberLabel;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.60];
    numberLabel.font = [UIFont systemFontOfSize:12.f * ScreenScale weight:UIFontWeightRegular];
    [self.contentView addSubview:numberLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        if (self.numberLabel.text.length > 0) {
            make.top.mas_equalTo(self.mas_top).offset(14 * ScreenScale);
        }else{
            make.centerY.mas_equalTo(self.mas_centerY);
        }
    }];
    
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-16 * ScreenScale);
    }];
    
    [self.actionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setName:(NSString *)name {
    if ([name isEqualToString:@"*"]) {
        self.nameLabel.text = @"﹡";
    }else{
        self.nameLabel.text = name;
    }
    [self.actionBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    _name = name;
}

- (void)setNumber:(NSString *)number {
    self.numberLabel.text = number;
    if ([number isEqualToString:@"+"]) {
        [self.actionBtn addTarget:self action:@selector(TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.actionBtn removeTarget:self action:@selector(TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    _number = number;
}

- (void)touchDown:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dialKeypadViewCell:numberTouch:)]) {
        if ([self.number isEqualToString:@"+"]) {
            [self performSelector:@selector(onLongClick:) withObject:sender afterDelay:.5f];
        }
        [self.delegate dialKeypadViewCell:self numberTouch:self.name];
    }
    //播放系统按键音 http://iphonedevwiki.net/index.php/AudioServices
    if ([self.name isEqualToString:@"*"]) {
        AudioServicesPlaySystemSound(1210);
    }else if ([self.name isEqualToString:@"#"]) {
        AudioServicesPlaySystemSound(1211);
    }else{
        AudioServicesPlaySystemSound(1200 + self.name.intValue);
    }
}

- (void)TouchUpInside:(UIButton *)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLongClick:) object:sender];
}

- (void)onLongClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dialKeypadViewCell:numberUpdate:)]) {
        [self.delegate dialKeypadViewCell:self numberUpdate:@"+"];
    }
}

@end
