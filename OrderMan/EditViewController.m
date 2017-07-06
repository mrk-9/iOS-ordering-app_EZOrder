//
//  EditViewController.m
//  OrderMan
//
//  Created by System Administrator on 11/3/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import "EditViewController.h"
#import "OrderSearchItemCell.h"
#import "AppDelegate.h"
#import "RSNetworkClient.h"
#import "UISearchBar+Blocks.h"
#import "MBProgressHUD.h"
#import "AddOrderViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController {
    
}

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
    
    //    [self getFriendsInfo];
    bool isOrderEmpty = [DELEGATE isOrderEmpty];
    if (isOrderEmpty) {
        [_btnDelete setEnabled:false];
        [_btnSend setEnabled:false];
    }
    else {
        [_btnDelete setEnabled:true];
        [_btnSend setEnabled:true];
    }
    
    [_tblItems reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
       _btnSend.layer.cornerRadius = 3;
       _btnInfo.layer.cornerRadius = 3;
       _btnDelete.layer.cornerRadius = 3;
    
    [_txtDescription setValue:[UIColor grayColor]
                   forKeyPath:@"_placeholderLabel.textColor"];
    [_txtQuantity setValue:[UIColor grayColor]
                forKeyPath:@"_placeholderLabel.textColor"];
    [_txtUPC setValue:[UIColor grayColor]
           forKeyPath:@"_placeholderLabel.textColor"];
    
    _mcurItems = [DELEGATE currentItems];
    
    EditViewController *sharedEditViewVC = [DELEGATE listItemvc];
    if (!sharedEditViewVC)
        sharedEditViewVC = self;

   
    
    // enable search button in empty space state.
    UITextField *searchBarTextField = nil;
    for (UIView *mainview in _searchBar.subviews) {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
            if ([mainview isKindOfClass:[UITextField class]]) {
                searchBarTextField = (UITextField *)mainview;
                break;
            }
        }
        for (UIView *subview in mainview.subviews) {
            if ([subview isKindOfClass:[UITextField class]]) {
                searchBarTextField = (UITextField *)subview;
                break;
            }
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
    //
    
    __weak typeof(self) weakSelf = self;
    [self.searchBar setSearchBarSearchButtonClickedBlock:^void(UISearchBar *searchBar) {
        // do your stuff here
        [weakSelf.searchBar resignFirstResponder];
        
        NSMutableArray *curItems = [DELEGATE currentItems];
        NSMutableArray *searchItems = [NSMutableArray array];
        
        if ([weakSelf.searchBar.text isEqualToString:@""])
        {
            _mcurItems = curItems;
            [weakSelf.tblItems reloadData];
            return;
        }

        //barcode		:STRING
        //description	:STRING
        //quantity	:STRING
        

        for (NSMutableDictionary *mdic in curItems){
            NSString *barcode = [mdic valueForKey:@"barcode"];

            if ([barcode rangeOfString:_searchBar.text].location == NSNotFound) {
                NSLog(@"string does not contain bla");
            } else {
                NSLog(@"string contains bla!");
                [searchItems addObject:mdic];
            }
        }
     
        _mcurItems = searchItems;
        
        [weakSelf.tblItems reloadData];
        
        return ;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:72 /255.0f green:84 /255.0f blue:85 /255.0f alpha:1.0f]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mcurItems count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    static NSString *cellIdentifier = @"OrderSTableCell1";
    
    OrderSearchItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[OrderSearchItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    //barcode		:STRING
    //description	:STRING
    //quantity	:STRING
    
    NSMutableDictionary *dic = [_mcurItems objectAtIndex:indexPath.row];
    NSString *sbarcode = [dic valueForKey:@"barcode"];
    
    if(![sbarcode isEqual:[NSNull null]])
        cell.lblUPC.text = [dic valueForKey:@"barcode"];
    
    NSString *sdescript = [dic valueForKey:@"description"];
    if(![sdescript isEqual:[NSNull null]])
        cell.lblDescription.text = [dic valueForKey:@"description"];
    else
        cell.lblDescription.text = @"description not found";

//    cell.lblDescription.text = [dic valueForKey:@"description did not found"];
//    else
//        cell.lblDescription.text = @"";

    NSString *sQuantity = [dic valueForKey:@"quantity"];
    if(![sQuantity isEqual:[NSNull null]])
        cell.lblQuantity.text = [dic valueForKey:@"quantity"];
    
////    NSLog(@"in the pricearray %@", [priceArray objectAtIndex:row]);
//    cell.label2.text = @"ok";

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    bool isOrderEmpty = [DELEGATE isOrderEmpty];
    if (isOrderEmpty)
        return;
    
    NSMutableArray *currentItems = [DELEGATE currentItems];
    
    NSMutableDictionary *dic = [_mcurItems objectAtIndex:indexPath.row];
    NSString *sbarcode = [dic valueForKey:@"barcode"];
   
    int ni = 0;
    for (NSMutableDictionary *mdic in currentItems)
    {
        NSString *barcode = [mdic valueForKey:@"barcode"];
        if ([barcode isEqualToString:sbarcode])
            break;
        ni++;
    }
    
    [self performSegueWithIdentifier:@"order_item_edit"
                              sender:[NSString stringWithFormat:@"%ld",(long)ni]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"order_item_edit"]) {
        
        AddOrderViewController* addOrderView = (AddOrderViewController*)[segue destinationViewController];
        NSString *nrow = (NSString*)sender;
        
       
        addOrderView.mCurItem = nrow;
    }
}


- (IBAction)goback:(id)sender
{
    [DELEGATE setListItemvc:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressInfo:(id)sender
{
    [self performSegueWithIdentifier:@"order_detail"
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
            
            [self performSegueWithIdentifier:@"order_edit_insert_plus"
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
            [self performSegueWithIdentifier:@"order_edit_list"
                                      sender:NULL];
        }
    }

}

- (void)deleteOrder
{
//    - http://ezordersolution.com/ordershark/index.php/server/delete_order
//    POST
//param:
//token: string
//order_id: string
//    return:
//    
//message:
//    type	:STRING		(success=>"success", error=>"error")
//    code	:STRING
//
    
    RSNetworkClient *delOrderClient = [[RSNetworkClient alloc] init];
    [delOrderClient setDelegate:self];
    [delOrderClient setSelector:@selector(delOrderClientResponse:)];
    
    NSString *url = @"http://ezordersolution.com/ordershark/index.php/server/delete_order";
    NSDictionary *userInfo = [DELEGATE userInfo];
    NSString *token = [userInfo valueForKey:@"token"];
    
    NSString *curOrderId = [DELEGATE curOrderId];
    
    NSString *postStr = [NSString stringWithFormat:@"&token=%@&order_id=%@", token, curOrderId];
    NSLog(@"%@", postStr);
    [delOrderClient makeRequest:nil url:url strData:postStr];
    
    [DELEGATE setCurOrderId:@"0"];
    
}

- (void)delOrderClientResponse:(NSDictionary *)response {
   
   
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
                [self performSegueWithIdentifier:@"order_edit_list"
                                          sender:NULL];
                
                NSMutableArray *curItems = [DELEGATE currentItems];
                [curItems removeAllObjects];
                [DELEGATE setCurrentItems:curItems];
                
                NSMutableDictionary *curShip = [DELEGATE curShip];
                [curShip setValue:@"" forKey:@"shipdate"];
                [curShip setValue:@"" forKey:@"comment"];
                [DELEGATE setCurShip:curShip];
                
                [DELEGATE setIsOrderEmpty:true];
            }
            else {
                [self showError:code];
            }
            
        }
    }
}


- (IBAction)pressSend:(id)sender
{
    NSMutableArray *curItems = [DELEGATE currentItems];
    
//    NSData *json = [NSJSONSerialization dataWithJSONObject:curItems
//                                                   options:0
//                                                     error:nil];
//    NSString * sjosn = [[NSString alloc] initWithData:json
//                                  encoding:NSUTF8StringEncoding];
    
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
    quantity = [NSString stringWithFormat:@"%lu",(unsigned long)[curItems count]];
//    items = sjosn;
    
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
                
                [self performSegueWithIdentifier:@"order_edit_list"
                                          sender:NULL];
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
        [self performSegueWithIdentifier:@"order_edit_insert_plus"
                                  sender:NULL];
    
}

- (void)filterContentForSearchBarText:(NSString *)searchText scope:(NSString *)scope {
//    [self.filteredCandyArray removeAllObjects];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
//    NSArray *tempArray = [self.candyArray filteredArrayUsingPredicate:predicate];
    
    if (![scope isEqualToString:@"All"]) {
        NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@", scope];
//        tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
    }
    
//    self.filteredCandyArray = [NSMutableArray arrayWithArray:tempArray];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSString *scope = [[self.searchDisplayController.searchBar scopeButtonTitles]
                       objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    [self filterContentForSearchBarText:searchString scope:scope];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSString *scope = [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption];
    [self filterContentForSearchBarText:self.searchDisplayController.searchBar.text scope:scope];
    return YES;
}

@end
