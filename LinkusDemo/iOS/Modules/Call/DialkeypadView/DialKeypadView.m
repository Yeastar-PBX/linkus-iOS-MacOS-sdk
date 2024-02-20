//
//  DialKeypadView.m
//  Linkus
//
//  Created by 杨桂福 on 2022/11/24.
//  Copyright © 2022 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "DialKeypadView.h"
#import "DialKeypadViewCell.h"
#import "DefActionView.h"
#import "UITextField+YLS.h"
#import "DialPadTextField.h"

@interface DialKeypadView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,DialKeypadViewCellDelegate>

@property (nonatomic,strong) NSArray *dialpadTitleArr;

@property (nonatomic,strong) NSArray *dialpadDetailArr;

@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) DialPadTextField *textField;

@property (nonatomic,strong) UIButton *backspaceBtn;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) DefActionView *contactsView;

@property (nonatomic,strong) DefActionView *callView;

@property (nonatomic,strong) DefActionView *callLogView;

@end

@implementation DialKeypadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfigurator];
        [self setupControls];
    }
    return self;
}

- (void)setupConfigurator {
    self.dialpadTitleArr = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"*", @"0", @"#"];
    self.dialpadDetailArr = @[@" ", @"ABC", @"DEF", @"GHI", @"JKL", @"MNO", @"PQRS", @"TUV", @"WXYZ", @"", @"+", @""];
}

- (void)setupControls {
    UIButton *cancelButton = [[UIButton alloc] init];
    self.cancelButton = cancelButton;
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancelButton setImage:[UIImage imageNamed:@"Call_Close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton sizeToFit];
    [self addSubview:cancelButton];
    
    DialPadTextField *textField = [[DialPadTextField alloc] initWithFrame:CGRectZero];
    self.textField = textField;
    textField.tintColor = [UIColor colorWithRGB:0x0070C0];
    textField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat fontSize = 26.f * ScreenScale;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.minimumFontSize = (fontSize * 2.f) / 3.f;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingHead;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    textField.defaultTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:26.f * ScreenScale weight:UIFontWeightMedium],
                                        NSParagraphStyleAttributeName:paragraphStyle,
                                        NSForegroundColorAttributeName:[UIColor colorWithRGB:0xFFFFFF alpha:0.87]};
    [self addSubview:textField];
    
    UIButton *backspaceBtn = [[UIButton alloc] init];
    self.backspaceBtn = backspaceBtn;
    [backspaceBtn setImage:[UIImage imageNamed:@"Call_DialKeypadView_Backspace"] forState:UIControlStateNormal];
    [backspaceBtn addTarget:self action:@selector(backSpaceTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [backspaceBtn addTarget:self action:@selector(backSpaceTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:backspaceBtn];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.minimumInteritemSpacing = 24.0f;
    flowLayout.minimumLineSpacing = 24.0f * ScreenScale;
    CGFloat width = (ScreenWidth - 276 * ScreenScale)/2;
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0f, width, 0.0f, width);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delaysContentTouches = NO;
    [self addSubview:collectionView];
    
    DefActionView *contactsView = [[DefActionView alloc] init];
    self.contactsView = contactsView;
    [contactsView.actionBtn setImage:[UIImage imageNamed:@"Call_DialKeypadView_Contacts"] forState:UIControlStateNormal];
    [contactsView.actionBtn addTarget:self action:@selector(contactAction:) forControlEvents:UIControlEventTouchUpInside];
    contactsView.actionBtn.backgroundColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    contactsView.nameLabel.text = @"Contacts";
    [self addSubview:contactsView];
    
    DefActionView *callView = [[DefActionView alloc] init];
    self.callView = callView;
    [callView.actionBtn setImage:[UIImage imageNamed:@"Call_DialKeypadView_Call"] forState:UIControlStateNormal];
    callView.actionBtn.backgroundColor = [UIColor colorWithRGB:0x20C161];
    callView.nameLabel.text = @"Call";
    [callView.actionBtn addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:callView];

    DefActionView *callLogView = [[DefActionView alloc] init];
    self.callLogView = callLogView;
    [callLogView.actionBtn setImage:[UIImage imageNamed:@"Call_DialKeypadView_Logs"] forState:UIControlStateNormal];
    [callLogView.actionBtn addTarget:self action:@selector(historyAction:) forControlEvents:UIControlEventTouchUpInside];
    callLogView.actionBtn.backgroundColor = [UIColor colorWithRGB:0xFFFFFF alpha:0.13];
    callLogView.nameLabel.text = @"Call Logs";
    [self addSubview:callLogView];
    
    @weakify(self)
    [RACObserve(self.textField, text) subscribeNext:^(NSString *x) {
        @strongify(self)
        if (x.length > 0 && !self.dtmf) {
            backspaceBtn.hidden = NO;
        }else{
            backspaceBtn.hidden = YES;
        }
    }];
}

#pragma mark - Setter
- (void)setDtmf:(BOOL)dtmf {
    if (dtmf) {
        self.contactsView.hidden = YES;
        self.callView.hidden = YES;
        self.callLogView.hidden = YES;
        self.backspaceBtn.hidden = YES;
        self.textField.text = @"";
        self.textField.userInteractionEnabled = NO;
    } else {
        self.contactsView.hidden = NO;
        self.callView.hidden = NO;
        self.callLogView.hidden = NO;
        self.backspaceBtn.hidden = YES;
        self.textField.text = @"";
        self.textField.userInteractionEnabled = YES;
    }
    _dtmf = dtmf;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(StatusBarHeight + 8);
        make.left.mas_equalTo(self.mas_left).offset(16);
        make.height.mas_equalTo(44);
    }];
    
    [self.callView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-48-TabBarOffset);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(86);
    }];
    
    [self.contactsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.callView.mas_bottom);
        make.right.mas_equalTo(self.callView.mas_left).offset(-40);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(86);
    }];
    
    [self.callLogView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.callView.mas_bottom);
        make.left.mas_equalTo(self.callView.mas_right).offset(40);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(86);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.contactsView.mas_top).offset(-24);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(376);
    }];
    
    [self.backspaceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.collectionView.mas_top).offset(-24);
        make.right.mas_equalTo(self.mas_right).offset(-24);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backspaceBtn.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-60);
        make.left.mas_equalTo(self.mas_left).offset(60);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView registerClass:DialKeypadViewCell.class forCellWithReuseIdentifier:NSStringFromClass(DialKeypadViewCell.class)];
    DialKeypadViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(DialKeypadViewCell.class) forIndexPath:indexPath];
    cell.delegate = self;
    NSString *name = self.dialpadTitleArr[indexPath.row];
    cell.name = name;
    NSString *number = self.dialpadDetailArr[indexPath.row];
    cell.number = number;
    return cell;
}

#pragma mark- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(76, 76);
    return size;
}

#pragma mark - Private
- (void)backAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(dialKeypadViewCancel:)]) {
        [self.delegate dialKeypadViewCancel:button];
    }
}

#pragma mark - DialKeypadViewCellDelegate
- (void)dialKeypadViewCell:(DialKeypadViewCell *)dialKeypadViewCell numberTouch:(NSString *)number {
    [self.textField ys_updateText:number];
    if (self.dtmf) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(dialKeypadViewDtmf:)]) {
            [self.delegate dialKeypadViewDtmf:number];
        }
    }
}

- (void)dialKeypadViewCell:(DialKeypadViewCell *)dialKeypadViewCell numberUpdate:(NSString *)number {
    if (self.textField.text.length > 0) {
        NSInteger location = self.textField.ys_selectedRange.location - 1;
        self.textField.text = [self.textField.text stringByReplacingCharactersInRange:NSMakeRange(location, 1) withString:number];
        [self.textField setYs_selectedRange:NSMakeRange(location + 1, 0)];
    }
}

#pragma mark - Delete Action
- (void)backSpaceTouchDown:(UIButton *)sender {
    [self.textField ys_updateText:@""];
    [self performSelector:@selector(onLongClick:) withObject:sender afterDelay:.5f];
}

- (void)backSpaceTouchUpInside:(UIButton *)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onLongClick:) object:sender];
}

- (void)onLongClick:(UIButton *)sender {
    self.textField.text = @"";
}

#pragma mark - Button Action
- (void)contactAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(dialKeypadViewContacts:)]) {
        [self.delegate dialKeypadViewContacts:sender];
    }
}

- (void)historyAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(dialKeypadViewHistory:)]) {
        [self.delegate dialKeypadViewHistory:sender];
    }
}

#pragma mark - Call Action
- (void)callAction:(UIButton *)sender {
    if (self.textField.text.length > 0) {
        if ([self.delegate respondsToSelector:@selector(dialKeypadViewTransferTo:)]) {
            sender.userInteractionEnabled = NO;
            [self.delegate dialKeypadViewTransferTo:self.textField.text];
            double delayInSeconds = 0.25f;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                sender.userInteractionEnabled = YES;
            });
        }
    }
}

@end
