//
//  BaseroutAPI.m
//  You're DONE
//
//  Created by Leo Lorenz on 1/26/16.
//  Copyright © 2016 Leo Lorenz. All rights reserved.
//

#import "BaseroutAPI.h"
#import "Appdelegate.h"

@implementation BaseroutAPI

static BaseroutAPI *sharedInstance = nil;

+ (BaseroutAPI*)sharedInstance
{
    //@synchronized(self) {
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    //}
    return sharedInstance;
}

- (void) setObj:(NSString *)key theObject:(id)value
{
    if( value == NULL )
        return;
    
    if( value == nil )
        return;
    
    if ([value isEqual: [NSNull null]])
        return ;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}

- (id) getObj:(NSString *)key;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id ret =  [defaults objectForKey:key];
    
    if( ret == NULL)
        return @"";
    
    return ret;
}

- (void) setVar:(NSString *)key theValue:(NSString*)value
{
    if( value == NULL )
        return;
    
    if( value == nil )
        return;
    
    if ([value isEqual: [NSNull null]])
        return ;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}


- (NSString *) getVar:(NSString *)key;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* ret =  [defaults objectForKey:key];
    
    if( ret == NULL)
        return @"";
    
    return ret;
}

- (void) MessageBox : (NSString*) title Message:(NSString*) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


@end
