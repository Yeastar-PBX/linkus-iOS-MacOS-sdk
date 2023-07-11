//
//  ConferenceListController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/3.
//

#import "ConferenceListController.h"
#import "ConferenceDetailsController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ConferenceBeginController.h"
#import "ConfListTableViewCell.h"

@interface ConferenceListController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, YLSConfManagerDelegate, YLSConfHistoryBuildDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) YLSConfCall *confCall;

@end

@implementation ConferenceListController

- (void)dealloc {
    [[YLSSDK sharedYLSSDK].confManager removeDelegate:self];
    [[YLSSDK sharedYLSSDK].confHistoryManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Conference";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增会议室" style:UIBarButtonItemStylePlain target:self action:@selector(leftAddAction)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height)
                                                          style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delaysContentTouches = NO;
    tableView.backgroundColor = [UIColor colorWithRGB:0xF7F7F7];
    tableView.estimatedRowHeight = 100.f;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:tableView];
    
    [[YLSSDK sharedYLSSDK].confManager addDelegate:self];
    [[YLSSDK sharedYLSSDK].confHistoryManager addDelegate:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConfListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfListTableViewCell"];
    if (!cell) {
        cell = [[ConfListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConfListTableViewCell"];
    }
    cell.confCall = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ConferenceDetailsController *detail = [[ConferenceDetailsController alloc] init];
    detail.confCall = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        @strongify(self)
        YLSConfCall *confCall = self.dataArr[indexPath.row];
        [[YLSSDK sharedYLSSDK].confHistoryManager conferenceHistoryDelete:confCall];
    }];
    deleteAction.backgroundColor = [UIColor colorWithRGB:0xF63B3B];

    UISwipeActionsConfiguration *Configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    Configuration.performsFirstActionWithFullSwipe = NO;
    return Configuration;
}

#pragma mark - YLSConfHistoryBuildDelegate
- (void)conferenceHistoryUpdate:(NSArray<YLSConfCall *> *)conferenceHistorys {
    self.dataArr = conferenceHistorys;
    [self.tableView reloadData];
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [YLSSDK sharedYLSSDK].confHistoryManager.conferenceHistorys;
    }
    return _dataArr;
}

#pragma mark - YLSConfManagerDelegate
- (void)conferenceManager:(YLSConfManager *)manager abnormal:(YLSConfCall *)confCall {
    if (!confCall) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增会议室" style:UIBarButtonItemStylePlain target:self action:@selector(leftAddAction)];
    }else{
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"异常会议室" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    self.confCall = confCall;
}

#pragma mark - 左上角点击事件
- (void)leftAction {
    [self showHUDWithText:@"Getting conference information"];
    [[YLSSDK sharedYLSSDK].confManager operationConferenceMember:[YLSSDK sharedYLSSDK].loginManager.ylsUserNumber confid:self.confCall.confid operationType:ConferenceOperationRecoveryConference complete:^(NSError *error) {
        if (!error) {
            [self hideHUD];
            ConferenceBeginController *vc = [[ConferenceBeginController alloc] init];
            vc.confCall = self.confCall;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        }else if (error.code == ConferenceErrorCustom){
            [self showHUDErrorWithText:@"The conference has ended"];
        }else{
            [self showHUDErrorWithText:@"Server Connection Failure"];
        }
    }];
}

- (void)leftAddAction {
    ConferenceDetailsController *detail = [[ConferenceDetailsController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"EmptyConference"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No Conference History";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                NSForegroundColorAttributeName: [UIColor colorWithRGB:0x595757]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"Create Conference";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                  NSForegroundColorAttributeName:  [UIColor whiteColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 15.0, 10.0, 15.0);
    CGSize titleSize = [@"Create Conference" sizeForFont:[UIFont systemFontOfSize:16.0f] size:CGSizeMake(self.view.width, 16.0f) mode:NSLineBreakByTruncatingTail];
    CGFloat offset = (self.view.width - titleSize.width)/2;
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(-19.0, -offset/2, -19.0, -offset/2);
    UIImage *image = state == UIControlStateNormal?[UIImage imageWithColor:[UIColor colorWithRGB:0x0070C0] size:CGSizeMake(titleSize.width, 38)]:[UIImage imageWithColor:[UIColor colorWithRGB:0x0070C0] size:CGSizeMake(titleSize.width, 38)];
    return [[[image imageByRoundCornerRadius:4] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    ConferenceDetailsController *detail = [[ConferenceDetailsController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
