//
//  CallTransferView.m
//  Linkus
//
//  Created by 杨桂福 on 2022/12/6.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "CallTransferView.h"
#import "NSString+YLS.h"

@interface CallTransferView ()

@property (nonatomic,strong) YLSSipCall *currentCall;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *stateLabel;

@property (nonatomic,strong) dispatch_source_t timer;

@end

@implementation CallTransferView

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
        if (!self.currentCall.onHold) {
            self.stateLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
            self.stateLabel.text = [NSString holdTimeHoursMinutesSecond:self.currentCall.durationTime];
        }else{
            self.stateLabel.textColor = [UIColor colorWithRGB:0xFF6B66];
            self.stateLabel.text = [NSString stringWithFormat:@"%@ %@",@"Hold",[NSString holdTimeHoursMinutesSecond:self.currentCall.holdTime]];
        }
        //dispatch_source_cancel(_myTimer);
    });
    dispatch_resume(_timer);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    imageView.layer.cornerRadius = 22;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];

    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.60];
    nameLabel.font = FontsizeRegular12;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];

    UILabel *stateLabel = [[UILabel alloc] init];
    self.stateLabel = stateLabel;
    stateLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
    stateLabel.font = FontsizeRegular12;
    stateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:stateLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.height.mas_equalTo(44);
        make.top.mas_equalTo(self.mas_top);
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10);
        make.width.mas_equalTo(self.width);
    }];
    
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2);
        make.width.mas_equalTo(self.width);
    }];
}

#pragma mark - 页面设置
- (void)callNormal:(YLSSipCall *)currentCall {
    self.currentCall = currentCall;
    self.imageView.image = currentCall.contact.sipImage;
    self.nameLabel.text = currentCall.serverName;
    self.stateLabel.textColor = [UIColor colorWithRGB:0xFF6B66];
    self.stateLabel.text = [NSString stringWithFormat:@"%@ %@",@"Hold",[NSString holdTimeHoursMinutesSecond:self.currentCall.holdTime]];
}

@end
