//
//  AddOrderViewController.h
//  OrderMan
//
//  Created by System Administrator on 11/2/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanditSDKOverlayController.h"
@class ScanDKBarcodePicker;

@interface AddOrderViewController : UIViewController <ScanditSDKOverlayControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField   *txtQuantity;
@property (nonatomic, strong) IBOutlet UITextField   *txtDescription;
@property (nonatomic, strong) IBOutlet UITextField   *txtUPC;
@property (nonatomic, strong) IBOutlet UIButton   *btnReview;
@property (nonatomic, strong) IBOutlet UIButton   *btnSend;
@property (nonatomic, strong) IBOutlet UIButton   *btnDelete;
@property (nonatomic, strong) IBOutlet UILabel   *lblItemAdded;
@property (weak, nonatomic) IBOutlet UILabel *labelUPC;
@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;

@property (nonatomic, strong) UIButton   *flashOnOffButton;
@property (nonatomic, strong) UIButton   *pickerSubviewButton;
@property (strong, nonatomic) IBOutlet UIView *livevideo;

@property (nonatomic, strong) ScanditSDKBarcodePicker *scanditSDKBarcodePicker;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *mCurItem;

- (IBAction)goback:(id)sender;
- (IBAction)pressSend:(id)sender;
- (IBAction)pressReview:(id)sender;
- (IBAction)pressDelete:(id)sender;

- (IBAction)press0:(id)sender;
- (IBAction)press1:(id)sender;
- (IBAction)press2:(id)sender;
- (IBAction)press3:(id)sender;
- (IBAction)press4:(id)sender;
- (IBAction)press5:(id)sender;
- (IBAction)press6:(id)sender;
- (IBAction)press7:(id)sender;
- (IBAction)press8:(id)sender;
- (IBAction)press9:(id)sender;
- (IBAction)pressBack:(id)sender;

- (IBAction)pressUp:(id)sender;
- (IBAction)pressDown:(id)sender;

- (IBAction)pressScan:(id)sender;
- (IBAction)pressEnter:(id)sender;

- (IBAction)flashOnOff:(id)sender;

@end
