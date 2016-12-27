//
//  PersistenceProtocol.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PersistenceProtocol <NSObject>

//can use keychain if need security
-(void)saveString:(NSString*)val forKey:(NSString*) key;
-(NSString*) stringForKey:(NSString*) key;

@end
