//
//  QualityView.m
//  Linkus
//
//  Created by 杨桂福 on 2022/12/9.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "QualityView.h"

//typedef CallQualityModel *(^GetData)(void);

@interface QualityView ()

//@property (nonatomic,strong) UIView *bgView;
//
//@property (nonatomic,strong) UILabel *infoLabel;
//
//@property (nonatomic,strong) dispatch_source_t timer;
//
//@property (nonatomic,copy) GetData getDataHandler;

@end

@implementation QualityView

//+ (void)qualityViewData:(CallQualityModel *(^)(void))handler showInView:(UIView *)view {
//    QualityView *qualityView = [[QualityView alloc] initWithFrame:CGRectMake(0.f, 0.f, ScreenWidth, ScreenHeight)];
//    qualityView.callQualityModel = handler();
//    qualityView.getDataHandler = handler;
//    [view addSubview:qualityView];
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setupConfigurator];
//        [self setupControls];
//    }
//    return self;
//}
//
//- (void)setupConfigurator {
//    dispatch_queue_t queue = dispatch_get_main_queue();
//    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    NSTimeInterval delayTime = 1.0f;
//    NSTimeInterval timeInterval = 1.0f;
//    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
//    dispatch_source_set_timer(_timer, startDelayTime, timeInterval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
//
//    @weakify(self)
//    dispatch_source_set_event_handler(_timer, ^{
//        @strongify(self)
//        self.callQualityModel = self.getDataHandler();
//        //dispatch_source_cancel(_myTimer);
//    });
//    dispatch_resume(_timer);
//}
//
//- (void)setupControls {
//    self.backgroundColor = [UIColor colorWithRGB:0x1b1b1b alpha:0.44];
//
//    UIView *bgView = [[UIView alloc] init];
//    self.bgView = bgView;
//    bgView.layer.cornerRadius = 5.f;
//    bgView.layer.masksToBounds = YES;
//    bgView.backgroundColor = [UIColor colorWithRGB:0x1b1b1b alpha:0.6];
//    [self addSubview:bgView];
//
//    UILabel *infoLabel = [[UILabel alloc] init];
//    self.infoLabel = infoLabel;
//    infoLabel.textColor = [UIColor whiteColor];
//    infoLabel.font = [UIFont systemFontOfSize:15.0f];
//    infoLabel.numberOfLines = 0;
//    infoLabel.backgroundColor = [UIColor clearColor];
//    [self.bgView addSubview:infoLabel];
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(300.f, 360.f));
//    }];
//
//    [self.infoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20);
//        make.right.mas_equalTo(-20);
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = touches.anyObject;
//    if (!(self.bgView == [touch view])) {
//        [self removeFromSuperview];
//    }
//}
//
//#pragma mark - Setter Getter
//- (void)setCallQualityModel:(CallQualityModel *)callQualityModel {
//    NSString *text = [self callQualityText];
//    self.infoLabel.text = [NSString stringWithFormat:text,
//                           callQualityModel.txLossRate,
//                           callQualityModel.txTotal,
//                           callQualityModel.txLoss,
//                           callQualityModel.txDup,
//                           callQualityModel.txRecord,
//                           callQualityModel.txJitter,
//                           callQualityModel.txLevel,
//                           callQualityModel.rxLossRate,
//                           callQualityModel.rxTotal,
//                           callQualityModel.rxLoss,
//                           callQualityModel.rxDup,
//                           callQualityModel.rxRecord,
//                           callQualityModel.rxJitter,
//                           callQualityModel.rxLevel,
//                           callQualityModel.remoteAddr];
//}
//
//- (NSString *)callQualityText {
//    NSString *str = @"Sender loss rate：%@\n";
//    str = [str stringByAppendingString:@"Send RTP packets：%@  \n"];
//    str = [str stringByAppendingString:@"%@ loss\n"];
//    str = [str stringByAppendingString:@"%@ duplicate\n"];
//    str = [str stringByAppendingString:@"%@ out-of-order\n"];
//    str = [str stringByAppendingString:@"Jitter buffer size：%@ ms\n"];
//    str = [str stringByAppendingString:@"TX Level：%@ \n\n"];
//    str = [str stringByAppendingString:@"Receiver loss rate：%@\n"];
//    str = [str stringByAppendingString:@"Received RTP packets：%@  \n"];
//    str = [str stringByAppendingString:@"%@ loss\n"];
//    str = [str stringByAppendingString:@"%@ duplicate\n"];
//    str = [str stringByAppendingString:@"%@ out-of-order\n"];
//    str = [str stringByAppendingString:@"Jitter buffer size：%@ ms\n"];
//    str = [str stringByAppendingString:@"RX Level：%@ \n\n"];
//    str = [str stringByAppendingString:@"From IP Address： %@"];
//    return str;
//}

@end
