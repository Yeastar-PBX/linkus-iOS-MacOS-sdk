//
//  ConferenceListController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/3.
//

#import "ConferenceListController.h"
#import "ConferenceDetailsController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface ConferenceListController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation ConferenceListController

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
