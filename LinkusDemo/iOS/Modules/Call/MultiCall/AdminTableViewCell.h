//
//  AdminTableViewCell.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/13.
//

#import <UIKit/UIKit.h>

@class AdminTableViewCell;

@protocol AdminTableViewCellDelegate <NSObject>

@optional

- (void)adminTableViewCell:(AdminTableViewCell *)cell sipCall:(YLSSipCall *)sipCall muteButton:(UIButton *)button;

- (void)adminTableViewCell:(AdminTableViewCell *)cell sipCall:(YLSSipCall *)sipCall hangupButton:(UIButton *)button;

- (void)adminTableViewCell:(AdminTableViewCell *)cell sipCall:(YLSSipCall *)sipCall detailButton:(UIButton *)button;

@end

@interface AdminTableViewCell : UITableViewCell

@property (nonatomic,strong) YLSSipCall *sipCall;

@property (nonatomic,weak) id<AdminTableViewCellDelegate> delegate;

@end
