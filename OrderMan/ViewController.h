//
//  ViewController.h
//  OrderMan
//
//  Created by System Administrator on 11/1/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

    @property (nonatomic, strong) IBOutlet UITextField   *txtUserName;
    @property (nonatomic, strong) IBOutlet UITextField   *txtPassword;
    @property (nonatomic, strong) IBOutlet UIButton   *btnLogin;

@end
