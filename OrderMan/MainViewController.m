//
//  MainViewController.m
//  OrderMan
//
//  Created by System Administrator on 11/1/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"


#define DOES_SUPPORT_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ? YES : NO

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [DELEGATE setListItemvc:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _btnSendMessage.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)orderAdd:(id)sender
{
    bool isOrderEmpty = [DELEGATE isOrderEmpty];
    if (isOrderEmpty)
        [[[UIAlertView alloc] initWithTitle:@""
                                message:@"Do you wish to create one?"
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Ok", nil] show];
    else
        [self performSegueWithIdentifier:@"order_add"
                                  sender:NULL];

    
}

- (IBAction)orderList:(id)sender
{
    [self performSegueWithIdentifier:@"order_list"
                              sender:NULL];
}

- (IBAction)contactInfo:(id)sender
{
    [self performSegueWithIdentifier:@"order_contact"
                              sender:NULL];
}

- (IBAction)orderReview:(id)sender
{
    [self performSegueWithIdentifier:@"order_edit"
                              sender:NULL];
}

- (IBAction)sendMessage:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
    
        // set the sendTo address
        NSMutableArray *recipients = [[NSMutableArray alloc] initWithCapacity:1];
        [recipients addObject:@"Aliatoz54@yahoo.com"];
    
        MFMailComposeViewController* mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
    
        [mailController setSubject:@"Ship Date"];
    
        NSDictionary *dic = [DELEGATE curShip];
        
        NSString* formattedBody = [dic valueForKey:@"shipdate"];
    
        [mailController setMessageBody:formattedBody isHTML:NO];
        [mailController setToRecipients:recipients];
    

            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor blackColor], NSForegroundColorAttributeName, nil];
        
            [[mailController navigationBar] setTitleTextAttributes:attributes];
            [[mailController navigationBar ] setTintColor:[UIColor blackColor]];
        

    
        [self.navigationController presentViewController:mailController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    else {
        [self showError:@"Your device doesnt support email service."];
    }
}

- (void)showError:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@""
                                message:message
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"Ok", nil] show];
}

- (IBAction)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self becomeFirstResponder];
	[self dismissViewControllerAnimated:YES completion:nil];
}



-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:    (NSInteger)buttonIndex
{
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
        
        [self performSegueWithIdentifier:@"order_add"
                                  sender:NULL];
        
    }
}
@end
