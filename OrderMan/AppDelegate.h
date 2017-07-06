//
//  AppDelegate.h
//  OrderMan
//
//  Created by System Administrator on 11/1/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

#define DELEGATE (AppDelegate *)[[UIApplication sharedApplication]delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *userInfo;

@property (strong, nonatomic) EditViewController *listItemvc;

@property (strong, nonatomic) NSMutableArray *currentItems;
@property (strong, nonatomic) NSMutableDictionary *curShip;
@property (strong, nonatomic) NSString *curOrderId;
@property (nonatomic) bool isOrderEmpty;

@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;


@end
