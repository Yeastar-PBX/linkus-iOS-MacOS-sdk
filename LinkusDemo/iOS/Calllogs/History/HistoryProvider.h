//
//  HistoryProvider.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/4/20.
//

#import <Foundation/Foundation.h>
#import "MergeHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryProvider : NSObject

+ (void)matchHistorySegment:(int)index
                 completion:(void (^)(NSMutableArray<MergeHistory *> *historys))completion;

@end

NS_ASSUME_NONNULL_END
