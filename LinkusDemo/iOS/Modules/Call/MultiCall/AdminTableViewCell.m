//
//  AdminTableViewCell.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/13.
//

#import "AdminTableViewCell.h"

@interface AdminTableViewCell ()<YLSCallManagerDelegate>

@property (nonatomic,strong) UIImageView *pictureImageView;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIButton *qualityBtn;

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) UIButton *hangupBtn;

@property (nonatomic,strong) UIButton *muteBtn;

@end

@implementation AdminTableViewCell

- (void)dealloc {
    [[[YLSSDK sharedYLSSDK] callManager] removeDelegate:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupControls];
    }
    return self;
}

- (void)setupControls {
    [[[YLSSDK sharedYLSSDK] callManager] addDelegate:self];
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *pictureImageView = [[UIImageView alloc] init];
    self.pictureImageView = pictureImageView;
    pictureImageView.layer.cornerRadius = 18;
    pictureImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:pictureImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font =  [UIFont systemFontOfSize:17.f];
    [self.contentView addSubview:nameLabel];
    
    UIButton *qualityBtn = [[UIButton alloc] init];
    self.qualityBtn = qualityBtn;
    [qualityBtn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    [qualityBtn setImage:[UIImage imageNamed:@"CallAdminView_Quality_Normal"] forState:UIControlStateNormal];
    [qualityBtn setImage:[UIImage imageNamed:@"CallAdminView_Quality_Select"] forState:UIControlStateSelected];
    [self.contentView addSubview:qualityBtn];
        
    UILabel *numberLabel = [[UILabel alloc] init];
    self.numberLabel = numberLabel;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:14.f];
    [self.contentView addSubview:numberLabel];
    
    UIButton *hangupBtn = [[UIButton alloc] init];
    self.hangupBtn = hangupBtn;
    [hangupBtn addTarget:self action:@selector(hangupAction) forControlEvents:UIControlEventTouchUpInside];
    [hangupBtn setImage:[UIImage imageNamed:@"CallAdminView_Hangup_Normal"] forState:UIControlStateNormal];
    [self.contentView addSubview:hangupBtn];
    
    UIButton *muteBtn = [[UIButton alloc] init];
    self.muteBtn = muteBtn;
    [muteBtn addTarget:self action:@selector(muteAction) forControlEvents:UIControlEventTouchUpInside];
    [muteBtn setImage:[UIImage imageNamed:@"CallAdminView_Mute_Normal"] forState:UIControlStateNormal];
    [muteBtn setImage:[UIImage imageNamed:@"CallAdminView_Mute_Select"] forState:UIControlStateSelected];
    [self.contentView addSubview:muteBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.pictureImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(16);
        make.height.width.mas_equalTo(36);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.hangupBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).with.offset(-16);
        make.height.width.mas_equalTo(40);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.muteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.hangupBtn.mas_left).with.offset(-8);
        make.height.width.mas_equalTo(40);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.qualityBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.muteBtn.mas_left).with.offset(-8);
        make.height.width.mas_equalTo(40);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.qualityBtn.mas_left).offset(-2);
        make.top.mas_equalTo(self.pictureImageView.mas_top);
    }];
    
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(self.qualityBtn.mas_left).offset(-2);
        make.bottom.mas_equalTo(self.pictureImageView.mas_bottom);
    }];
}

- (void)detailAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(adminTableViewCell:sipCall:detailButton:)]) {
        [self.delegate adminTableViewCell:self sipCall:self.sipCall detailButton:self.qualityBtn];
    }
}

- (void)muteAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(adminTableViewCell:sipCall:muteButton:)]) {
        [self.delegate adminTableViewCell:self sipCall:self.sipCall muteButton:self.muteBtn];
    }
}

- (void)hangupAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete this participant" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * action) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(adminTableViewCell:sipCall:hangupButton:)]) {
            [self.delegate adminTableViewCell:self sipCall:self.sipCall hangupButton:self.hangupBtn];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:deleteAction];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIViewController *vc = TopestViewController;
        alert.popoverPresentationController.sourceView = self.hangupBtn;
        alert.popoverPresentationController.sourceRect = self.hangupBtn.bounds;
        [vc presentViewController:alert animated:YES completion:nil];
    }else{
        [TopestViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)setSipCall:(YLSSipCall *)sipCall {
    self.nameLabel.text = sipCall.contact.sipName;
    self.pictureImageView.image = sipCall.contact.sipImage;
    self.numberLabel.text = sipCall.contact.sipNumber;
    self.muteBtn.selected = sipCall.remoteMute;
    _sipCall = sipCall;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}

#pragma mark - PJRegisterDelegate
- (void)callManager:(YLSCallManager *)callManager callid:(int)callid callQuality:(BOOL)quality {
    if (self.sipCall.callID == callid) {
        self.qualityBtn.selected = quality;
    }
}

@end
