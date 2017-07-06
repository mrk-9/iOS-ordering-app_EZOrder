#import "RSNetworkClient.h"

#import "CJSONDeserializer.h"
#import "AppDelegate.h"
#import "CJSONDataSerializer.h"
#import "NSData+Base64.h"
#import "SBJson.h"
@interface RSNetworkClient()

-(void)doSendRequest;
- (void)cancelConnection;
@end



@implementation RSNetworkClient

//test home
//static NSString *serverUrl = @"http://store.ctwitter.com.ar/index.php/";
//test client
//static NSString *serverUrl = @"http://www.corporate-group.net/avi44talk/index.php/";

@synthesize selector;
@synthesize delegate    = _delegate;
@synthesize additionalData;
@synthesize username    = _username;
@synthesize password    = _password;
@synthesize receivedData    = _receivedData;
@synthesize connection      = _connection;
@synthesize progressSelector    = _progressSelector;
@synthesize bytesWritten    = _bytesWritten;
@synthesize expectedToWrite = _expectedToWrite;

+(NSString*)serverURL {
    return @"http://188.121.37.148/mobApi/";
}
+(RSNetworkClient *)client {
	return [[RSNetworkClient alloc]init];
}

-(id)init{
	if(self==[super init]) {
		self.additionalData = [NSMutableDictionary  dictionary];
        self.receivedData  = [[NSMutableData alloc] init];
	}
	return self;
}

-(void)doSendRequest {
    [self cancelConnection];
    NSURL *confUrl = nil;
    NSString *verb = [self.additionalData objectForKey:@"verb"];
	NSLog(@"Verb = %@", verb);
    [self.additionalData removeObjectForKey:@"verb"];
    NSString *requestURL = [self.additionalData objectForKey:@"url"];
    if([requestURL rangeOfString:@"http://"].location == 0) {
        confUrl = [NSURL URLWithString:requestURL];
    } else {
        confUrl = [NSURL URLWithString:[[NSString stringWithFormat:[self.additionalData objectForKey:@"url"], [RSNetworkClient serverURL]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    [self.additionalData removeObjectForKey:@"url"];
    NSLog(@"Request to url %@",confUrl);
#ifdef DEBUG
    NSLog(@"Request %@",self.additionalData);
#endif
    
    NSURL *url = confUrl;
    NSDictionary *parameters = self.additionalData;
    
	NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
    
    [headers setValue:@"*/*" forKey:@"Accept"];
    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    [headers setValue:@"no-cache" forKey:@"Pragma"];
    [headers setValue:@"Keep-Alive" forKey:@"Connection"]; // Avoid HTTP 1.1 "keep alive" for the connection
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    if ([parameters count]>0)
    {
        CJSONDataSerializer *serializer = [[CJSONDataSerializer alloc] init];
        [request setHTTPBody:[serializer serializeDictionary:parameters]];
        
    }
    [request setHTTPMethod:verb];
	
    [request setAllHTTPHeaderFields:headers];
	NSLog(@"request=%@", request.debugDescription);
    [self setConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES]];
    if(!self.connection)
    {
        NSLog(@"error no conn");
    }
}

- (NSMutableURLRequest*)makeRequest:(NSDictionary*)data url:(NSString*)url strData:(NSString *)strData;
{
    [self cancelConnection];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
        
    NSData *postData = [strData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"request=%@", request.debugDescription);
    
    NSString *response = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"parameter = %@", response);
    
    [self setConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES]];
    return request;
    
    
}

- (void)cancelConnection {
	[self.connection cancel];
    self.connection = nil;
}

- (void)sendRequest:(NSString *)param {
	[self.additionalData setObject:param forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

- (void)sendGetRequest:(NSString *)param {
	[self.additionalData setObject:param forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

- (void)uploadProfile {
	[self.additionalData setObject:@"%@uploadProfile.php" forKey:@"url"];
	[self.additionalData setObject:@"POST" forKey:@"verb"];
    [self doSendRequest];
}

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSInteger count = [challenge previousFailureCount];
    if (count == 0) {
        NSURLCredential* credential = [NSURLCredential credentialWithUser:self.username
																 password:self.password
															  persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:credential
               forAuthenticationChallenge:challenge];
    }
    else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        if ([delegate respondsToSelector:@selector(wrapperHasBadCredentials:)]) {
            //[delegate wrapperHasBadCredentials:self];
        }
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int statusCode = [httpResponse statusCode];
    switch (statusCode) {
        case 200:
            break;
        default:
            if ([delegate respondsToSelector:@selector(wrapper:didReceiveStatusCode:)]) {
                //[delegate wrapper:self didReceiveStatusCode:statusCode];
            }
            break;
    }
    [self.receivedData setLength:0];
#ifdef DEBUG
	NSLog(@"didReceiveResponse: %d", statusCode);
#endif
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
	
	
#ifdef DEBUG
    NSString *response = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
	NSLog(@"Response: %@", response);
#endif
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self cancelConnection];
    if ([delegate respondsToSelector:@selector(wrapper:didFailWithError:)]) {
    }
}
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    self.bytesWritten = totalBytesWritten;
    self.expectedToWrite = totalBytesExpectedToWrite;
    if (self.progressSelector == nil) {
        return;
    }
    if([self.delegate respondsToSelector:self.progressSelector]){
        [self.delegate performSelectorOnMainThread:self.progressSelector withObject:self waitUntilDone:NO];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self cancelConnection];
    NSData *respdata = self.receivedData;
    NSString *response = [[NSString alloc] initWithData:respdata encoding:NSUTF8StringEncoding];
    response = [response stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSError *error = nil;
    NSDictionary *resp = nil;
   // NSArray *test = [response JSONValue];
    int k = [response rangeOfString:@"["].location;
    //if (response == nil) {
    //    return;
    //}
    if(k <= 2) {
        NSArray *responseArray = [response JSONValue];
        //NSArray *responseArray = [
        if (responseArray) {
            resp = [NSDictionary dictionaryWithObject:responseArray forKey:@"response"];
        }
        //resp = [[CJSONDeserializer deserializer] deserializeAsDictionary:respdata error:&error];
        
        
    } else {
        /*NSArray *responseArray = [[CJSONDeserializer deserializer] deserializeAsArray:respdata error:&error];
        //NSArray *responseArray = [
        
        resp = [NSDictionary dictionaryWithObject:responseArray forKey:@"response"];*/
        //resp = [[CJSONDeserializer deserializer] deserializeAsDictionary:respdata error:&error];
        NSArray *responseArray = [response JSONValue];
        //NSArray *responseArray = [
        if (responseArray != Nil) {
            resp = [NSDictionary dictionaryWithObject:responseArray forKey:@"response"];
        }
        
        
        
    }
    
    if(error){
        NSLog(@"could not parse response %@",error);
    }
#ifdef DEBUG
	if(resp) {
		NSLog(@"Valid response: %@",resp);
	}	else {
		NSLog(@"Response: %@", response);
	}
#endif
	if((self.delegate)) {
		if([self.delegate respondsToSelector:self.selector]) {
			[self.delegate performSelectorOnMainThread:self.selector withObject:resp waitUntilDone:NO];
		}
	}
}

#pragma mark -
@end
