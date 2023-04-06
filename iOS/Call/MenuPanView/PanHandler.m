//
//  PanHandler.m
//  Linkus
//
//  Created by 杨桂福 on 2022/11/21.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "PanHandler.h"

@interface PanHandler ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIView *presentedView;

@property (nonatomic,weak) UIView *cornerView;

@property (nonatomic,weak) UIButton *dragButton;

@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic,strong) UIImpactFeedbackGenerator *shockFeedback;

@end

@implementation PanHandler

- (instancetype)initWithPresenView:(UIView *)presenView
                        cornerView:(UIView *)cornerView
                 dragIndicatorView:(UIButton *)dragButton {
    self = [super init];
    if (self) {
        _presentedView = presenView;
        [presenView addGestureRecognizer:self.panGestureRecognizer];
        
        _cornerView = cornerView;
        [self addRoundedCornersToView:(MenuPanViewHeightMin - 16)];
        
        _dragButton = dragButton;
        [dragButton addTarget:self action:@selector(dragAction) forControlEvents:UIControlEventTouchUpInside];
        [dragButton setImage:[UIImage imageNamed:@"MenuPanView_Chevron_Up"] forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - Corner
- (void)addRoundedCornersToView:(CGFloat)height {
    CGFloat radius = MenuPanViewRadiusMax - (height - MenuPanViewHeightMin - 16)/(MenuPanViewHeightMax - MenuPanViewHeightMin)*(MenuPanViewRadiusMax - MenuPanViewRadiusMin);
    self.cornerView.layer.cornerRadius = radius;
    self.cornerView.layer.masksToBounds = YES;
}

#pragma mark - height
- (void)addHeightToView:(CGFloat)height {
    UIView *superView = self.presentedView.superview;
    [self.presentedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(superView.mas_bottom).offset(-16-TabBarOffset);
        make.left.mas_equalTo(superView.mas_left).offset(16);
        make.right.mas_equalTo(superView.mas_right).offset(-16);
        make.height.mas_equalTo(height);
    }];
    [self addRoundedCornersToView:height];
}

- (void)dragAction {
    if (self.presentedView.height > 200) {
        [self addHeightToView:MenuPanViewHeightMin];
        [self.dragButton setImage:[UIImage imageNamed:@"MenuPanView_Chevron_Up"] forState:UIControlStateNormal];
    }else{
        [self addHeightToView:MenuPanViewHeightMax];
        [self.dragButton setImage:[UIImage imageNamed:@"MenuPanView_Chevron_Down"] forState:UIControlStateNormal];
    }
    [self.shockFeedback impactOccurred];
}

#pragma mark - Speed
- (BOOL)isVelocityWithinSensitivityRange:(CGFloat)velocity {
    return (fabs(velocity) - 300) > 0;
}

#pragma mark - Distance
- (CGFloat)nearestDistance:(CGFloat)position inDistances:(NSArray *)distances {
    // TODO: need refine this sort code.
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:distances.count];
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:distances.count];

    [distances enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *number = obj;
        NSNumber *absValue = @(fabs(number.floatValue - position));
        [tmpArr addObject:absValue];
        tmpDict[absValue] = number;

    }];

    [tmpArr sortUsingSelector:@selector(compare:)];

    NSNumber *result = tmpDict[tmpArr.firstObject];
    return result.floatValue;
}

static inline BOOL TWO_FLOAT_IS_EQUAL(CGFloat x, CGFloat y) {
    CGFloat minusValue = fabs(x - y);
    CGFloat criticalValue = 0.0001;
    if (minusValue < criticalValue || minusValue < FLT_MIN) {
        return YES;
    }
    return NO;
}

#pragma mark - Pan Gesture Event Handler
- (void)didPanOnView:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            [self handlePanGestureBeginOrChanged:panGestureRecognizer];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [self handlePanGestureEnded:panGestureRecognizer];
        }
            break;
        default: break;
    }
}

#pragma mark - handle did Pan gesture events
- (void)handlePanGestureBeginOrChanged:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGFloat yDisplacement = [panGestureRecognizer translationInView:self.presentedView].y;
    CGFloat height = self.presentedView.height - yDisplacement;
    if (height > MenuPanViewHeightMin && height < MenuPanViewHeightMax) {
        [self addHeightToView:height];
        [self.dragButton setImage:[UIImage imageNamed:@"MenuPanView_Chevron_Line"] forState:UIControlStateNormal];
    }
    [panGestureRecognizer setTranslation:CGPointZero inView:self.presentedView];
}

- (void)handlePanGestureEnded:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.presentedView];
    if ([self isVelocityWithinSensitivityRange:velocity.y]) {
        if (velocity.y < 0) {
            if (self.presentedView.height != MenuPanViewHeightMax) {
                [self addHeightToView:MenuPanViewHeightMax];
                [self.dragButton setImage:[UIImage imageNamed:@"MenuPanView_Chevron_Down"] forState:UIControlStateNormal];
                [self.shockFeedback impactOccurred];
            }
        } else {
            if (self.presentedView.height != MenuPanViewHeightMin) {
                [self addHeightToView:MenuPanViewHeightMin];
                [self.dragButton setImage:[UIImage imageNamed:@"MenuPanView_Chevron_Up"] forState:UIControlStateNormal];
                [self.shockFeedback impactOccurred];
            }
        }
    } else {
        CGFloat position = [self nearestDistance:CGRectGetHeight(self.presentedView.frame) inDistances:@[@(MenuPanViewHeightMin), @(MenuPanViewHeightMax)]];
        if (TWO_FLOAT_IS_EQUAL(position, MenuPanViewHeightMax) && self.presentedView.height != MenuPanViewHeightMax) {
            [self addHeightToView:MenuPanViewHeightMax];
            [self.dragButton setImage:[UIImage imageNamed:@"MenuPanView_Chevron_Down"] forState:UIControlStateNormal];
            [self.shockFeedback impactOccurred];
        } else if (TWO_FLOAT_IS_EQUAL(position, MenuPanViewHeightMin) && self.presentedView.height != MenuPanViewHeightMin) {
            [self addHeightToView:MenuPanViewHeightMin];
            [self.dragButton setImage:[UIImage imageNamed:@"MenuPanView_Chevron_Up"] forState:UIControlStateNormal];
            [self.shockFeedback impactOccurred];
        }
    }
}

#pragma mark - Getter
- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanOnView:)];
        _panGestureRecognizer.minimumNumberOfTouches = 1;
        _panGestureRecognizer.maximumNumberOfTouches = 1;
        _panGestureRecognizer.delegate = self;
    }
    return _panGestureRecognizer;
}

- (UIImpactFeedbackGenerator *)shockFeedback {
    if (!_shockFeedback) {
        _shockFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [_shockFeedback prepare];
    }
    return _shockFeedback;
}

@end
