//
//  FacebookClient.h
//  FacebookTest
//
//  Created by Pan Peter on 13/7/29.
//  Copyright (c) 2013年 Pan Peter. All rights reserved.
//

#import "AFHTTPClient.h"

@interface FacebookClient : AFHTTPClient

-(void)createSportFromDataDic:(NSDictionary*)dataDic withCompletionHandler:(void (^)(NSDictionary *retDic, NSDictionary *errorDic))handler;

+(FacebookClient *)sharedClient;


@end
