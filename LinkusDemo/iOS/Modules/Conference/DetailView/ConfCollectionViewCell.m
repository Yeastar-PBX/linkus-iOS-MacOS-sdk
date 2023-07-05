//
//  ConfCollectionViewCell.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/3.
//

#import "ConfCollectionViewCell.h"

@interface ConfCollectionViewCell ()

@end

@implementation ConfCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

+ (instancetype)dequeueCellWithCollectionView:(UICollectionView *)collectionView
                                    indexPath:(NSIndexPath *)indexPath {
    NSString *className = NSStringFromClass([self class]);
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:className];
    return [collectionView dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
}

- (void)setupControls {
    UIButton *iconButton = [[UIButton alloc] init];
    self.iconButton = iconButton;
    iconButton.layer.cornerRadius = 25;
    iconButton.layer.masksToBounds = YES;
    [iconButton addTarget:self action:@selector(clickPictureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:iconButton];
        
    UILabel *numberLabel=[[UILabel alloc] init];
    self.numberLabel = numberLabel;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.38];
    numberLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:numberLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(-self.height * 0.118);
        make.height.width.mas_equalTo(50);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.iconButton.mas_bottom).offset(3);
    }];
}

- (void)clickPictureAction {
    if (self.clickPicture) {
        self.clickPicture(self.contact);
    }
}

- (void)setContact:(Contact *)contact {
    [self.iconButton setBackgroundImage:contact.iconImage forState:UIControlStateNormal];
    self.numberLabel.text = contact.name;
    _contact = contact;
}

@end
