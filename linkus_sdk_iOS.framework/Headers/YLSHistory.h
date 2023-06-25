//
//  YLSHistory.h
//  linkus-vivo
//
//  Created by 杨桂福 on 2023/4/19.
//

#import <Foundation/Foundation.h>
#import "YLSCallProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HistoryState) {
    HistoryStateCallOut = 1,
    HistoryStateAnswer,
    HistoryStateMissed,
};

@interface YLSHistory : NSObject

@property (nonatomic,strong) id<YLSContactProtocol> contact;

@property (nonatomic,copy) NSString *callerName;

@property (nonatomic,copy) NSString *number;

@property (nonatomic,assign) BOOL locate;

@property (nonatomic,assign) HistoryState state;

@property (nonatomic,copy) NSString *historyId;

@property (nonatomic,copy) NSString *linkid;

@property (nonatomic,copy) NSString *duration;

@property (nonatomic,copy) NSString *sourceNumber;

@property (nonatomic,copy) NSString *destinationNumber;

@property (nonatomic,copy) NSString *read;

@property (nonatomic,copy) NSString *calltype;

@property (nonatomic,copy) NSString *timeGMT;

@end

NS_ASSUME_NONNULL_END
