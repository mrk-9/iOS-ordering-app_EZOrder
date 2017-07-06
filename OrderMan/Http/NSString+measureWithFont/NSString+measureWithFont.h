//
//  NSString (measureWithFont).h
//  holistica
//
//  Created by Mountain on 11/2/13.
//  Copyright (c) 2013 chinasoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (measureWithFont)

-(CGSize) measureWithFont:(UIFont*)font constrainedToSize:(CGSize)size;


@end
