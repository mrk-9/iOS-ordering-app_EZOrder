//
//  AddOrderViewController.m
//  OrderMan
//
//  Created by System Administrator on 11/2/14.
//  Copyright (c) 2014 System Administrator. All rights reserved.
//

#import "AddOrderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "EditViewController.h"
#import "RSNetworkClient.h"
#import "MBProgressHUD.h"

@interface AddOrderViewController () {
    bool isNewBarcode;
    bool isQuantityAdd;
}

@end

@implementation AddOrderViewController

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
    
    if (!_mCurItem)
        return ;
    
    if (![_mCurItem isEqualToString:@""])
    {
        NSMutableArray *items = [DELEGATE currentItems];
        NSMutableDictionary *mdic = [items objectAtIndex:[_mCurItem integerValue]];
        
        _txtUPC.text = [mdic valueForKey:@"barcode"];
        _txtQuantity.text = [mdic valueForKey:@"quantity"];
        _txtDescription.text = [mdic valueForKey:@"description"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    isNewBarcode = true;
    isQuantityAdd = true;
    
    [_txtDescription setValue:[UIColor grayColor]
                forKeyPath:@"_placeholderLabel.textColor"];
    [_txtQuantity setValue:[UIColor grayColor]
                forKeyPath:@"_placeholderLabel.textColor"];
    [_txtUPC setValue:[UIColor grayColor]
                forKeyPath:@"_placeholderLabel.textColor"];
    _btnDelete.layer.cornerRadius = 3;
    _btnReview.layer.cornerRadius = 3;
    _btnSend.layer.cornerRadius = 3;
    
    _lblItemAdded.alpha = 0.0f;
    _livevideo.alpha = 0.0f;
//    [self capture];
    _appKey = @"M/VQyndSCl7fc7vaT+eCYpAMSnucck1Vf2FQPMG8yy8";
    
    //
    [self initLabelFont];
}

- (void)inputInit
{
    _txtQuantity.text = @"0";
    _txtDescription.text = @"";
}

- (void)initLabelFont {
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat labelFont = 15 * w / 375.0;
    [_labelUPC setFont:[UIFont systemFontOfSize:labelFont]];
    [_labelQuantity setFont:[UIFont systemFontOfSize:labelFont]];
    [_labelDescription setFont:[UIFont systemFontOfSize:labelFont]];
}

- (IBAction)press0:(id)sender
{
    if (isNewBarcode)
    {
        _txtUPC.text = @"0";
        [self inputInit];
    }
    else
        _txtUPC.text = [NSString stringWithFormat:@"%@%@", _txtUPC.text, @"0"];

    isNewBarcode = false;
    _lblItemAdded.alpha = 0.0f;
}

- (IBAction)press1:(id)sender
{
    if (isNewBarcode)
    {
        _txtUPC.text = @"1";
        [self inputInit];
    }
    else
        _txtUPC.text = [NSString stringWithFormat:@"%@%@", _txtUPC.text, @"1"];
    
    isNewBarcode = false;
    _lblItemAdded.alpha = 0.0f;
}

- (IBAction)press2:(id)sender
{
    if (isNewBarcode)
    {
        _txtUPC.text = @"2";
        [self inputInit];
    }
    else
        _txtUPC.text = [NSString stringWithFormat:@"%@%@", _txtUPC.text, @"2"];
    
        isNewBarcode = false;
        _lblItemAdded.alpha = 0.0f;
}

- (IBAction)press3:(id)sender
{
    if (isNewBarcode)
    {
        _txtUPC.text = @"3";
        [self inputInit];
    }
    else
        _txtUPC.text = [NSString stringWithFormat:@"%@%@", _txtUPC.text, @"3"];
        isNewBarcode = false;
        _lblItemAdded.alpha = 0.0f;
}

- (IBAction)press4:(id)sender
{
    if (isNewBarcode)
    {
        _txtUPC.text = @"4";
        [self inputInit];
    }
    else
        _txtUPC.text = [NSString stringWithFormat:@"%@%@", _txtUPC.text, @"4"];
        isNewBarcode = false;
        _lblItemAdded.alpha = 0.0f;
}

- (IBAction)press5:(id)sender
{
    if (isNewBarcode)
    {
        _txtUPC.text = @"5";
        [self inputInit];
    }
    else
        _txtUPC.text = [NSString stringWithFormat:@"%@%@", _txtUPC.text, @"5"];
        isNewBarcode = false;
        _lblItemAdded.alpha = 0.0f;
}

- (IBAction)press6:(id)sender
{
    if (isNewBarcode)
    {
        _txtUPC.text = @"6";
        [self inputInit];
    }
    else
        _txtUPC.text = [NSString stringWithFormat:@"%@%@", _txtUPC.text, @"6"];
        isNewBarcode = false;
        _lblItemAdded.alpha = 0.0f;
}

- (IBAction)press7:(id)sender
{
    if (isNewBarcode)
    {
        _txtUPC.text = @"7";
        [self inputInit];
    }
    else
        _txtUPC.text = [NSString stringWithFormat:@"%@%@", _txtUPC.text, @"7"];
        isNewBarcode = false;
        _lblItemAdded.alpha = 0.0f;
}

- (IBAction)press8:(id)sender
{
    if (isNewBarcode)
    {
        _txtUPC.text = @"8";
        [self inputInit];
    }
    else
        _txtUPC.text = [NSString stringWithFormat:@"%@%@", _txtUPC.text, @"8"];
        isNewBarcode = false;
        _lblItemAdded.alpha = 0.0f;
}

- (IBAction)press9:(id)sender
{
    if (isNewBarcode)
    {
        _txtUPC.text = @"9";
        [self inputInit];
    }
    else
        _txtUPC.text = [NSString stringWithFormat:@"%@%@", _txtUPC.text, @"9"];
        isNewBarcode = false;
        _lblItemAdded.alpha = 0.0f;
}

- (IBAction)pressBack:(id)sender
{
    if (_txtUPC.text.length > 0) {
        _txtUPC.text = [_txtUPC.text substringToIndex:_txtUPC.text.length-1];
    }
        _lblItemAdded.alpha = 0.0f;
}

- (IBAction)pressUp:(id)sender
{
    if (_txtQuantity.text.length == 0) {
        _txtQuantity.text = @"1";
    }
    else {
        NSInteger curNum = [_txtQuantity.text integerValue] + 1;
        isQuantityAdd = false;
        _txtQuantity.text = [NSString stringWithFormat:@"%ld", (long)curNum];
    }
    isQuantityAdd = false;
    _lblItemAdded.alpha = 0.0f;
}


- (IBAction)pressDown:(id)sender
{
    if ([_txtQuantity.text isEqualToString:@"1"] || [_txtQuantity.text isEqualToString:@"0"] || [_txtQuantity.text isEqualToString:@""]) {
//        _txtQuantity.text = @"1";
    }
    else {
        NSInteger curNum = [_txtQuantity.text integerValue] -1;
        isQuantityAdd = false;
        _txtQuantity.text = [NSString stringWithFormat:@"%ld", (long)curNum];
    }
    _lblItemAdded.alpha = 0.0f;
    isQuantityAdd = false;
}

- (IBAction)pressScan:(id)sender
{
    _livevideo.alpha = 1.0f;
    self.scanditSDKBarcodePicker = [[ScanditSDKBarcodePicker alloc]
									initWithAppKey:self.appKey];
    
    // Customize the scan ui by removing the torch icon from this view
    [self.scanditSDKBarcodePicker.overlayController setTorchEnabled:NO];
    
    // Add a button behind the subview to close the barcode picker view.
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        self.pickerSubviewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    else
        self.pickerSubviewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    
    [self.pickerSubviewButton addTarget:self
								 action:@selector(closePickerSubview)
					   forControlEvents:UIControlEventTouchUpInside];
    
    [self.pickerSubviewButton setBackgroundImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
    
    [_livevideo addSubview:self.scanditSDKBarcodePicker.view];
    // add the button and the picker as a subview
    [self.scanditSDKBarcodePicker.view addSubview:self.pickerSubviewButton];
    self.scanditSDKBarcodePicker.view.frame = CGRectMake(0, 0, _livevideo.frame.size.width, _livevideo.frame.size.height);
    
    
    CGRect frameKeyboard = self.pickerSubviewButton.frame;
    CGRect frameScan = self.scanditSDKBarcodePicker.view.frame;
    self.pickerSubviewButton.frame = CGRectMake(0,
                                                frameScan.size.height - frameKeyboard.size.height,
                                                frameKeyboard.size.width, frameKeyboard.size.height);


    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        self.flashOnOffButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    else
        self.flashOnOffButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    
    [self.flashOnOffButton addTarget:self
                                 action:@selector(flashOnOff)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [self.scanditSDKBarcodePicker.view addSubview:self.flashOnOffButton];
    CGRect frameFlash = self.flashOnOffButton.frame;
    self.flashOnOffButton.frame = CGRectMake(frameScan.size.width - frameFlash.size.width,
                                                0,
                                                frameFlash.size.width, frameFlash.size.height);
    [self.flashOnOffButton setBackgroundImage:[UIImage imageNamed:@"flash_off-128.png"] forState:UIControlStateNormal];
    
    
    self.scanditSDKBarcodePicker.size = _livevideo.frame.size;
    self.scanditSDKBarcodePicker.view.bounds = CGRectMake(0, 0, _livevideo.frame.size.width, _livevideo.frame.size.height);
    self.scanditSDKBarcodePicker.view.frame = CGRectMake(0, 0, _livevideo.frame.size.width, _livevideo.frame.size.height);
    
    

    
    // Update the UI such that it fits the new dimension.
//    [self adjustPickerToOrientation:self.interfaceOrientation];
    
    // Set the delegate to receive callbacks.
    // This is commented out here in the demo app since the result view with the scan results
    // is not suitable for this overlay view
	
    self.scanditSDKBarcodePicker.overlayController.delegate = self;
    
	[self.scanditSDKBarcodePicker startScanning];
    _lblItemAdded.alpha = 0.0f;
}

- (void)closePickerSubview {
    if (self.scanditSDKBarcodePicker) {
        [self.scanditSDKBarcodePicker.view removeFromSuperview];
        self.scanditSDKBarcodePicker = nil;
        _livevideo.alpha = 0.0f;
    }

}

bool flashon = false;

- (void)flashOnOff
{
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success)
        {
            if ([flashLight isTorchActive])
            {
                //                [btnFlash setTitle:@"TURN ON" forState:UIControlStateNormal];
                [self.flashOnOffButton setBackgroundImage:[UIImage imageNamed:@"flash_off-128.png"] forState:UIControlStateNormal];
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }
            else
            {
                //                [btnFlash setTitle:@"TURN OFF" forState:UIControlStateNormal];
               [self.flashOnOffButton setBackgroundImage:[UIImage imageNamed:@"flash-128.png"] forState:UIControlStateNormal];
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }
            [flashLight unlockForConfiguration];
        }
    }

}

- (IBAction)pressEnter:(id)sender
{
    
//    - http://ezordersolution.com/ordershark/index.php/server/get_description_by_barcode
//    
//    Description by barcode.
//    GET
//param:
//token: string
//barcode: string
//    return:
//data:
//    description	:STRING
//message:
//    type	:STRING		(success=>"success", error=>"error")
//    code	:STRING	
    
    NSDictionary *userinfo = [DELEGATE userInfo];
    RSNetworkClient *getDesClient = [[RSNetworkClient alloc] init];
    [getDesClient setDelegate:self];
    [getDesClient setSelector:@selector(getDesClientResponse:)];
    
    NSString *url = @"http://ezordersolution.com/ordershark/index.php/server/get_description_by_barcode";
    NSString *token = [userinfo valueForKey:@"token"];
    NSString *barcode = _txtUPC.text;
    
    NSString *getStr = [NSString stringWithFormat:@"%@?token=%@&barcode=%@", url, token, barcode];
    NSLog(@"%@", getStr);
    
    //    [loginClient makeRequest:nil url:url strData:postStr];
    
    [getDesClient sendRequest:getStr];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
//    RSNetworkClient *loginClient = [[RSNetworkClient alloc] init];
//    [loginClient setDelegate:self];
//    [loginClient setSelector:@selector(loginClientResponse:)];
//    
//    NSString *url = server_url;
//    
//    NSString *postStr = [NSString stringWithFormat:@"&username=%@&password=%@", username, password];
//    NSLog(@"%@", postStr);
//    [loginClient makeRequest:nil url:url strData:postStr];
//    
    
    
}

- (void)getDesClientResponse:(NSDictionary *)response {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(!response){
        [self showError:@"Request failed"];
    } else {
        if([response objectForKey:@"response"]) {
            NSDictionary *resdic = [response objectForKey:@"response"];
            
            //NSString *s = [NSString stringWithFormat:@"%@", resdic];
            
            NSDictionary *dicMessage = [resdic objectForKey:@"message"];
            NSString * type = [dicMessage objectForKey:@"type"];
            //NSString * code = [dicMessage objectForKey:@"code"];
            
            if ([type isEqualToString:@"success"])
            {
                NSDictionary *dicData = [resdic objectForKey:@"data"];
                NSString *sdescript = [dicData valueForKey:@"description"];
                if(![sdescript isEqual:[NSNull null]])
                    _txtDescription.text = sdescript;
                else
                    _txtDescription.text = @"description not found";

            }
            else {
                _txtDescription.text = @"description not found";
            }
            
            
            
            isNewBarcode = true;
            
            NSMutableArray *curItems = [DELEGATE currentItems];
            
            //barcode		:STRING
            //description	:STRING
            //quantity	:STRING
            
            NSMutableDictionary *dicItem;
            NSString *curQuantity = @"0";
            
            for (NSMutableDictionary *mdic in curItems){
                NSString *barcode = [mdic valueForKey:@"barcode"];
                
                if([barcode isEqual:_txtUPC.text]){
                    //Do your stuff  here
                    curQuantity = [mdic valueForKey:@"quantity"];
                    //            [mdic setObject:quantity forKey:@"quantity"];
                    //            _txtQuantity.text = curQuantity;
                    
                    [curItems removeObject:mdic];
                    //            isQuantityAdd = true;
                    break;
                }
            }
            
            if (isQuantityAdd)
            {
                NSString *quantity = [NSString stringWithFormat:@"%ld", [curQuantity integerValue] + 1];
                
                dicItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_txtUPC.text, @"barcode", _txtDescription.text, @"description", quantity, @"quantity", nil];
                _txtQuantity.text = quantity;
            }
            else
            {
                dicItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_txtUPC.text, @"barcode", _txtDescription.text, @"description", _txtQuantity.text, @"quantity", nil];
                
            }
            
            [curItems addObject:dicItem];
            isQuantityAdd = true;
            _lblItemAdded.alpha = 1.0f;
           
            
            
            
            
            
            
            
            
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


- (IBAction)pressSend:(id)sender
{
    [self performSegueWithIdentifier:@"order_list_add"
                              sender:NULL];
}


- (IBAction)pressReview:(id)sender
{
//    [self performSegueWithIdentifier:@"order_list_add"
//                              sender:NULL];
//    EditViewController *viewController =   [self.storyboard instantiateViewControllerWithIdentifier:@"ItemList"];
    EditViewController *viewController =   [DELEGATE listItemvc];
    if (!viewController)
    {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemList"];
        [DELEGATE setListItemvc:viewController];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        [self.navigationController popToViewController:viewController animated:NO];
    }
    
    
    
}

- (IBAction)pressDelete:(id)sender
{
    if ([_txtUPC.text isEqualToString:@""])
        return;
    
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"Do you want to delete this item from the order?"
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Ok", nil] show];
    

}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:    (NSInteger)buttonIndex
{
    if(buttonIndex==1)  //Ok
    {
        //Code that will run after you press ok button
        NSMutableArray *curItems = [DELEGATE currentItems];
        
        //barcode		:STRING
        //description	:STRING
        //quantity	:STRING
        
        //NSMutableDictionary *dicItem;
        //NSString *curQuantity = @"0";
        
        for (NSMutableDictionary *mdic in curItems){
            NSString *barcode = [mdic valueForKey:@"barcode"];
            
            if([barcode isEqual:_txtUPC.text]){
                //Do your stuff  here
                 [curItems removeObject:mdic];
                //            isQuantityAdd = true;
                break;
            }
        }
        
        [self inputInit];
        _txtUPC.text = @"";
        _lblItemAdded.text = @"";
    }
}

- (IBAction)goback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)scanditSDKOverlayController1
                     didScanBarcode:(NSDictionary *)barcodeResult {

	
	[self.scanditSDKBarcodePicker stopScanningAndKeepTorchState];
	
	if (barcodeResult == nil) return;
	
    //NSString *symbology = [barcodeResult objectForKey:@"symbology"];
	NSString *barcode = [barcodeResult objectForKey:@"barcode"];
	//NSString *title = [NSString stringWithFormat:@"Scanned %@ code: %@", symbology, barcode];
    
    _txtUPC.text = barcode;
    
    _livevideo.alpha = 0.0f;
    
    [self closePickerSubview];
}

- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController didManualSearch:(NSString *)text {
    
}

- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController didCancelWithStatus:(NSDictionary *)status {
    
}

- (void)flashOnOff:(id)sender {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyDefault)
        [textField resignFirstResponder];
    return (textField.returnKeyType == UIReturnKeyDefault);
}

@end
