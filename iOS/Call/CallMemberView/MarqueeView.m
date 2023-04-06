//
//  MarqueeView.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//

#import "MarqueeView.h"

static CGFloat const kLabelOffset = 20.f;

@interface MarqueeView ()

@property (nonatomic,weak) UIView *innerContainer;

@property (nonatomic,copy) NSString *oldText;

@end

@implementation MarqueeView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfigurator];
    }
    return self;
}

- (void)setupConfigurator {
    self.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.marqueeLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    [self startAnimation];
}

#pragma mark - NSNotification
- (void)appBecomeActive:(NSNotification *)note {
    [self startAnimation];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]){
        NSString *newText = [change valueForKey:NSKeyValueChangeNewKey];
        if (![newText isEqualToString:self.oldText]) {
            [self startAnimation];
            self.oldText = newText;
        }
    }
}

#pragma mark - Private method
- (void)startAnimation {
    [self.innerContainer.layer removeAnimationForKey:@"Marquee"];
    [self bringSubviewToFront:self.innerContainer];
    CGSize size = [self.marqueeLabel.text sizeWithAttributes:@{NSFontAttributeName:self.marqueeLabel.font}];
    
    for (UIView *view in self.innerContainer.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGRect rect = CGRectMake(0.f, 0.f, size.width + kLabelOffset, CGRectGetHeight(self.bounds));
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.marqueeLabel.text;
    label.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
    label.font = [UIFont systemFontOfSize:17.f * ScreenScale weight:UIFontWeightSemibold];
    label.textAlignment = NSTextAlignmentCenter;
    [self.innerContainer addSubview:label];
    
    if (size.width > CGRectGetWidth(self.bounds)) {
        CGRect nextRect = rect;
        nextRect.origin.x = size.width + kLabelOffset;
        
        UILabel *nextLabel = [[UILabel alloc] initWithFrame:nextRect];
        nextLabel.backgroundColor = [UIColor clearColor];
        nextLabel.text = self.marqueeLabel.text;
        nextLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
        nextLabel.font = [UIFont systemFontOfSize:17.f * ScreenScale weight:UIFontWeightSemibold];
        nextLabel.textAlignment = NSTextAlignmentCenter;
        [self.innerContainer addSubview:nextLabel];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        animation.keyTimes = @[@0.f, @1.f];
        animation.duration = size.width / 50.f;
        animation.values = @[@0, @(-(size.width + kLabelOffset))];
        animation.repeatCount = INT16_MAX;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
        [self.innerContainer.layer addAnimation:animation forKey:@"Marquee"];
    } else {
        label.frame = self.bounds;
    }
}

#pragma mark - Getter
- (UILabel *)marqueeLabel {
    if (!_marqueeLabel) {
        _marqueeLabel = [[UILabel alloc] init];
        _marqueeLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
        _marqueeLabel.font = [UIFont systemFontOfSize:17.f * ScreenScale weight:UIFontWeightSemibold];
        _marqueeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _marqueeLabel;
}

- (UIView *)innerContainer {
    if (!_innerContainer) {
        UIView *innerContainer = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:innerContainer];
        _innerContainer = innerContainer;
    }
    return _innerContainer;
}
@end
