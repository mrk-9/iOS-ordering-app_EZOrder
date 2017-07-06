//
//  NSString (measureWithFont).m
//  holistica
//
//  Created by Mountain on 11/2/13.
//  Copyright (c) 2013 chinasoft. All rights reserved.
//

#import "NSString+measureWithFont.h"

@implementation NSString (measureWithFont)

-(CGSize) measureWithFont:(UIFont*)font constrainedToSize:(CGSize)size {
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              font, NSFontAttributeName,
                                              nil];
        
        CGRect frame = [self boundingRectWithSize:(CGSize){size.width, size.height}
                                          options:(NSStringDrawingUsesLineFragmentOrigin)
                                       attributes:attributesDictionary
                                          context:nil];
        
        CGFloat height = ceilf(frame.size.height);
        CGFloat width  = ceilf(frame.size.width);

        return CGSizeMake(width, height);
    
}

@end
