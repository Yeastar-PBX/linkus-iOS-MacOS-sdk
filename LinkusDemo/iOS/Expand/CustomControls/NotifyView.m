//
//  NotifyView.m
//  Linkus
//
//  Created by 杨桂福 on 2022/12/9.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "NotifyView.h"

#define NotifyViewTag 1664

@interface NotifyView ()<CAAnimationDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation NotifyView

+ (void)notifyView:(NSString *)notify showView:(UIView *)showView hidden:(BOOL)hidden {
    NotifyView *notifyView = [showView viewWithTag:NotifyViewTag];
    if (!notifyView && !hidden) {
        notifyView = [[NotifyView alloc] initWithFrame:CGRectMake(16, 64, ScreenWidth - 32, 40)];
        notifyView.tag = NotifyViewTag;
        [showView addSubview:notifyView];
    }
    notifyView.titleLabel.text = notify;
    if (hidden) {
        [notifyView notifyViewHidden];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfigurator];
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    self.backgroundColor = [UIColor colorWithRGB:0x383838 alpha:0.9];
    self.layer.cornerRadius = 6.f;
    self.layer.masksToBounds = YES;

    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    titleLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
    titleLabel.font = FontsizeRegular13;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [self addSubview:titleLabel];
}

- (void)setupConfigurator {
    CGPoint fromPoint = self.center;
    fromPoint.y = -self.height;
    CGPoint oldPoint = self.center;
    
    CASpringAnimation *springAnim = [CASpringAnimation animationWithKeyPath:@"position"];
    springAnim.fromValue = [NSValue valueWithCGPoint:fromPoint];
    springAnim.toValue = [NSValue valueWithCGPoint:oldPoint];
    springAnim.removedOnCompletion = NO;
    springAnim.fillMode = kCAFillModeForwards;
    springAnim.stiffness = 60;
    springAnim.duration = springAnim.settlingDuration;
    [self.layer addAnimation:springAnim forKey:nil];
}

- (void)notifyViewHidden {
    CGPoint fromPoint = self.center;
    fromPoint.y = -self.height;
    CGPoint oldPoint = self.center;
        
    CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnim.duration = 0.25;
    basicAnim.beginTime = CACurrentMediaTime();
    basicAnim.fromValue = [NSValue valueWithCGPoint:oldPoint];
    basicAnim.toValue = [NSValue valueWithCGPoint:fromPoint];
    basicAnim.removedOnCompletion = NO;
    basicAnim.fillMode = kCAFillModeForwards;
    basicAnim.delegate = self;
    [self.layer addAnimation:basicAnim forKey:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeFromSuperview];
}

@end
