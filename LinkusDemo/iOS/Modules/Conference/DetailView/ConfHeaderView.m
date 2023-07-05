//
//  ConfHeaderView.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/3.
//

#import "ConfHeaderView.h"

@interface ConfHeaderView ()

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation ConfHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    UIImageView *iconView = [[UIImageView alloc] init];
    self.iconView = iconView;
    iconView.layer.cornerRadius = 25;
    iconView.layer.masksToBounds=YES;
    [self addSubview:iconView];
        
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.text = @"1006";
    nameLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
    nameLabel.font =  [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    [self addSubview:nameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.height.width.mas_equalTo(50);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(16);
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
    }];
}

- (void)setContact:(Contact *)contact {
    self.iconView.image = contact.iconImage;
    self.nameLabel.text = contact.name;
    _contact = contact;
}

@end
