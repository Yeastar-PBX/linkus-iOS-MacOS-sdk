//
//  DialpadCall.m
//  Linkus
//
//  Created by 杨桂福 on 2021/1/12.
//  Copyright © 2021 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "DialpadCallView.h"

@interface DialpadCallView ()

@property (nonatomic,strong) UIButton    *dialpadCallBtn;

@end

@implementation DialpadCallView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    UIButton *dialpadCallBtn = [[UIButton alloc] init];
    self.dialpadCallBtn = dialpadCallBtn;
    dialpadCallBtn.layer.cornerRadius = 28;
    dialpadCallBtn.layer.masksToBounds = YES;
    dialpadCallBtn.backgroundColor = [UIColor colorWithRGB:0x0070C0];
    [dialpadCallBtn setImage:[UIImage imageNamed:@"Dialpad_Call"] forState:UIControlStateNormal];
    [dialpadCallBtn addTarget:self action:@selector(dialpadAction) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPressCallAction:)];
    gesture.minimumPressDuration = 1.f;
    [dialpadCallBtn addGestureRecognizer:gesture];
    [self addSubview:dialpadCallBtn];

    _dialpadShow = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.dialpadCallBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(56);
    }];
}

#pragma mark - Button Action

- (void)dialpadAction {
    if (self.dialpadShow) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dialpadCallViewCallAction:touchAction:)]) {
            [self.delegate dialpadCallViewCallAction:self touchAction:NO];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(dialpadCallViewShowAction:)]) {
            [self.delegate dialpadCallViewShowAction:self];
        }
    }
}

//长按拨打电话按钮
- (void)onLongPressCallAction:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.dialpadShow && self.delegate && [self.delegate respondsToSelector:@selector(dialpadCallViewCallAction:touchAction:)]) {
            [self.delegate dialpadCallViewCallAction:self touchAction:YES];
        }
    }
}

- (void)setDialpadShow:(BOOL)dialpadShow {
    _dialpadShow = dialpadShow;
    [self animation:dialpadShow];
}

- (void)animation:(BOOL)show {
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    if (show) {
        translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.origin.x + 28, self.frame.origin.y + 28)];
        translation.toValue = [NSValue valueWithCGPoint:CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.frame.origin.y + 28)];
    }else{
        translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.origin.x + 28, self.frame.origin.y + 28)];
        translation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.origin.x + ([UIScreen mainScreen].bounds.size.width/2 - 15), self.frame.origin.y + 28)];
    }
    translation.duration = 0.3;
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:translation forKey:@"translation"];
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if (show) {
        rotation.fromValue = [NSNumber numberWithFloat:M_PI/2];
        rotation.toValue = [NSNumber numberWithFloat:0];
    }else{
        rotation.fromValue = [NSNumber numberWithFloat:-M_PI/2];
        rotation.toValue = [NSNumber numberWithFloat:0];
    }
    rotation.duration = 0.3;
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:rotation forKey:@"rotation"];
    
    [UIView animateWithDuration:0.06 animations:^{
        if (self.dialpadShow) {
            [self.dialpadCallBtn setImage:[UIImage imageNamed:@"Dialpad_Call"] forState:UIControlStateNormal];
        }else{
            [self.dialpadCallBtn setImage:[UIImage imageNamed:@"Dialpad_Up"] forState:UIControlStateNormal];
        }
    }];
}

@end
