//
//  BaseroutAPI.h
//  You're DONE
//
//  Created by Leo Lorenz on 1/26/16.
//  Copyright © 2016 Leo Lorenz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseroutAPI : NSObject {
    
    
}

+ (BaseroutAPI*) sharedInstance;

- (void) setVar:(NSString *)key theValue:(NSString*)value;
- (NSString *) getVar:(NSString *)key;

- (void) setObj:(NSString *)key theObject:(id)value;
- (id) getObj:(NSString *)key;
- (void) MessageBox : (NSString*) title Message:(NSString*) message;


@end
