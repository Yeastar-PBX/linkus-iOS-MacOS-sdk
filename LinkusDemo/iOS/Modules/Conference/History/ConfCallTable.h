//
//  ConfCallTable.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/14.
//

#import <Foundation/Foundation.h>

@interface ConfCallTable : YLSConfCall

+ (void)insertObject:(id)object;

+ (NSArray<ConfCallTable *> *)tableNameGetAllObjects;

+ (void)deleteObject:(id)object;

+ (ConfCallTable *)saveObject:(YLSConfCall *)confCall;

@end
