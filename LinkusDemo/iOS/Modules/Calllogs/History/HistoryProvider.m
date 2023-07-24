//
//  HistoryProvider.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/4/20.
//

#import "HistoryProvider.h"

@implementation HistoryProvider

+ (void)matchHistorySegment:(int)index
                 completion:(void (^)(NSMutableArray<MergeHistory *> *historys))completion {
    NSMutableArray *historys  = [HistoryProvider sortHistoryWithSegment:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(historys);
    });
}

+ (NSMutableArray<MergeHistory *> *)sortHistoryWithSegment:(int)index {
    NSArray *myHistorys = [[YLSSDK sharedYLSSDK] historyManager].historys;
    if (index == 0) {
        return [HistoryProvider MergeDataWithData:myHistorys];
    }else{
        NSMutableArray<YLSHistory *> *dealArray = [NSMutableArray array];
        for (YLSHistory *history in myHistorys) {
            if (history.state == HistoryStateMissed) {
                [dealArray addObject:history];
            }
        }
        return [HistoryProvider MergeDataWithData:dealArray];
    }
}

+ (NSMutableArray<MergeHistory *> *)MergeDataWithData:(NSArray<YLSHistory *> *)historys {
    NSMutableArray<MergeHistory *> *dealArray = [NSMutableArray array];
    for (unsigned i = 0; i < historys.count ; i++){
        YLSHistory *history = [historys objectAtIndex:historys.count - i -1];
        MergeHistory *mergeHistory = [dealArray firstObject];
        YLSHistory *saveHistory = mergeHistory.theSameHistory.firstObject;
        /**
         *  CDR合并规则
         *  1.同一联系人
         *  2.历史记录状态相同（HistoryStateMissed与HistoryStateAnswer、HistoryStateCallOut区分开）
         */
        
        BOOL first  = saveHistory.number == history.number;
        BOOL second  = NO;
        if ((saveHistory.state == HistoryStateCallOut && history.state == HistoryStateCallOut) || (saveHistory.state != HistoryStateCallOut && history.state != HistoryStateCallOut)) {
            second = YES;
        }
        BOOL third = [saveHistory.historyType isEqualToString:history.historyType];
        
        if (first && second && third) {
            [mergeHistory.theSameHistory insertObject:history atIndex:0];
            mergeHistory.state = history.state;
            mergeHistory.number = history.number;
        }else{
            MergeHistory *notFindHistory = [[MergeHistory alloc] init];
            notFindHistory.historyType = history.historyType;
            notFindHistory.state = history.state;
            notFindHistory.number = history.number;
            [dealArray insertObject:notFindHistory atIndex:0];
            [notFindHistory.theSameHistory insertObject:history atIndex:0];
        }
    }
    return dealArray;
}


@end
