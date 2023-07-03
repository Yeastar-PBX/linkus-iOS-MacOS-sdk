//
//  ConfNameLabel.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/3.
//

#import "ConfNameLabel.h"

@interface ConfNameLabel ()

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation ConfNameLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.text = @"名称:";
    nameLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
    nameLabel.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightMedium];
    [self addSubview:nameLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    self.textField = textField;
    textField.text = @"Conference";
    textField.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightMedium];
    textField.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
    [self addSubview:textField];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.top.mas_equalTo(self.mas_top).offset(16);
    }];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(5);
        make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
    }];
}

@end
