//
//  ParserProtocol.h
//  
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserProtocol <NSObject>

-(void)parse: (id) responseObject withHandler: (void(^)(NSArray* objects, NSError* error)) handler;

@end
