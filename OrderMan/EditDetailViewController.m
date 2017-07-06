//
//  EditDetailViewController.m
//  OrderMan
//
//  Created by System Administrator on 11/3/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import "EditDetailViewController.h"
#import "AppDelegate.h"
#import "RSNetworkClient.h"
#import "MBProgressHUD.h"

@interface EditDetailViewController ()
    @property (nonatomic, retain) NSDateFormatter * formatter;
@end

@implementation EditDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    bool isOrderEmpty = [DELEGATE isOrderEmpty];
    if (isOrderEmpty) {
        [_btnDelete setEnabled:false];
        [_btnSend setEnabled:false];
    }
    else {
        [_btnDelete setEnabled:true];
        [_btnSend setEnabled:true];
    }
    
    
    
    NSMutableDictionary *curShip = [DELEGATE curShip];
    
    if (curShip)
    {
        _txtShipDate.text = [curShip valueForKey:@"shipdate"];
        _txtComment.text = [curShip valueForKey:@"comment"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _btnSend.layer.cornerRadius = 3;
    _btnInfo.layer.cornerRadius = 3;
    _btnDelete.layer.cornerRadius = 3;

    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    _txtShipDate.inputView = datePicker;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *button=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    [button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           button,
                           nil];
    [numberToolbar sizeToFit];
    
    _txtShipDate.inputAccessoryView = numberToolbar;
    
    
    [_txtDescription setValue:[UIColor grayColor]
                   forKeyPath:@"_placeholderLabel.textColor"];
    [_txtQuantity setValue:[UIColor grayColor]
                forKeyPath:@"_placeholderLabel.textColor"];
    [_txtUPC setValue:[UIColor grayColor]
           forKeyPath:@"_placeholderLabel.textColor"];

//    - http://ezordersolution.com/ordershark/index.php/server/get_user
//    Customer #, Name by token.
//    GET
//param:
//token: string
//    return:
//data:
//    id		:INT
//    username	:STRING
//    password	:STRING
//    company		:STRING
//    email		:STRING
//    phone		:STRING
//    usergrade	:INT(1:admin,0:user)
//    token		:STRING
//message:
//    type	:STRING		(success=>"success", error=>"error")
//    code	:STRING	
    
    RSNetworkClient *getUserClient = [[RSNetworkClient alloc] init];
    [getUserClient setDelegate:self];
    [getUserClient setSelector:@selector(getUserClientResponse:)];
    
    NSDictionary *userInfo = [DELEGATE userInfo];
    NSString *url = @"http://ezordersolution.com/ordershark/index.php/server/get_user";
    NSString *token = [userInfo valueForKey:@"token"];
    
    NSString *getStr = [NSString stringWithFormat:@"%@?token=%@", url, token];
    NSLog(@"%@", getStr);
    
    //    [loginClient makeRequest:nil url:url strData:postStr];
    
    [getUserClient sendRequest:getStr];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)getUserClientResponse:(NSDictionary *)response {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

//    Customer #, Name by token.
//    GET
//param:
//token: string
//    return:
//data:
//    id		:INT
//    username	:STRING
//    password	:STRING
//    company		:STRING
//    email		:STRING
//    phone		:STRING
//    usergrade	:INT(1:admin,0:user)
//    token		:STRING
//message:
//    type	:STRING		(success=>"success", error=>"error")
//    code	:STRING	
//    
    
    if(!response){
        [self showError:@"Request failed"];
    } else {
        if([response objectForKey:@"response"]) {
            NSDictionary *resdic = [response objectForKey:@"response"];
            NSDictionary *dicMessage = [resdic objectForKey:@"message"];
            NSString * type = [dicMessage objectForKey:@"type"];
            NSString * code = [dicMessage objectForKey:@"code"];
            
            if ([type isEqualToString:@"success"])
            {
                NSDictionary *dicData = [resdic objectForKey:@"data"];
                NSString * userid = [dicData objectForKey:@"id"];
                NSString * username = [dicData objectForKey:@"username"];
                
                _lblUserId.text = userid;
                _lblUserName.text = username;
                
//                [DELEGATE setUserInfo:dicData];
                
//                [self performSegueWithIdentifier:@"login"
//                                          sender:NULL];
            }
            else {
                [self showError:code];
            }
            
        }
    }
}

- (void)showError:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@""
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}

-(void)doneWithNumberPad{
    
    [_txtShipDate resignFirstResponder];
    NSDate *selected = [datePicker date];
    //Get the string date
    NSString* dateSelected = [_formatter stringFromDate:selected];
    
    [_txtShipDate setText:dateSelected];
    
    NSMutableDictionary * curShip = [DELEGATE curShip];
    [curShip setObject:dateSelected forKey:@"shipdate"];
    [DELEGATE setCurShip:curShip];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressPlus:(id)sender
{
    
    bool isOrderEmpty = [DELEGATE isOrderEmpty];
    if (isOrderEmpty)
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"Do you wish to create one?"
                                   delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Ok", nil] show];
    else
        [self performSegueWithIdentifier:@"order_info_add_plus"
                                  sender:NULL];

}

- (IBAction)pressDelete:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"Do you want to delete the order?"
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Ok", nil] show];
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:    (NSInteger)buttonIndex
{
    
    NSString *message = alertView.message;
    
    if ([message isEqualToString:@"Do you wish to create one?"])    {
        if(buttonIndex==1)  //Ok
        {
            //Code that will run after you press ok button
            [DELEGATE setIsOrderEmpty:false];
            NSMutableArray *curItems = [DELEGATE currentItems];
            NSMutableArray *curShip = [DELEGATE curShip];
            
            [curItems removeAllObjects];
            [curShip setValue:@"" forKey:@"shipdate"];
            [curShip setValue:@"" forKey:@"comment"];
            
            [DELEGATE setCurShip:curShip];
            
            [self performSegueWithIdentifier:@"order_info_add_plus"
                                      sender:NULL];
            
        }
        
    }
    else {
        if(buttonIndex==1)  //Ok
        {
            //Code that will run after you press ok button
            NSMutableArray *curItems = [DELEGATE currentItems];
            NSMutableArray *curShip = [DELEGATE curShip];
            
            [curItems removeAllObjects];
            [curShip setValue:@"" forKey:@"shipdate"];
            [curShip setValue:@"" forKey:@"comment"];
            
            [DELEGATE setCurShip:curShip];
            [DELEGATE setIsOrderEmpty:true];
            //If this order is database's order
            
            //        NSString *curOrderId = [DELEGATE curOrderId];
            //        if (![curOrderId isEqualToString:@"0"])
            //            [self deleteOrder];
            //        else
            [self performSegueWithIdentifier:@"ship_to_list"
                                      sender:NULL];
        }
    
    }
 }

- (IBAction)pressSend:(id)sender
{
    NSMutableArray *curItems = [DELEGATE currentItems];
    
    NSData *json = [NSJSONSerialization dataWithJSONObject:curItems
                                                   options:0
                                                     error:nil];
    NSString * sjosn = [[NSString alloc] initWithData:json
                                             encoding:NSUTF8StringEncoding];
    
    //    - http://ezordersolution.com/ordershark/index.php/server/add_order
    //    POST
    //param:
    //	token		:STRING
    //	user_id		:INT
    //	datetime	:DATETIME	(ex: 2014-10-27 21:11:44)
    //	ship_date	:DATE		(ex: 2014-10-27)
    //	comment		:STRING
    //	quantity	:INT
    //	items		:ARRAY
    //    barcode		:STRING
    //    description	:STRING
    //    quantity	:STRING
    //    return:
    //message:
    //    type	:STRING		(success=>"success", error=>"error")
    //    code	:STRING
    
    
    RSNetworkClient *addOrderClient = [[RSNetworkClient alloc] init];
    [addOrderClient setDelegate:self];
    [addOrderClient setSelector:@selector(addOrderClientResponse:)];
    
    NSString *url = @"http://ezordersolution.com/ordershark/index.php/server/add_order";
    
    NSString *token;
    NSString *user_id;
    NSString *datetime;
    NSString *ship_date;
    NSString *comment;
    NSString *quantity;
    NSString *items;
    
    NSDictionary *userInfo = [DELEGATE userInfo];
    NSDictionary *curShip = [DELEGATE curShip];
    
    
    token = [userInfo valueForKey:@"token"];
    user_id = [userInfo valueForKey:@"user_id"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];    //(ex: 2014-10-27 21:11:44)
    NSDate *date = [NSDate date];
    //Get the string date
    
    datetime = [formatter stringFromDate:date];
    ship_date = [curShip valueForKey:@"shipdate"];
    comment = [curShip valueForKey:@"comment"];
    quantity = [NSString stringWithFormat:@"%d",[curItems count]];    //    items = sjosn;
    
    NSMutableString *result = [NSMutableString string];
    for (NSMutableDictionary *mdic in curItems)
    {
        if ([result length]>0)
            [result appendString:@";"];
        
        NSMutableString *resultString = [NSMutableString string];
        for (NSString* key in [mdic allKeys]){
            if ([resultString length]>0)
                [resultString appendString:@","];
            [resultString appendFormat:@"%@:%@", key, [mdic objectForKey:key]];
        }
        
        [result appendString:resultString];
    }
    
    
    
    items = result;
    
    
    //    items = @"quantity:6,barcode:789,description:dsfds;quantity:5,barcode:369,description:asdf";
    
    NSString *postStr = [NSString stringWithFormat:@"&token=%@&user_id=%@&datetime=%@&ship_date=%@&comment=%@&quantity=%@&items=%@", token, user_id, datetime, ship_date, comment, quantity, items];
    NSLog(@"%@", postStr);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [addOrderClient makeRequest:nil url:url strData:postStr];
    
}


- (void)addOrderClientResponse:(NSDictionary *)response {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(!response){
        [self showError:@"Request failed"];
    } else {
        if([response objectForKey:@"response"]) {
            NSDictionary *resdic = [response objectForKey:@"response"];
            NSDictionary *dicMessage = [resdic objectForKey:@"message"];
            NSString * type = [dicMessage objectForKey:@"type"];
            NSString * code = [dicMessage objectForKey:@"code"];
            
            if ([type isEqualToString:@"success"])
            {
                
                [self showError:@"Your order has been sent."];
                NSMutableArray *curItems = [DELEGATE currentItems];
                [curItems removeAllObjects];
                [DELEGATE setCurrentItems:curItems];
                
                NSMutableDictionary *curShip = [DELEGATE curShip];
                [curShip setValue:@"" forKey:@"shipdate"];
                [curShip setValue:@"" forKey:@"comment"];
                [DELEGATE setCurShip:curShip];
                
                [DELEGATE setIsOrderEmpty:true];
                
                [self performSegueWithIdentifier:@"ship_to_list"
                                          sender:NULL];
            }
            else {
                [self showError:code];
            }
            
        }
    }
}




-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        if (textView == _txtComment) [self _moveViewByY:-130];
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
        if (textView == _txtComment)
        {
            NSMutableDictionary * curShip = [DELEGATE curShip];
            [curShip setObject:_txtComment.text forKey:@"comment"];
            [DELEGATE setCurShip:curShip];
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                [self _moveViewByY:130];
        }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == _txtComment)
    {
        NSMutableDictionary * curShip = [DELEGATE curShip];
        [curShip setObject:_txtComment.text forKey:@"comment"];
        [DELEGATE setCurShip:curShip];
    }
}


- (void)_moveViewByY:(CGFloat)dy {
    NSTimeInterval animationDuration = 0.2f;
    [self _moveView:self.view byY:dy withAnimationDuration:animationDuration];
}

- (void)_moveView:(UIView *)view byY:(CGFloat)dy withAnimationDuration:(NSTimeInterval)duration {
    __block UIView *blockSafeView = view;
    [UIView animateWithDuration:duration animations:^(void){
        blockSafeView.frame = CGRectOffset(blockSafeView.frame, 0, dy);
    }];
}
@end
