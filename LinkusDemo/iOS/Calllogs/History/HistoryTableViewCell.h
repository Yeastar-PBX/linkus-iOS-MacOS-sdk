//
//  HistoryTableViewCell.h
//  Linkus (iOS)
//
//  Created by 杨桂福 on 2023/3/27.
//


#import <UIKit/UIKit.h>
#import "MergeHistory.h"

@class HistoryTableViewCell;

@protocol HistoryTableViewCellDelegate <NSObject>

- (void)historyTableViewCell:(HistoryTableViewCell *)tableViewCell
                  showDetail:(MergeHistory *)history;

@end

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic,  weak) id<HistoryTableViewCellDelegate> delegate;

@property (nonatomic,strong) MergeHistory *history;

@end
