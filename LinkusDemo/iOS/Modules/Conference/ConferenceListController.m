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

@interface ConferenceListController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, YLSConfManagerDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) YLSConfCall *confCall;

@end

@implementation ConferenceListController

- (void)dealloc {
    [[YLSSDK sharedYLSSDK].confManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Conference";
    
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
    tableView.separatorColor = [UIColor colorWithRGB:0xF2F2F2];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:tableView];
    
    [[YLSSDK sharedYLSSDK].confManager addDelegate:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DailpadHistoryCell"];
    }
    return cell;
}

#pragma mark - YLSConfManagerDelegate
- (void)conferenceManager:(YLSConfManager *)manager abnormal:(YLSConfCall *)confCall {
    if (!confCall) {
        self.navigationItem.rightBarButtonItem = nil;
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
