//
//  AsyncImageView.m
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"
#import <QuartzCore/QuartzCore.h>

#define SPINNY_TAG 5555   

static ImageCache *imageCache = nil;

@implementation AsyncImageView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    /*[connection cancel];
    [connection release];
    [data release];
    [super dealloc];*/
}

-(void)setImage:(UIImage*)image {
    
    if (connection != nil) {
        [connection cancel];
        //[connection release];
        connection = nil;
    }
    if (data != nil) {
        //[data release];
        data = nil;
    }
    
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
    
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
//    self.contentMode = UIViewContentModeScaleAspectFit;
    [super setImage:image];
    
}

-(void)loadImageFromURL:(NSURL*)url {
    
    if ( !url )
        return;
    
    if (connection != nil) {
        [connection cancel];
        //[connection release];
        connection = nil;
    }
    if (data != nil) {
        //[data release];
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
        imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
   /// [urlString release];
    urlString = [[url absoluteString] copy];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
    if (cachedImage != nil) {
        self.image = cachedImage;
        return;
    }else {
	}
    
    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinny setColor:[UIColor darkGrayColor]];
    spinny.tag = SPINNY_TAG;
    //spinny.center = self.center;
	spinny.frame = CGRectMake(self.frame.size.width/2-spinny.frame.size.width/2, self.frame.size.height/2-spinny.frame.size.height/2, spinny.frame.size.width, spinny.frame.size.height); 
    
	[spinny startAnimating];
    [self addSubview:spinny];
    //[spinny release];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    //[connection release];
    connection = nil;
    
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
    
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    self.image = [UIImage imageWithData:data];
//    self.contentMode = UIViewContentModeScaleAspectFit;
    [imageCache insertImage:self.image withSize:[data length] forKey:urlString];
    
//data release];
    data = nil;
}

@end
