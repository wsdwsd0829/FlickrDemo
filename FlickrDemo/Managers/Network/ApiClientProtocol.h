//
//  ApiClientProtocol.h
//  
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HttpResponseHandler)(NSURLResponse *response, id responseObject, NSError *error);

@protocol ApiClientProtocol <NSObject>

+(instancetype) defaultClient;

-(void) fetchWithUrlString:(NSString*) urlString withHandler:(HttpResponseHandler) handler;

-(void) fetchWithParams:(NSDictionary*) params withApi: (NSString*)api withHandler:(HttpResponseHandler) handler;

-(void) postFormWithParams: (NSDictionary*) params withApi: (NSString*)api withHandler: (HttpResponseHandler) handler;

-(void) postJSONWithParams: (NSDictionary*) params withApi: (NSString*)api withHandler: (HttpResponseHandler) handler;

@end
