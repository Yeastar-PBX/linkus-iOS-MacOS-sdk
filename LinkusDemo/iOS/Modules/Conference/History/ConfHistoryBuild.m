//
//  ConfHistoryBuild.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/14.
//

#import "ConfHistoryBuild.h"
#import "ConfCallTable.h"

@interface ConfHistoryBuild ()<YLSConfManagerDelegate>

@property (nonatomic,strong) NSMutableArray<YLSConfCall *> *conferenceArr;

@end

@implementation ConfHistoryBuild

+ (instancetype)shareConfHistoryBuild {
    static ConfHistoryBuild *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ConfHistoryBuild alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[YLSSDK sharedYLSSDK].confManager addDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [[YLSSDK sharedYLSSDK].confManager removeDelegate:self];
}

#pragma mark - YLSConfManagerDelegate
- (void)conferenceManager:(YLSConfManager *)manager callStatus:(YLSSipCall *)sipCall {
    [self conferenceManager:manager conferenceInfo:sipCall.confCall];
}

- (void)conferenceManager:(YLSConfManager *)manager conferenceInfo:(YLSConfCall *)confCall {
    BOOL find = NO;
    YLSConfCall *findConf = nil;
    for (YLSConfCall *historyConf in self.conferenceHistorys) {
        if ([historyConf.confid isEqualToString:confCall.confid]) {
            findConf = historyConf;
            find = YES;
        }
    }
    if (find) {//更新
        NSMutableArray *members = findConf.members;
        for (YLSConfMember *member in confCall.confMembers.mutableCopy) {
            if ([members containsObject:member.number]) {
                [members removeObject:member.number];
            }
            [members addObject:member.number];
        }
        findConf.members = members;
        if (findConf.members.count > 8) {
            NSInteger count = findConf.members.count;
            for (NSInteger i = 0; i < count - 8; i++) {
                [findConf.members removeObjectAtIndex:0];
            }
        }
        [ConfCallTable insertObject:[ConfCallTable saveObject:findConf]];
    }else{//添加
        NSMutableArray *members = [NSMutableArray array];
        [members addObject:[NSString stringWithFormat:@"%@",confCall.host]];
        for (YLSConfMember *member in confCall.confMembers.mutableCopy) {
            [members addObject:[NSString stringWithFormat:@"%@",member.number]];
        }
        confCall.members = members;
        [ConfCallTable insertObject:[ConfCallTable saveObject:confCall]];
        [self.conferenceArr insertObject:confCall atIndex:0];
    }
    
    [self.delegate conferenceHistoryUpdate:self.conferenceArr];
}

- (NSMutableArray<YLSConfCall *> *)conferenceArr {
    if (!_conferenceArr) {
        _conferenceArr = [NSMutableArray array];
        _conferenceArr = [ConfCallTable tableNameGetAllObjects].mutableCopy;
    }
    return _conferenceArr;
}

#pragma mark - YLSConfHistoryBuild
- (NSArray<YLSConfCall *> *)conferenceHistorys {
    return self.conferenceArr;
}

- (void)conferenceHistoryDelete:(YLSConfCall *)model {
    [ConfCallTable deleteObject:model];
    [self.conferenceArr removeObject:model];
    [self.delegate conferenceHistoryUpdate:self.conferenceArr];
}


@end
