//
//  MeListViewController.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2024/1/24.
//

#import "MeListViewController.h"

@interface MeListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation MeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Me";
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
    tableView.separatorColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    if (@available(iOS 15.0, *)) {
        tableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:tableView];
    
    UISwitch *switcher = [[UISwitch alloc] initWithFrame:CGRectMake(16.0f, 350.0f, 64, 64)];
    [switcher addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    switcher.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"CallWaiting"];
    [tableView addSubview:switcher];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *text = self.dataArr[indexPath.row];
    BOOL result = [YLSCallTool setCodec:text];
    if (result) {
        [self showHUDSuccessWithText:@"成功"];
    }else{
        [self showHUDErrorWithText:@"失败"];
    }
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@"ulaw",@"alaw",@"ilbc",@"g722",@"g729"];
    }
    return _dataArr;
}

- (void)switchAction:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"CallWaiting"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
