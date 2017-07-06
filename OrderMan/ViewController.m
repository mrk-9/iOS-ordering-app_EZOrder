//
//  ViewController.m
//  OrderMan
//
//  Created by System Administrator on 11/1/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "RSNetworkClient.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "FMDatabase.h"
#import "Reachability.h"
#import "BaseroutAPI.h"

@interface ViewController () <MBProgressHUDDelegate>

@end

@implementation ViewController {
    MBProgressHUD *HUD;
    NSString *username;
    NSString *password;
    NSMutableDictionary *dic;
    int k;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [_txtUserName setValue:[UIColor grayColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    [_txtPassword setValue:[UIColor grayColor]
                forKeyPath:@"_placeholderLabel.textColor"];
    
    _btnLogin.layer.cornerRadius = 3;
    dic = [NSMutableDictionary dictionary];
    
    self.navigationController.navigationBarHidden = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDefault)
        [textField resignFirstResponder];
    return (textField.returnKeyType == UIReturnKeyDefault);
}

- (void)showError:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@""
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}

- (IBAction)doLogin:(id)sender {
    
    // presentation of the view controllers is up to you.
    
    
    username = _txtUserName.text;
    password = _txtPassword.text;
    
    [self.txtPassword resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    if (([username isEqualToString:@""]) || ([username isEqualToString:@"Username or Email"])) {
        [self showError:@"Input the username"];
        return;
    }
    
    if (([password isEqualToString:@""]) || ([password isEqualToString:@"Password"])){
        [self showError:@"Input the password"];
        return;
    }
    
    if([self CheckInternet] == false)        //No Internet
    {
        [self getAllData];
        for(int i = 0; i < [dic count]; i++)
        {
            NSArray *keys = [dic allKeys];
            NSString *akey = [keys objectAtIndex:i];
            NSString *anObject = [dic objectForKey:akey];
            
            //If user is already registed to DB
            if([username isEqualToString:akey])
            {
                k++;
                if([password isEqualToString:anObject])
                    [self performSegueWithIdentifier:@"login" sender:NULL];
                else
                    [[BaseroutAPI sharedInstance] MessageBox:@"Alert" Message:@"Invalid Password"];
            }
        }
        if(k == 0)
           [[BaseroutAPI sharedInstance] MessageBox:@"Alert" Message:@"This user was not registered when Internet was connected"];
    }else
    {
        RSNetworkClient *loginClient = [[RSNetworkClient alloc] init];
        [loginClient setDelegate:self];
        [loginClient setSelector:@selector(loginClientResponse:)];
        
        NSString *url = server_url;
        
        NSString *postStr = [NSString stringWithFormat:@"&username=%@&password=%@", username, password];
        NSLog(@"%@", postStr);
        [loginClient makeRequest:nil url:url strData:postStr];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    }
}


- (void)loginClientResponse:(NSDictionary *)response {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
//    [0]	(null)	@"response" : 2 key/value pairs
//    key	__NSCFConstantString *	@"response"	0x0005daf8
//    value	__NSDictionaryM *	2 key/value pairs	0x095b84c0
//      [0]	(null)	@"message" : 2 key/value pairs
//      key	__NSCFString *	@"message"	0x095b95c0
//      value	__NSDictionaryM *	2 key/value pairs	0x095f58f0
//      [1]	(null)	@"data" : 2 key/value pairs
//      key	__NSCFString *	@"data"	0x095b8b90
//      value	__NSDictionaryM *	2 key/value pairs	0x095b7c60
//      [0]	(null)	@"user_id" : @"301"
//      [1]	(null)	@"token" : @"2a305260f9129606f0f0926ddf185f18"
    
    
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
                [DELEGATE setUserInfo:dicData];
                
                [self performSegueWithIdentifier:@"login"
                                          sender:NULL];
                
                //Save the user to Local DB
                [self insertData];
            }
            else {
                [self showError:code];
            }
          
        }
    }
}



- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        [self _moveViewByY:-80];
}

- (void)textFieldDidEndEditing:(UITextField *)textField  {
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        [self _moveViewByY:80];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"login"]) {
//        MainViewController* restaurant = (MainViewController*)[segue destinationViewController];
    }
    
}

- (void)insertData {
    
    // Getting the database path.
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"ezorderdb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO users (username,password) VALUES ('%@', '%@')", username, password];
    [database executeUpdate:insertQuery];
    [database close];
}

-(BOOL) CheckInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        return false;
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        return true;
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        return true;
    }
    
    return true;
}

- (void)getAllData
{
    // Getting the database path.
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"ezorderdb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *sqlSelectQuery = @"SELECT * FROM users";
    
    // Query result
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next]) {
        NSString *dbUsername = [NSString stringWithFormat:@"%@",[resultsWithNameLocation stringForColumn:@"username"]];
        NSString *dbPassword = [NSString stringWithFormat:@"%@",[resultsWithNameLocation stringForColumn:@"password"]];
        
        // loading your data into the array, dictionaries.
        NSLog(@"DBusername = %@, DBpassword = %@",dbUsername, dbPassword);
        
        [dic setValue:dbPassword forKey:dbUsername];
    }
    
    if([dic count] == 0)
       [[BaseroutAPI sharedInstance] MessageBox:@"Alert" Message:@"No Internet Connection"];
        
    [database close];
}
@end
