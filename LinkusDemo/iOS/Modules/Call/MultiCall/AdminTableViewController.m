//
//  AdminTableViewController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/13.
//

#import "AdminTableViewController.h"
#import "AdminTableViewCell.h"
#import "QualityView.h"

@interface AdminTableViewController ()<YLSCallManagerDelegate, AdminTableViewCellDelegate>

@property (nonatomic,strong) UIImageView *backgroundView;

@property (nonatomic,strong) UINavigationController *navi;

@end

@implementation AdminTableViewController

- (void)dealloc {
    [[[YLSSDK sharedYLSSDK] callManager] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"CallAdminView_Back"] forState:UIControlStateNormal];

    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
    [leftView addSubview:backBtn];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    [[[YLSSDK sharedYLSSDK] callManager] addDelegate:self];
    self.tableView.backgroundView = self.backgroundView;
    self.tableView.separatorColor = [UIColor colorWithRGB:0x344B5E];
    self.tableView.scrollEnabled = NO;
    self.title = @"Participant Management";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = [[UINavigationBarAppearance alloc] init];
        barApp.backgroundColor = [UIColor clearColor];
        barApp.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.f weight:UIFontWeightMedium],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
        self.navigationController.navigationBar.scrollEdgeAppearance = nil;
        self.navigationController.navigationBar.standardAppearance = barApp;
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
    self.navi = self.navigationController;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navi.navigationBar.translucent = NO;
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17.f weight:UIFontWeightSemibold],
                                           NSForegroundColorAttributeName:[UIColor colorWithRGB:0x000000 alpha:0.87]};
        appearance.backgroundColor = [UIColor colorWithRGB:0xFFFFFF];
        //修改导航栏下方的横线
        UIImage *colorImage = [UIImage imageWithColor:[UIColor colorWithRGB:0xF2F2F2] size:CGSizeMake(ScreenWidth, 0.5)];
        appearance.shadowImage = colorImage;
        self.navi.navigationBar.scrollEdgeAppearance = appearance;
        self.navi.navigationBar.standardAppearance = appearance;
    }else{
        UIImage *colorImage = [UIImage imageWithColor:[UIColor colorWithRGB:0xF2F2F2] size:CGSizeMake(ScreenWidth, 0.5)];
        [self.navi.navigationBar setShadowImage:colorImage];
    }
}

#pragma mark - CallManagerDelegate
- (void)callManager:(YLSCallManager *)callManager callInfoStatus:(NSMutableArray<YLSSipCall *> *)currenCallArr {
    if (currenCallArr.count == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [YLSSDK sharedYLSSDK].callManager.multiSipCalls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdminTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdminTableViewCell"];
    if (!cell) {
        cell = [[AdminTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AdminTableViewCell"];
        cell.delegate = self;
    }
    cell.sipCall = [YLSSDK sharedYLSSDK].callManager.multiSipCalls[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

#pragma mark - CallAdminTableViewCellDelegate
- (void)adminTableViewCell:(AdminTableViewCell *)cell sipCall:(YLSSipCall *)sipCall muteButton:(UIButton *)button {
    button.selected = !button.selected;
    sipCall.remoteMute = button.selected;
    [[YLSCallTool shareCallTool] setRemoteMute:sipCall];
}

- (void)adminTableViewCell:(AdminTableViewCell *)cell sipCall:(YLSSipCall *)sipCall hangupButton:(UIButton *)button {
    sipCall.hangUpType = HangUpTypeByHand;
    [[YLSCallTool shareCallTool] endCall:sipCall];
}

- (void)adminTableViewCell:(AdminTableViewCell *)cell sipCall:(YLSSipCall *)sipCall detailButton:(UIButton *)button {
    [QualityView qualityViewData:^NSString *{
        return [[YLSCallTool shareCallTool] callQuality];
    } showInView:self.view];
}

#pragma mark - Lazy Load
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _backgroundView.image = [UIImage imageNamed:@"Avatar_CallAdmin"];
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = _backgroundView.frame;
        [_backgroundView addSubview:effectView];
    }
    return _backgroundView;
}

#pragma mark - Private
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
