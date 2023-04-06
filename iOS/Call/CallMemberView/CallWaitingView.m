//
//  CallWaitingView.m
//  Linkus
//
//  Created by 杨桂福 on 2023/3/27.
//

#import "CallWaitingView.h"
#import "NSString+YLS.h"

@interface CallWaitingView ()

@property (nonatomic,strong) YLSSipCall *currentCall;

@property (nonatomic,strong) UIButton *actionButton;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *stateLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) dispatch_source_t timer;

@end

@implementation CallWaitingView

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
            self.timeLabel.text = [NSString holdTimeHoursMinutesSecond:self.currentCall.holdTime];
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
    UIButton *actionButton = [[UIButton alloc] init];
    self.actionButton = actionButton;
    [actionButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:actionButton];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    imageView.layer.cornerRadius = 14;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];

    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.87];
    nameLabel.font = FontsizeRegular17;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];

    UILabel *stateLabel = [[UILabel alloc] init];
    self.stateLabel = stateLabel;
    stateLabel.textColor = [UIColor colorWithRGB:0xFF6B66];
    stateLabel.font = FontsizeRegular17;
    stateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:stateLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.textColor = [UIColor colorWithRGB:0xFF6B66];
    timeLabel.font = FontsizeRegular17;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];
    
    self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.24];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.actionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.height.width.mas_equalTo(28);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
        
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.timeLabel.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(13);
        make.right.mas_lessThanOrEqualTo(self.stateLabel.mas_left).offset(-8);
    }];
    
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.stateLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - Setter
- (void)callNormal:(YLSSipCall *)currentCall {
    self.currentCall = currentCall;
    self.imageView.image = currentCall.contact.sipImage;
    self.nameLabel.text = currentCall.serverName;
    self.stateLabel.text = @"Hold";
    self.timeLabel.text = @"00:00";
}

- (void)touchUpInside:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(callWaitingView:callInfo:)]) {
        [self.delegate callWaitingView:self callInfo:self.currentCall];
    }
}

@end
