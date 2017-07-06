//
//  FmdbHelper.m
//  SuperNotesApp
//
//  Created by Devmania on 7/10/15.
//  Copyright (c) 2015 ChangXing. All rights reserved.
//

#import "FmdbHelper.h"
#import "FMDatabase.h"
#import "AppDelegate.h"

@implementation FmdbHelper

+ (id)sharedInstance:(NSString *)keyword    {
    static FmdbHelper  *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FmdbHelper alloc] initDatabase:keyword];
    });
    return _sharedInstance;
}

- (id)initDatabase:(NSString *)keyword  {
    if (self = [super init]) {
        self.keyword = keyword;
    }
    return self;
}

- (void)saveData:(NSString *) username password:(NSString *) password{
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:delegate.databasePath];
    [db open];
    NSString * query = [NSString stringWithFormat:@"INSERT INTO users (username, password) VALUES ('%@', '%@')", username, password];
    [db executeUpdate:query];
    [db commit];
    [db close];
}

- (NSMutableArray *)loadData    {
    NSMutableArray * loadedData = [[NSMutableArray alloc] init];
    
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:delegate.databasePath];
    [db open];
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM meetingtable WHERE key='%@'", self.keyword];
    FMResultSet *results = [db executeQuery:query];
    while([results next])
    {
        NSData * data = [results dataForColumn:@"data"];
        NSArray * loadArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        loadedData = [NSMutableArray arrayWithArray:loadArray];
    }
    
    [db close];
    
    if (!loadedData) {
        loadedData = [[NSMutableArray alloc] init];
    }
    
    return loadedData;
}

- (void)updateData:(NSMutableArray *)updateData {
    AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:delegate.databasePath];
    [db open];
    NSString * query = [NSString stringWithFormat:@"UPDATE meetingtable SET data='%@' WHERE key='%@'", updateData, self.keyword];
    [db executeUpdate:query];
    [db commit];
    [db close];
}

@end
