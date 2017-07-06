//
//  ListOrderViewController.h
//  OrderMan
//
//  Created by System Administrator on 11/3/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListOrderViewController : UIViewController

    @property (nonatomic, strong) NSDictionary *userInfo;
    @property (nonatomic, strong) IBOutlet UITableView   *tblOrderList;
    @property (nonatomic, strong) NSMutableArray   *mlistItems;

    - (IBAction)goback:(id)sender;
    - (IBAction)pressPlus:(id)sender;

@end
