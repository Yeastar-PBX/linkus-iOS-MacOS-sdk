//
//  HistoryTableViewCell.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//

#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell()

@property (nonatomic,strong) UIImageView *pictureImage;

@property (nonatomic,strong) UIImageView *stateImage;

@property (nonatomic,strong) UILabel     *nameLabel;

@property (nonatomic,strong) UILabel     *countLabel;

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel     *typeLabel;

@property (nonatomic,strong) UILabel     *timeLabel;

@property (nonatomic,strong) UIButton    *detailBtn;

@end

@implementation HistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    self.backgroundColor = [UIColor colorWithRGB:0xFFFFFF];
    
    self.separatorInset = UIEdgeInsetsMake(0.0f, 61.0f, 0.0f, 0.0f);
        
    UIImageView *pictureImage = [[UIImageView alloc] init];
    self.pictureImage = pictureImage;
    pictureImage.layer.cornerRadius = 18;
    pictureImage.layer.masksToBounds = YES;
    [self.contentView addSubview:pictureImage];
    
    UIImageView *stateImage = [[UIImageView alloc] init];
    self.stateImage = stateImage;
    [self.contentView addSubview:stateImage];

    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
    nameLabel.font = FontsizeRegular17;
    [self.contentView addSubview:nameLabel];
    
    UILabel *countLabel = [[UILabel alloc] init];
    self.countLabel = countLabel;
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
    countLabel.font = FontsizeRegular17;
    [self.contentView addSubview:countLabel];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:@"Call_Made"];
    self.iconImage = iconImage;
    [self.contentView addSubview:iconImage];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    self.typeLabel = typeLabel;
    typeLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.38];
    typeLabel.font = FontsizeRegular14;
    [self.contentView addSubview:typeLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.38];
    timeLabel.font = FontsizeRegular12;
    [self.contentView addSubview:timeLabel];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailBtn = detailBtn;
    [detailBtn addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    [detailBtn setImage:[UIImage imageNamed:@"Public_Detail_Blue"] forState:UIControlStateNormal];
    [self.contentView addSubview:detailBtn];
}

#pragma mark - 点击事件
- (void)showDetail{
    if (self.delegate && [self.delegate respondsToSelector:@selector(historyTableViewCell:showDetail:)]) {
        [self.delegate historyTableViewCell:self showDetail:self.history];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.pictureImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(15);
        make.height.width.mas_equalTo(36);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.stateImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.pictureImage.mas_right);
        make.bottom.mas_equalTo(self.pictureImage.mas_bottom);
        make.height.width.mas_equalTo(12);
    }];
    
    [self.detailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-5);
        make.height.width.mas_equalTo(44);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    if (self.detailBtn.hidden) {
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }else{
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.detailBtn.mas_left);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImage.mas_right).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(13);
        make.right.mas_equalTo(self.countLabel.mas_left);
    }];
    
    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.timeLabel.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right);
    }];

    [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImage.mas_right).offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-14);
        make.height.width.mas_equalTo(14);
    }];
    
    if (self.iconImage.hidden) {
        [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-13);
        }];
    }else{
        [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImage.mas_right).offset(4);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-13);
        }];
    }
    
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.countLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

-(void)setHistory:(MergeHistory *)history {
    self.typeLabel.text = @"Extension";
    self.stateImage.hidden = YES;
    self.nameLabel.text=[NSString stringWithFormat:@"%@",history.contact.sipName];
    self.countLabel.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)history.theSameHistory.count];
    self.countLabel.hidden = history.theSameHistory.count == 1;
    
    YLSHistory *lastHistory = [history.theSameHistory firstObject];
    
    self.timeLabel.text = [NSString timeCompare:lastHistory.timeGMT];
    
    if (lastHistory.state == HistoryStateMissed) {
        self.nameLabel.textColor = [UIColor colorWithRGB:0xF63B3B];
        self.countLabel.textColor = [UIColor colorWithRGB:0xF63B3B];
    }else{
        self.nameLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
        self.countLabel.textColor = [UIColor colorWithRGB:0x000000 alpha:0.87];
    }
    self.pictureImage.image = history.contact.sipImage;
    
    if (lastHistory.state == HistoryStateCallOut) {
        _iconImage.hidden = NO;
    }else{
        _iconImage.hidden = YES;
    }
    
    _history = history;
}

@end
