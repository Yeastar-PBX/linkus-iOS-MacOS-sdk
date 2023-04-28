//
//  CallMemberView.m
//  Linkus
//
//  Created by 杨桂福 on 2022/11/23.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "CallMemberView.h"
#import "MarqueeView.h"
#import "NSString+YLS.h"

@interface CallMemberView ()

@property (nonatomic,strong) YLSSipCall *currentCall;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) MarqueeView *firstLabel;

@property (nonatomic,strong) UILabel *secondLabel;

@property (nonatomic,strong) UILabel *thirdLabel;

@property (nonatomic,strong) UILabel *stateLabel;

@property (nonatomic,strong) dispatch_source_t timer;

@end

@implementation CallMemberView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfigurator];
        [self setupControls];
    }
    return self;
}

- (void)setupConfigurator {
    dispatch_queue_t queue = dispatch_get_main_queue();
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    NSTimeInterval delayTime = 1.0f;
    NSTimeInterval timeInterval = 1.0f;
    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
    dispatch_source_set_timer(_timer, startDelayTime, timeInterval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    @weakify(self)
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self)
        if (self.currentCall.status == CallStatusBridge) {
            if (self.currentCall.onHold) {
                self.stateLabel.textColor = [UIColor colorWithRGB:0xFF6B66];
                self.stateLabel.text = [NSString stringWithFormat:@"%@ %@",@"Hold",[NSString holdTimeHoursMinutesSecond:self.currentCall.holdTime]];
            }else {
                self.stateLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
                self.stateLabel.text = [NSString holdTimeHoursMinutesSecond:self.currentCall.durationTime];
            }
        }
        //dispatch_source_cancel(_myTimer);
    });
    dispatch_resume(_timer);
}

- (void)setupControls {
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    imageView.layer.cornerRadius = 45;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];

    MarqueeView *firstLabel = [[MarqueeView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 64, 24)];
    self.firstLabel = firstLabel;
    [self addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] init];
    self.secondLabel = secondLabel;
    secondLabel.font = [UIFont systemFontOfSize:14.f * ScreenScale weight:UIFontWeightRegular];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc] init];
    self.thirdLabel = thirdLabel;
    thirdLabel.font = [UIFont systemFontOfSize:14.f * ScreenScale weight:UIFontWeightRegular];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:thirdLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.height.mas_equalTo(90);
        make.top.mas_equalTo(self.mas_top);
    }];

    [self.firstLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(20);
        make.width.mas_equalTo(ScreenWidth - 64);
        make.height.mas_equalTo(24);
    }];
    
    [self.secondLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.firstLabel.mas_bottom).offset(4);
    }];
    
    [self.thirdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.secondLabel.mas_bottom).offset(4);
    }];
}

#pragma mark - 页面设置
- (void)callNormal:(YLSSipCall *)currentCall {
    self.currentCall = currentCall;
    self.imageView.image = currentCall.contact.sipImage;
    self.firstLabel.marqueeLabel.text = currentCall.serverName;
    if (self.numberNameSame) {
        self.stateLabel = self.secondLabel;
        self.thirdLabel.hidden = YES;
    } else {
        self.secondLabel.text = [NSString stringWithFormat:@"%@",currentCall.callNumber];
        self.stateLabel = self.thirdLabel;
        self.thirdLabel.hidden = NO;
    }
    self.secondLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.38];
    self.thirdLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.38];
    self.stateLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
    
    if (![YLSSDK sharedYLSSDK].callManager.sipRegister && (currentCall.status == CallStatusConnect || currentCall.status == CallStatusCalling)) {
        self.stateLabel.text = @"Registering…";
        return;
    }
    
    switch (currentCall.status) {
        case CallStatusConnect:{//callKit连接服务器的过程中
            self.stateLabel.text = @"Connecting to server";
        }
            break;
        case CallStatusRemoteRinging:{
            if (currentCall.callIn) {
                self.stateLabel.text = @"";
            }else{
                self.stateLabel.text = @"Ringing…";
            }
        }
            break;
        case CallStatusCalling:{
            self.stateLabel.text = @"Calling…";
        }
            break;
        case CallStatusBridge:{//电话接通
            if (self.currentCall.onHold) {
                self.stateLabel.textColor = [UIColor colorWithRGB:0xFF6B66];
                self.stateLabel.text = [NSString stringWithFormat:@"%@ %@",@"Hold",[NSString holdTimeHoursMinutesSecond:self.currentCall.holdTime]];
            }else {
                self.stateLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
                self.stateLabel.text = [NSString holdTimeHoursMinutesSecond:self.currentCall.durationTime];
            }
        }
            break;
        default:
            break;
    }
}

- (BOOL)numberNameSame {
    return [self.currentCall.serverName isEqualToString:self.currentCall.callNumber];
}

@end
