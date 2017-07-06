#import <Foundation/Foundation.h>
@class DataObject;




@interface RSNetworkClient : NSObject <NSURLConnectionDataDelegate>{
	id delegate;
	SEL selector;
	NSMutableDictionary *additionalData;
	
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) SEL progressSelector;
@property (nonatomic, assign) float bytesWritten;
@property (nonatomic, assign) float expectedToWrite;
@property (nonatomic, strong) NSMutableDictionary *additionalData;
@property (nonatomic,strong)    NSString *username;
@property (nonatomic,strong)    NSString *password;
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) NSURLConnection *connection;
+(RSNetworkClient *)client;
+(NSString *)serverURL;

- (NSMutableURLRequest*)makeRequest:(NSDictionary*)data url:(NSString*)url strData:(NSString *)strData;

- (void)sendRequest:(NSString *)param;
- (void)uploadProfile;

@end
