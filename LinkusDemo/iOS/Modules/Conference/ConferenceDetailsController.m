//
//  ConferenceDetailsController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/3.
//

#import "ConferenceDetailsController.h"
#import "ConferenceBeginController.h"
#import "MemberSelectViewController.h"
#import "ConfCollectionViewCell.h"
#import "ConfNameLabel.h"
#import "ConfHeaderView.h"

@interface ConferenceDetailsController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) ConfNameLabel *nameLabel;

@property (nonatomic,strong) NSMutableArray<Contact *> *dataArr;

@end

@implementation ConferenceDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Details";
    
    self.view.backgroundColor = [UIColor colorWithRGB:0xFFFFFF];
    
    ConfNameLabel *nameLabel = [[ConfNameLabel alloc] init];
    nameLabel.textField.text = self.confCall.meetname;
    self.nameLabel = nameLabel;
    [self.view addSubview:nameLabel];
    [nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.top).offset([UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44);
        make.height.mas_equalTo(56);
    }];
    
    ConfHeaderView *headerView = [[ConfHeaderView alloc] init];
    Contact *contact = [[Contact alloc] init];
    contact.name = [YLSSDK sharedYLSSDK].loginManager.ylsUserNumber;
    headerView.contact = contact;
    [self.view addSubview:headerView];
    [headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.height.mas_equalTo(100);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor colorWithRGB:0xFFFFFF];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delaysContentTouches = NO;
    collectionView.scrollEnabled = NO;
    [self.view addSubview:collectionView];
    [collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.width);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(self.view.width * 22/25);
    }];
    
    UIButton *beginButton = [[UIButton alloc] init];
    beginButton.backgroundColor = [UIColor colorWithRGB:0x2CAD4A];
    beginButton.layer.cornerRadius  = 4;
    beginButton.layer.masksToBounds = YES;
    [beginButton setTitle:@"Start Conference" forState:UIControlStateNormal];
    [beginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [beginButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [beginButton addTarget:self action:@selector(beginConference:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginButton];
    [beginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(200 );
        make.top.mas_equalTo(collectionView.mas_bottom);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataArr.count == 8) {
        return 8;
    }else {
        return self.dataArr.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConfCollectionViewCell *cell = [ConfCollectionViewCell dequeueCellWithCollectionView:collectionView
    indexPath:indexPath];
    @weakify(self)
    if (indexPath.row == self.dataArr.count && self.dataArr.count != 8) {
        cell.clickPicture = ^(Contact *contact) {
            @strongify(self)
            MemberSelectViewController *vc = [[MemberSelectViewController alloc] init];
            @weakify(self)
            vc.block = ^(NSString *number) {
                @strongify(self)
                Contact *contact = [[Contact alloc] init];
                contact.number = number;
                contact.name = number;
                [self.dataArr addObject:contact];
                [collectionView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        [cell.iconButton setBackgroundImage:[UIImage imageNamed:@"Conference_add_Normal"] forState:UIControlStateNormal];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d more",(int)(8 - self.dataArr.count)];
    }else{
        cell.clickPicture = ^(Contact *contact) {
            @strongify(self)
            [self.dataArr removeObject:contact];
            [collectionView reloadData];
        };
        Contact *contact = self.dataArr[indexPath.row];
        cell.contact = contact;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(self.view.width/3 - 20, self.view.width/3 * 22/25);
    return size;
}

#pragma mark - 键盘消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 开始会议室
- (void)beginConference:(UIButton *)sender {
    if (self.dataArr.count == 0) {
        [self showHUDErrorWithText:@"请添加联系人"];
        return;
    }
    [self showHUDWithText:@"Start Conference"];
    YLSConfCall *confCall = [[YLSConfCall alloc] init];
    confCall.host = [YLSSDK sharedYLSSDK].loginManager.ylsUserNumber;
    confCall.meetname = self.nameLabel.textField.text;
    NSMutableArray *members = [NSMutableArray array];
    for (Contact *contact in self.dataArr) {
        [members addObject:contact.number];
    }
    confCall.members = members;
    [[YLSSDK sharedYLSSDK].confManager createConference:confCall complete:^(NSError * _Nullable error, NSString * _Nonnull confid) {
        if (!error) {
            [self hideHUD];
            ConferenceBeginController *vc = [[ConferenceBeginController alloc] init];
            confCall.confid = confid;
            vc.confCall = confCall;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
            
            sender.enabled = NO;
            double delayInSeconds = 10;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
                sender.enabled = YES;
            });
        }else if (error.code == ConferenceErrorCustom){
            [self showHUDErrorWithText:@"You have a conference going on."];
        }else if (error.code == ConferenceErrorIllegal){
            //@"[^:!$()/#;,\\[\\]\"=<>&\\\\'`^%@{}|]*"
            [self showHUDErrorWithText:@"非法会议室名称，长度不能超过63且不能有特殊字符"];
        }else{
            [self showHUDErrorWithText:@"Server Connection Failure"];
        }
    }];
}

- (NSMutableArray<Contact *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)setConfCall:(YLSConfCall *)confCall {
    for (NSString *number in confCall.members) {
        Contact *contact = [[Contact alloc] init];
        contact.number = number;
        contact.name = number;
        [self.dataArr addObject:contact];
    }
    _confCall = confCall;
}

@end
