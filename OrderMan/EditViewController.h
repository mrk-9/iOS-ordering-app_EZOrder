//
//  EditViewController.h
//  OrderMan
//
//  Created by System Administrator on 11/3/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UIButton   *btnSend;
@property (nonatomic, strong) IBOutlet UIButton   *btnDelete;
@property (nonatomic, strong) IBOutlet UIButton   *btnInfo;

@property (nonatomic, strong) IBOutlet UITextField   *txtQuantity;
@property (nonatomic, strong) IBOutlet UITextField   *txtDescription;
@property (nonatomic, strong) IBOutlet UITextField   *txtUPC;

@property (nonatomic, strong) IBOutlet UITableView   *tblItems;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray   *mcurItems;

- (IBAction)goback:(id)sender;
- (IBAction)pressInfo:(id)sender;
- (IBAction)pressSend:(id)sender;
- (IBAction)pressPlus:(id)sender;
- (IBAction)pressDelete:(id)sender;

@end
