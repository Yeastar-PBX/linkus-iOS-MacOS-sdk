//
//  DiapadViewCell.m
//  Linkus
//
//  Created by 杨桂福 on 2021/1/11.
//  Copyright © 2021 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "DialpadViewCell.h"
#import "UIImage+YLS.h"

@interface DialpadViewCell ()

@property (nonatomic,strong)    UIButton       *actionBtn;

@property (nonatomic,strong)    UILabel        *nameLabel;

@property (nonatomic,strong)    UILabel        *numberLabel;

@end

@implementation DialpadViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    UIButton *actionBtn = [[UIButton alloc] init];
    self.actionBtn = actionBtn;
    [actionBtn setBackgroundImage:[UIImage imageByColor:[UIColor colorWithRGB:0x000000 alpha:0.04] size:CGSizeMake(self.width, self.height)] forState:UIControlStateHighlighted];
    [self.contentView addSubview:actionBtn];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
    nameLabel.font = FontsizeMedium26;
    [self.contentView addSubview:nameLabel];
    
    UILabel *numberLabel=[[UILabel alloc] init];
    self.numberLabel = numberLabel;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.60];
    numberLabel.font = FontsizeRegular12;
    [self.contentView addSubview:numberLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        if (self.numberLabel.text.length > 0) {
            make.top.mas_equalTo(self.mas_top).offset(11);
        }else{
            make.centerY.mas_equalTo(self.mas_centerY);
        }
    }];
    
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-11);
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(dialpadViewCell:numberTouch:)]) {
        if ([self.number isEqualToString:@"+"]) {
            [self performSelector:@selector(onLongClick:) withObject:sender afterDelay:.5f];
        }
        [self.delegate dialpadViewCell:self numberTouch:self.name];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(dialpadViewCell:numberUpdate:)]) {
        [self.delegate dialpadViewCell:self numberUpdate:@"+"];
    }
}

@end
