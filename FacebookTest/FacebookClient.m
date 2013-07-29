//
//  FacebookClient.m
//  FacebookTest
//
//  Created by Pan Peter on 13/7/29.
//  Copyright (c) 2013年 Pan Peter. All rights reserved.
//

#import "FacebookClient.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation FacebookClient

+ (FacebookClient *)sharedClient {
    static FacebookClient *_sharedClient = nil;
  
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FacebookClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://graph.facebook.com/"]];
        
        
    });
    
    
    return _sharedClient;
    
    
    
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    
    return self;
}

-(void)createSportFromDataDic:(NSDictionary*)dataDic withCompletionHandler:(void (^)(NSDictionary *retDic, NSDictionary *errorDic))handler
{
    NSDictionary *dic = @{  @"access_token":FBSession.activeSession.accessTokenData.accessToken};

    NSString *httpMethod = @"POST";
    NSString *url = @"me/objects/fitness.course";

    
    NSURLRequest *postRequest = [self multipartFormRequestWithMethod:httpMethod path:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //NSMutableString *str = @"{'title':'Chicken Enchiladas', 'url':'http://apppeterpan.blogspot.tw/2013/03/ios-sdk.html' }";
        //NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:nil];

        
        [formData  appendPartWithFormData:jsonData name:@"object"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:postRequest];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (operation.response.statusCode == 200 || operation.response.statusCode == 201) {
            handler(responseObject, nil);

        } else {
            handler(nil, @{@"error":@"1"});

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, @{@"error":@"1"});
        
    }];
    
    [self enqueueHTTPRequestOperation:operation];

    
}



@end
