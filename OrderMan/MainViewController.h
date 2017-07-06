//
//  MainViewController.h
//  OrderMan
//
//  Created by System Administrator on 11/1/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MainViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIButton   *btnSendMessage;

- (IBAction)orderAdd:(id)sender;
- (IBAction)orderReview:(id)sender;
- (IBAction)contactInfo:(id)sender;
- (IBAction)orderList:(id)sender;


@end
