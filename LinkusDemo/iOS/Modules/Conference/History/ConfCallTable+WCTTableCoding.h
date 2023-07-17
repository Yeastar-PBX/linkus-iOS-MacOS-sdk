//
//  ConfCallTable+WCTTableCoding.h
//  LinkusDemo (iOS)
//
//  Created by 杨桂福 on 2023/7/14.
//

#import "ConfCallTable.h"
#import <WCDB/WCDB.h>

@interface ConfCallTable (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(host)
WCDB_PROPERTY(members)
WCDB_PROPERTY(meetname)
WCDB_PROPERTY(confid)
WCDB_PROPERTY(datetime)

@end
