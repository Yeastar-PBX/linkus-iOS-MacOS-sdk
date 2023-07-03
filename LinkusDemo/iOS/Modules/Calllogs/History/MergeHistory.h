//
//  MergeHistory.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/4/20.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface MergeHistory : NSObject

@property (nonatomic,strong) Contact *contact;

@property (nonatomic,  copy) NSString *number;

@property (nonatomic,assign) HistoryState state;

@property (nonatomic,strong) NSMutableArray<YLSHistory *> *theSameHistory;

@end

NS_ASSUME_NONNULL_END
