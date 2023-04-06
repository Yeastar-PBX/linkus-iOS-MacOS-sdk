//
//  MenuPanViewCell.m
//  Linkus
//
//  Created by 杨桂福 on 2022/11/22.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "MenuPanViewCell.h"

@interface MenuCellButton : UIButton

@end

@implementation MenuCellButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(10 * ScreenScale, 10 * ScreenScale, 36 * ScreenScale, 36 * ScreenScale);
}

@end

@interface MenuPanViewCell ()

@property (nonatomic,strong) MenuCellButton *iamgeButton;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIImageView *lockView;

@end

@implementation MenuPanViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    MenuCellButton *iamgeButton = [[MenuCellButton alloc] init];
    self.iamgeButton = iamgeButton;
    iamgeButton.layer.cornerRadius = MenuPanViewCellWidth/2;
    iamgeButton.layer.masksToBounds = YES;
    [iamgeButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:iamgeButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14.f * ScreenScale weight:UIFontWeightRegular];
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    
    UIImageView *lockView = [[UIImageView alloc] init];
    self.lockView = lockView;
    lockView.image = [UIImage imageNamed:@"MenuPanView_Camera_Lock"];
    [self.contentView addSubview:lockView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iamgeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.width.mas_equalTo(MenuPanViewCellWidth);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.iamgeButton.mas_bottom).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(-MenuPanViewCellSpacing/2);
        make.right.mas_equalTo(self.mas_right).offset(MenuPanViewCellSpacing/2);
    }];
    
    [self.lockView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(-3);
        make.right.mas_equalTo(self.iamgeButton.mas_right).offset(4);
        make.height.width.mas_equalTo(24);
    }];
}

- (void)setModel:(MenuPanModel *)model {
    self.titleLabel.text = model.title;
    self.titleLabel.textColor = model.fontColor;
    self.iamgeButton.selected = model.selected;
    self.iamgeButton.enabled = model.enabled;
    self.lockView.hidden = !model.showLockView;
    [self.iamgeButton setImage:[UIImage imageNamed:model.normalImageName] forState:UIControlStateNormal];
    [self.iamgeButton setImage:[UIImage imageNamed:model.selectedImageName] forState:UIControlStateSelected];
    [self.iamgeButton setImage:[UIImage imageNamed:model.disableImageName] forState:UIControlStateDisabled];
    if (model.selected) {
        self.iamgeButton.backgroundColor = model.selectedColor;
    }else{
        self.iamgeButton.backgroundColor = model.normalColor;
    }
    _model = model;
}

- (void)touchUpInside:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuPanViewCell:touch:selected:)]) {
        [self.delegate menuPanViewCell:self touch:self.model.type selected:self.model.selected];
    }
}

@end
