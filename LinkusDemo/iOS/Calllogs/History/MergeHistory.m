//
//  MergeHistory.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/4/20.
//

#import "MergeHistory.h"

@implementation MergeHistory

- (Contact *)contact {
    Contact *model = [[Contact alloc] init];
    model.name = _theSameHistory.firstObject.number;
    return model;
}

- (NSMutableArray<YLSHistory *> *)theSameHistory {
   if (!_theSameHistory) {
       _theSameHistory = [NSMutableArray array];
   }
   return _theSameHistory;
}

@end
