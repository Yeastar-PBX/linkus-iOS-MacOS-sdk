//
//  ConfCenterViewCell.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/5.
//

#import "ConfCenterViewCell.h"

#import "Contact.h"

@interface ConfCenterViewCell ()

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) UILabel *mastLabel;

@property (nonatomic,strong) UIImageView *mastImage;

@end

@implementation ConfCenterViewCell

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
    iconButton.layer.masksToBounds=YES;
    [iconButton addTarget:self action:@selector(clickPictureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:iconButton];
    
    UIImageView *mastImage = [[UIImageView alloc] init];
    self.mastImage = mastImage;
    mastImage.image = [UIImage imageNamed:@"Conference_begin_Mute"];
    mastImage.layer.cornerRadius = 25;
    mastImage.layer.masksToBounds=YES;
    [self.contentView addSubview:mastImage];
    
    UILabel *mastLabel = [[UILabel alloc] init];
    self.mastLabel = mastLabel;
    mastLabel.textColor = [UIColor whiteColor];
    mastLabel.font = [UIFont systemFontOfSize:46];
    mastLabel.textAlignment = NSTextAlignmentCenter;
    mastLabel.text = @"...";
    mastLabel.layer.mask = [self showLoading];
    [self.contentView addSubview:mastLabel];
    
    UIImageView *stateView = [[UIImageView alloc] init];
    self.stateView = stateView;
    [self.contentView addSubview:stateView];
    
    UILabel *nameLabel=[[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font =  [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:nameLabel];
    
    UILabel *numberLabel=[[UILabel alloc] init];
    self.numberLabel = numberLabel;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.48];
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
    
    [self.mastImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(-self.height * 0.118);
        make.height.width.mas_equalTo(52);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.mastLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconButton.mas_centerY).offset(-13);
        make.height.width.mas_equalTo(50);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconButton.mas_bottom).offset(1.5);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(1.5);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
        
    [self.stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.numberLabel.mas_left).offset(-4);
        make.centerY.mas_equalTo(self.numberLabel.mas_centerY);
        make.height.width.mas_equalTo(10);
    }];
}

- (void)setMember:(YLSConfMember *)member {
    if (member) {
        self.stateView.hidden = NO;
        self.numberLabel.hidden = NO;
        if (member.status == ConferenceCallingStatusRinging) {
            if (!self.stateView.isHidden) {
                self.iconButton.alpha = 0.6f;
                self.mastLabel.hidden = NO;
            }else{
                self.iconButton.alpha = 1.0f;
                self.mastLabel.hidden = YES;
            }
            self.stateView.image = [UIImage imageNamed:@"Conference_begin_Ringing"];
        }else if (member.status == ConferenceCallingStatusBridge){
            self.iconButton.alpha = 1.0f;
            self.mastLabel.hidden = YES;
            self.stateView.image = [UIImage imageNamed:@"Conference_begin_Call"];
        }else if (member.status == ConferenceCallingStatusMissedCall){
            self.iconButton.alpha = 1.0f;
            self.mastLabel.hidden = YES;
            self.stateView.image = [UIImage imageNamed:@"Conference_begin_CallFail"];
        }else if (member.status == ConferenceCallingStatusAbnormalDropping){
            self.iconButton.alpha = 1.0f;
            self.mastLabel.hidden = YES;
            self.stateView.image = [UIImage imageNamed:@"Conference_begin_Abnormal"];
        }
        
        if (member.operate == ConferenceSpeakerOperateMute) {
            self.mastImage.hidden = NO;
        }else{
            self.mastImage.hidden = YES;
        }
        
        if (!member.contact) {
            Contact *model = [[Contact alloc] init];
            model.name = member.number;
            member.contact = model;
        }
        [self.iconButton setBackgroundImage:member.contact.sipImage forState:UIControlStateNormal];

        self.nameLabel.text = member.number;
        self.numberLabel.text = member.number;
    }else{
        self.stateView.hidden = YES;
        self.numberLabel.hidden = YES;
        self.mastLabel.hidden = YES;
        self.mastImage.hidden = YES;
    }
    _member = member;
}

- (void)clickPictureAction {
    if (self.clickPicture) {
        self.clickPicture(self.member);
    }
}

- (CAGradientLayer *)showLoading {
    // 创建渐变效果的layer
    CAGradientLayer *graLayer = [CAGradientLayer layer];
    graLayer.frame = self.bounds;
    graLayer.colors = @[(__bridge id)[[UIColor greenColor] colorWithAlphaComponent:0.3].CGColor,
                        (__bridge id)[UIColor yellowColor].CGColor,
                        (__bridge id)[[UIColor yellowColor] colorWithAlphaComponent:0.3].CGColor];
    
    graLayer.startPoint = CGPointMake(0, 0.1);//设置渐变方向起点
    graLayer.endPoint = CGPointMake(1, 0);  //设置渐变方向终点
    graLayer.locations = @[@(0.0), @(0.0), @(0.1)]; //colors中各颜色对应的初始渐变点
    
    // 创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.duration = 2.0f;
    animation.toValue = @[@(0.9), @(1.0), @(1.0)];
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.fillMode = kCAFillModeForwards;
    [graLayer addAnimation:animation forKey:@"xindong"];
    
    return graLayer;
}

@end
