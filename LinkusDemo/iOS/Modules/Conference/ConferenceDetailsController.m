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
    [self.view addSubview:nameLabel];
    [nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.top).offset([UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44);
        make.height.mas_equalTo(56);
    }];
    
    ConfHeaderView *headerView = [[ConfHeaderView alloc] init];
    Contact *contact = [[Contact alloc] init];
    contact.name = @"1011";
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
    [beginButton addTarget:self action:@selector(beginConference) forControlEvents:UIControlEventTouchUpInside];
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
- (void)beginConference {
    NSLog(@"开始会议室");
    ConferenceBeginController *vc = [[ConferenceBeginController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (NSMutableArray<Contact *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
