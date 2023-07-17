//
//  ConfCallTable.m
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/14.
//

#import "ConfCallTable.h"
#import <WCDB/WCDB.h>

@implementation ConfCallTable

WCDB_IMPLEMENTATION(ConfCallTable)

WCDB_SYNTHESIZE(ConfCallTable, host)
WCDB_SYNTHESIZE(ConfCallTable, members)
WCDB_SYNTHESIZE(ConfCallTable, meetname)
WCDB_SYNTHESIZE(ConfCallTable, confid)
WCDB_SYNTHESIZE(ConfCallTable, datetime)

WCDB_PRIMARY(ConfCallTable, confid)


+ (NSString *)fileCreate:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

#pragma mark - 添加
+ (void)insertObject:(WCTObject *)object {
    NSString *path = [[self fileCreate:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Data"]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",[YLSSDK sharedYLSSDK].loginManager.ylsUserNumber]];
    WCTDatabase *database = [[WCTDatabase alloc] initWithPath:path];
    NSData *password = [@"hMaCFIX#2dW/k]sE-yo(Zf]UJ6SunC" dataUsingEncoding:NSASCIIStringEncoding];
    [database setCipherKey:password];
    [database createTableAndIndexesOfName:NSStringFromClass(ConfCallTable.class) withClass:ConfCallTable.class];
    BOOL result = [database insertOrReplaceObject:object into:NSStringFromClass(ConfCallTable.class)];
    NSLog(@"1111");
}

#pragma mark - 查询
+ (NSArray *)tableNameGetAllObjects {
    if ([YLSSDK sharedYLSSDK].loginManager.ylsUserNumber.length > 0) {
        NSString *path = [[self fileCreate:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Data"]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",[YLSSDK sharedYLSSDK].loginManager.ylsUserNumber]];
        WCTDatabase *database = [[WCTDatabase alloc] initWithPath:path];
        NSData *password = [@"hMaCFIX#2dW/k]sE-yo(Zf]UJ6SunC" dataUsingEncoding:NSASCIIStringEncoding];
        [database setCipherKey:password];
        [database close:^{
    //        [database removeFilesWithError:nil];
        }];
        [database createTableAndIndexesOfName:NSStringFromClass(ConfCallTable.class) withClass:ConfCallTable.class];
        
        NSArray *objects = [database getObjectsOfClass:ConfCallTable.class fromTable:NSStringFromClass(ConfCallTable.class) orderBy:ConfCallTable.datetime.order()];
        if (!objects){
            objects = [NSArray array];
        }
        return objects;
    }else{
        return @[];
    }
}

#pragma mark - 删除
+ (void)deleteObject:(ConfCallTable *)object {
    NSString *path = [[self fileCreate:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Data"]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",[YLSSDK sharedYLSSDK].loginManager.ylsUserNumber]];
    WCTDatabase *database = [[WCTDatabase alloc] initWithPath:path];
    NSData *password = [@"hMaCFIX#2dW/k]sE-yo(Zf]UJ6SunC" dataUsingEncoding:NSASCIIStringEncoding];
    [database setCipherKey:password];
    [database deleteObjectsFromTable:NSStringFromClass(ConfCallTable.class) where:ConfCallTable.confid == object.confid];
}

#pragma mark - 删除
+ (ConfCallTable *)saveObject:(YLSConfCall *)confCall {
    ConfCallTable *table = [[ConfCallTable alloc] init];
    table.host = confCall.host;
    table.members = confCall.members;
    table.meetname = confCall.meetname;
    table.confid = confCall.confid;
    table.datetime = confCall.datetime;
    return table;
}

@end
