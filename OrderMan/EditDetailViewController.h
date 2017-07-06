//
//  EditDetailViewController.h
//  OrderMan
//
//  Created by System Administrator on 11/3/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDetailViewController : UIViewController <UITextViewDelegate>
{
    UIDatePicker *datePicker;
}

@property (nonatomic, strong) IBOutlet UIButton   *btnSend;
@property (nonatomic, strong) IBOutlet UIButton   *btnDelete;
@property (nonatomic, strong) IBOutlet UIButton   *btnInfo;

@property (nonatomic, strong) IBOutlet UITextField   *txtShipDate;
@property (nonatomic, strong) IBOutlet UITextView   *txtComment;

@property (nonatomic, strong) IBOutlet UITextField   *txtQuantity;
@property (nonatomic, strong) IBOutlet UITextField   *txtDescription;
@property (nonatomic, strong) IBOutlet UITextField   *txtUPC;

@property (nonatomic, strong) IBOutlet UILabel   *lblUserName;
@property (nonatomic, strong) IBOutlet UILabel   *lblUserId;

- (IBAction)goback:(id)sender;
- (IBAction)pressPlus:(id)sender;
- (IBAction)pressSend:(id)sender;
- (IBAction)pressDelete:(id)sender;


@end
