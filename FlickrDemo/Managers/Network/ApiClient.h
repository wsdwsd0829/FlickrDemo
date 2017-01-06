//
//  ApiClient.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiClientProtocol.h"
//make network connection details

@interface ApiClient : NSObject <ApiClientProtocol>

//+(instancetype) defaultClient;
//
//-(void) fetchWithParams:(NSDictionary*) params withApi: (NSString*)api withHandler:(HttpResponseHandler) handler;

@end
