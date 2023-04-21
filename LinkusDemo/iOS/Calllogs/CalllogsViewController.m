//
//  CalllogsViewController.m
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/21.
//

#import "CalllogsViewController.h"
#import "DialpadView.h"
#import "DialpadCallView.h"
#import "HistoryTableViewCell.h"
#import "CallProvider.h"
#import "HistoryProvider.h"

@interface CalllogsViewController ()<DialpadViewDelegate, DialpadCallViewDelegate, HistoryTableViewCellDelegate,
                                     UITableViewDataSource, UITableViewDelegate, YLSHistoryManagerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) DialpadView *dialpadView;

@property (nonatomic,strong) DialpadCallView *dialpadCallView;

@property (nonatomic,strong) NSMutableArray<MergeHistory *> *historys;

@property (nonatomic,assign) int selectIndex;

@end

@implementation CalllogsViewController

- (void)dealloc {
    [[[YLSSDK sharedYLSSDK] historyManager] removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Calls";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightButtonItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_delete_all"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction)];
    UIBarButtonItem *rightButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Login out" style:UIBarButtonItemStylePlain target:self action:@selector(loginOutAction)];
    self.navigationItem.rightBarButtonItems = @[rightButtonItem2,rightButtonItem1];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;

    [self requestAccessAudio];
    [self tableViewAlloc];
    [self dialpadViewAlloc];
    [[[YLSSDK sharedYLSSDK] historyManager] addDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[YLSSDK sharedYLSSDK] historyManager] checkMissedCalls];
}

- (void)requestAccessAudio {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (granted) {
            NSLog(@"同意麦克风权限");
        } else {
            if (status == AVAuthorizationStatusDenied) {
                NSLog(@"不同意麦克风权限");
            } else if (status == AVAuthorizationStatusNotDetermined) {
                NSLog(@"未授权麦克风权限");
            } else if (status == AVAuthorizationStatusRestricted) {
                NSLog(@"AVAuthorizationStatusRestricted");
            }
        }
    }];
}

- (void)tableViewAlloc {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height)
                                                          style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delaysContentTouches = NO;
    tableView.backgroundColor = [UIColor colorWithRGB:0xF7F7F7];
    tableView.estimatedRowHeight = 100.f;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorColor = [UIColor colorWithRGB:0xF2F2F2];
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:tableView];
    [tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(50.0f, 0.f, 0.f, 0.f));
    }];
    [self updataHistory:0];
}

- (void)dialpadViewAlloc {
    DialpadView *dialpadView = [[DialpadView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.dialpadView = dialpadView;
    dialpadView.delegate = self;
    [dialpadView presentInView:self.view];
    self.dialpadCallView.hidden = NO;
    [self.view insertSubview:self.dialpadCallView aboveSubview:dialpadView];
    
    DialpadCallView *dialpadCallView = [[DialpadCallView alloc] init];
    self.dialpadCallView = dialpadCallView;
    dialpadCallView.delegate = self;
    [self.view addSubview:dialpadCallView];
    
    [dialpadCallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(56);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DailpadHistoryCell"];
        cell.delegate = self;
    }
    cell.history = self.historys[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MergeHistory *history = self.historys[indexPath.row];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dialWithNum:) object:history.number];
    [self performSelector:@selector(dialWithNum:) withObject:history.number afterDelay:0.2];
}

- (void)dialWithNum:(NSString *)number {
    [CallProvider baseCallByNumber:number];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        @strongify(self)
        MergeHistory *history = self.historys[indexPath.row];
        [[[YLSSDK sharedYLSSDK] historyManager] historyManagerRemove:history.theSameHistory];
    }];
    deleteAction.backgroundColor = [UIColor colorWithRGB:0xF63B3B];
    
    UISwipeActionsConfiguration *Configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    Configuration.performsFirstActionWithFullSwipe = NO;
    return Configuration;
}

#pragma mark - HistoryTableViewCellDelegate
- (void)historyTableViewCell:(HistoryTableViewCell *)tableViewCell showDetail:(MergeHistory *)history {
    NSLog(@"查看CDR详情");
}

#pragma mark - YLSHistoryManagerDelegate
- (void)historyReload:(NSMutableArray<YLSHistory *> *)historys {
    [self updataHistory:self.selectIndex];
}

- (void)historyMissCallCount:(NSInteger)count {
    NSLog(@"未读数量 %ld",count);
}

- (void)updataHistory:(int)index {
    [HistoryProvider matchHistorySegment:index completion:^(NSMutableArray<MergeHistory *> * _Nonnull historys) {
        self.historys = historys;
        [self.tableView reloadData];
    }];
}

#pragma mark - DialpadViewDelegate
-(void)dialpadView:(DialpadView *)dialpadView searchNumber:(NSString *)number {
    
}

- (void)dialpadViewHidden:(DialpadView *)dialpadView {
    self.dialpadCallView.dialpadShow = NO;
    [self.dialpadCallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-24);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(56);
    }];
}

- (void)dialpadView:(DialpadView *)dialpadView personNumberAdd:(NSString *)number {
    
}

#pragma mark - DialpadCallViewDelegate
- (void)dialpadCallViewShowAction:(DialpadCallView *)dialpadCallView {
    [self.dialpadView presentInView:self.view];
    dialpadCallView.dialpadShow = YES;
    [self.view insertSubview:dialpadCallView aboveSubview:self.dialpadView];
    [self.dialpadCallView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(56);
    }];
}

- (void)dialpadCallViewCallAction:(DialpadCallView *)dialpadCallView touchAction:(BOOL)longTouch {
    [CallProvider baseCallByNumber:self.dialpadView.number];
}

#pragma mark - 右上角点击事件
- (void)loginOutAction {
    [self showHUD];
    [[[YLSSDK sharedYLSSDK] loginManager] logout:^(NSError * _Nullable error) {
        [self hideHUD];
        extern NSString *NotificationLogout;
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NotificationLogout object:nil];
    }];
}

- (void)deleteAction {
    [[[YLSSDK sharedYLSSDK] historyManager] historyManagerRemoveAll];
}

#pragma mark - 左上角点击事件
- (void)leftAction {
    self.selectIndex = self.selectIndex == 1 ? 0 : 1;
    [self updataHistory:self.selectIndex];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.selectIndex == 1 ? @"Missed" : @"All" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

@end
