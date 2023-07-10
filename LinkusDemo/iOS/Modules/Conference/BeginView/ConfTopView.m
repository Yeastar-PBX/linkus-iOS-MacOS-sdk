//
//  ConfTopView.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/5.
//

#import "ConfTopView.h"

#import "Contact.h"

@interface ConfTopView ()

@property (nonatomic,strong) UILabel *confNameLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIButton *iconButton;

@property (nonatomic,strong) UIImageView *stateView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) dispatch_source_t timer;

@property (nonatomic,assign) int count;

@end

@implementation ConfTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControls];
        [self setupConfigurator];
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
        self.count ++ ;
        self.timeLabel.text = [NSString timeFormatted:self.count];
        //dispatch_source_cancel(_myTimer);
    });
    dispatch_resume(_timer);
}

- (void)setupControls {
    self.backgroundColor = [UIColor colorWithRGB:0x475565];
    
    UILabel *confNameLabel = [[UILabel alloc] init];
    self.confNameLabel = confNameLabel;
    confNameLabel.textAlignment = NSTextAlignmentLeft;
    confNameLabel.text = @"Conference";
    confNameLabel.textColor = [UIColor whiteColor];
    confNameLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
    [self addSubview:confNameLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];;
    self.timeLabel = timeLabel;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = @"";
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:timeLabel];
        
    UIButton *iconButton = [[UIButton alloc] init];
    self.iconButton = iconButton;
    iconButton.layer.cornerRadius  = 25;
    iconButton.layer.masksToBounds = YES;
    [iconButton addTarget:self action:@selector(clickPictureAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:iconButton];
    
    UIImageView *stateView = [[UIImageView alloc] init];
    self.stateView = stateView;
    [self addSubview:stateView];
    
    UILabel *nameLabel=[[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
    [self addSubview:nameLabel];
    
    UILabel *numberLabel=[[UILabel alloc] init];
    self.numberLabel = numberLabel;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:13.f];
    [self addSubview:numberLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.top.mas_equalTo(32);
    }];
    
    [self.confNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
    }];
        
    [self.iconButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.height.width.mas_equalTo(50);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-30);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconButton.mas_right).offset(10);
        make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-16);
        make.top.mas_equalTo(self.iconButton.mas_top).offset(4);
    }];
    
    [self.stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.bottom.mas_equalTo(self.iconButton.mas_bottom).offset(-4);
        make.height.width.mas_equalTo(10);
    }];
    
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateView.mas_right).offset(4);
        make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.stateView.mas_centerY);
    }];
}

- (void)clickPictureAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAvatar)]) {
        [self.delegate clickAvatar];
    }
}

- (void)setConfCall:(YLSConfCall *)confCall {
    self.confNameLabel.text = confCall.meetname;
    YLSConfMember *member = confCall.hostMember;
    
    if (member.status == ConferenceCallingStatusMissedCall){
        self.stateView.image = [UIImage imageNamed:@"Conference_begin_CallFail"];
    }else if (member.status == ConferenceCallingStatusAbnormalDropping){
        self.stateView.image = [UIImage imageNamed:@"Conference_begin_Abnormal"];
    }else {
        self.stateView.image = [UIImage imageNamed:@"Conference_begin_Call"];
    }
    self.nameLabel.text = [NSString stringWithFormat:@"Host: %@",member.number];
    self.numberLabel.text = member.number;
    
    Contact *model = [[Contact alloc] init];
    model.name = member.number;
    [self.iconButton setBackgroundImage:model.iconImage forState:UIControlStateNormal];
    
    _confCall = confCall;
}

@end
