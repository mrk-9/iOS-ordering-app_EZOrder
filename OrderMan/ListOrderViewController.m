//
//  ListOrderViewController.m
//  OrderMan
//
//  Created by System Administrator on 11/3/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import "ListOrderViewController.h"
#import "OrderTableViewCell.h"
#import "AppDelegate.h"
#import "RSNetworkClient.h"
#import "MBProgressHUD.h"

@interface ListOrderViewController ()

@end

@implementation ListOrderViewController
{
    float OrderItemCellHeight;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- http://ezordersolution.com/ordershark/index.php/server/get_orders
//GET
// param:
//token	:STRING
//return:
//message:
// type	:STRING		(success=>"success", error=>"error")
//code	:STRING
//data:
//orders	:ARRY
//id		:INT
//user_id		:INT
//datetime	:DATETIME
//ship_date	:DATE
//comment		:STRING
//quantity	:INT
//items		:ARRAY
//id		:INT
//barcode		:STRING
//description	:STRING
//quantity	:INT
//order_id	:INT



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _userInfo = [DELEGATE userInfo];
    _mlistItems = [NSMutableArray array];
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"OrderItem" owner:nil options:nil];
    OrderTableViewCell *cell = [views objectAtIndex:0];
    OrderItemCellHeight = cell.contentView.frame.size.height;
    
   
    
    RSNetworkClient *loginClient = [[RSNetworkClient alloc] init];
    [loginClient setDelegate:self];
    [loginClient setSelector:@selector(listOrderClientResponse:)];
    
    NSString *url = @"http://ezordersolution.com/ordershark/index.php/server/get_orders";
    NSString *token = [_userInfo valueForKey:@"token"];
    
    NSString *getStr = [NSString stringWithFormat:@"%@?token=%@", url, token];
    NSLog(@"%@", getStr);
    
//    [loginClient makeRequest:nil url:url strData:postStr];
    
    
    [loginClient sendRequest:getStr];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)listOrderClientResponse:(NSDictionary *)response {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(!response){
        [self showError:@"Request failed"];
    } else {
        if([response objectForKey:@"response"]) {
            NSDictionary *resdic = [response objectForKey:@"response"];
            
//            NSString *s = [NSString stringWithFormat:@"%@", resdic];
            
            NSDictionary *dicMessage = [resdic objectForKey:@"message"];
            NSString * type = [dicMessage objectForKey:@"type"];
            NSString * code = [dicMessage objectForKey:@"code"];
            
            if ([type isEqualToString:@"success"])
            {
                NSDictionary *dicData = [resdic objectForKey:@"data"];
//            data:
//                orders	:ARRY
//                id		:INT
//                user_id		:INT
//                datetime	:DATETIME
//                ship_date	:DATE
//                comment		:STRING
//                quantity	:INT
//                items		:ARRAY
//				id		:INT
//				barcode		:STRING
//				description	:STRING
//				quantity	:INT
//				order_id	:INT
                
                
                NSMutableArray *orders = [dicData objectForKey:@"orders"];
                
                for (NSMutableDictionary *dic in orders)
                    [_mlistItems addObject:dic];
                
                [_tblOrderList reloadData];
            
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

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:    (NSInteger)buttonIndex
{
    
    NSString *message = alertView.message;
    
    if ([message isEqualToString:@"Do you wish to create one?"])    {
        if(buttonIndex==1)  //Ok
        {
            //Code that will run after you press ok button
            [DELEGATE setIsOrderEmpty:false];
            NSMutableArray *curItems = [DELEGATE currentItems];
            NSMutableDictionary *curShip = [DELEGATE curShip];//NSMutableArray
            
            [curItems removeAllObjects];
            [curShip setValue:@"" forKey:@"shipdate"];
            [curShip setValue:@"" forKey:@"comment"];
            
            [DELEGATE setCurShip:curShip];
            
            [self performSegueWithIdentifier:@"order_add_plus"
                                      sender:NULL];
            
        }
        
    }
    else {
        if(buttonIndex==1)  //Ok
        {
            
            //Code that will run after you press ok button
            NSIndexPath *selectedIndexPath = [_tblOrderList indexPathForSelectedRow];
            NSMutableDictionary *dic = [_mlistItems objectAtIndex:selectedIndexPath.row];
            NSMutableArray *items = [dic valueForKey:@"items"];
            
            [DELEGATE setCurrentItems:items];
            
            NSString *itemShipDate = [dic valueForKey:@"ship_date"];
            NSString *itemComment = [dic valueForKey:@"comment"];
            
            NSMutableDictionary *curShip = [DELEGATE curShip];
            [curShip setValue:itemShipDate forKey:@"shipdate"];
            [curShip setValue:itemComment forKey:@"comment"];
            [DELEGATE setCurShip:curShip];
            
            [DELEGATE setCurOrderId:[dic valueForKey:@"id"]];
            
            [self performSegueWithIdentifier:@"order_list_edit"
                                      sender:NULL];
            
            [DELEGATE setIsOrderEmpty:true];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goback:(id)sender
{
    [self.navigationController popToViewController:(self.navigationController.viewControllers)[1] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mlistItems count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:72 /255.0f green:84 /255.0f blue:85 /255.0f alpha:1.0f]];
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return OrderItemCellHeight;
//}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellIdentifier = @"OrderTableCell";
    
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //            data:
    //                orders	:ARRY
    //                id		:INT
    //                user_id		:INT
    //                datetime	:DATETIME
    //                ship_date	:DATE
    //                comment		:STRING
    //                quantity	:INT
    //                items		:ARRAY
    //				id		:INT
    //				barcode		:STRING
    //				description	:STRING
    //				quantity	:INT
    //				order_id	:INT
    
    NSMutableDictionary *dic = [_mlistItems objectAtIndex:indexPath.row];
    cell.lbldatetime.text = [dic valueForKey:@"datetime"];
    cell.lblDesciption.text = [dic valueForKey:@"comment"];
    cell.lblOrderId.text = [dic valueForKey:@"id"];
    
    cell.lblNumberOfItems.text = [NSString stringWithFormat:@"%lu",[[dic valueForKey:@"items"] count]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    bool isOrderEmpty = [DELEGATE isOrderEmpty];
    if (!isOrderEmpty)
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"You have an order open. Do you wish to continue?"
                                   delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Ok", nil] show];
   else
   {
       
       NSMutableDictionary *dic = [_mlistItems objectAtIndex:indexPath.row];
       NSMutableArray *items = [dic valueForKey:@"items"];
       
       [DELEGATE setCurrentItems:items];
       
       NSString *itemShipDate = [dic valueForKey:@"ship_date"];
       NSString *itemComment = [dic valueForKey:@"comment"];
       
       NSMutableDictionary *curShip = [DELEGATE curShip];
       [curShip setValue:itemShipDate forKey:@"shipdate"];
       [curShip setValue:itemComment forKey:@"comment"];
       [DELEGATE setCurShip:curShip];
       
       [DELEGATE setCurOrderId:[dic valueForKey:@"id"]];
       
       [self performSegueWithIdentifier:@"order_list_edit"
                                 sender:NULL];
   }

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
        [self performSegueWithIdentifier:@"order_add_plus"
                                  sender:NULL];

}


@end
