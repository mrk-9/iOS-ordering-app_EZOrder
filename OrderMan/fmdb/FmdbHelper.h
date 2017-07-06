//
//  FmdbHelper.h
//  SuperNotesApp
//
//  Created by Devmania on 7/10/15.
//  Copyright (c) 2015 ChangXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FmdbHelper : NSObject

@property (weak, nonatomic) NSString * keyword;

+ (id)sharedInstance:(NSString *)keyword;
- (id)initDatabase:(NSString *)keyword;
- (void)updateData:(NSMutableArray *)updateData;
- (NSMutableArray *)loadData;
- (void)saveData:(NSString *)username password:(NSString *)password;

@end
