//
//  ConfListTableViewCell.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/11.
//

#import "ConfListTableViewCell.h"

@interface ConfListTableViewCell ()

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIImageView *stateImageView;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *countLabel;

@end

@implementation ConfListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    self.backgroundColor = [UIColor colorWithRGB:0xFFFFFF];
            
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
    nameLabel.font = [UIFont systemFontOfSize:17.f weight:UIFontWeightRegular];
    [self.contentView addSubview:nameLabel];
    
    UILabel *countLabel = [[UILabel alloc] init];
    self.countLabel = countLabel;
    countLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
    countLabel.font = [UIFont systemFontOfSize:17.f weight:UIFontWeightRegular];
    [self.contentView addSubview:countLabel];
    
    UIImageView *stateImageView = [[UIImageView alloc] init];
    self.stateImageView = stateImageView;
    [self.contentView addSubview:stateImageView];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.38];
    timeLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightRegular];
    [self.contentView addSubview:timeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.top.mas_equalTo(self.mas_top).offset(13);
        make.right.mas_equalTo(self.countLabel.mas_left);
    }];
    
    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right);
    }];
    
    [self.stateImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        make.height.width.mas_equalTo(18);
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateImageView.mas_right);
        make.right.mas_lessThanOrEqualTo(self.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.stateImageView.mas_centerY);
    }];
    
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.countLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setConfCall:(YLSConfCall *)confCall {
    self.nameLabel.text = confCall.meetname;
    self.countLabel.text = [NSString stringWithFormat:@"(%lu人)",confCall.members.count + 1];

    if ([confCall.host isEqualToString:[YLSSDK sharedYLSSDK].loginManager.ylsUserNumber]) {
        self.stateImageView.image = [UIImage imageNamed:@"Conference_out"];
    }else{
        self.stateImageView.image = [UIImage imageNamed:@"Conference_in"];
    }
    self.timeLabel.text = [NSString timeCompare:confCall.datetime];

    _confCall = confCall;
}

@end
