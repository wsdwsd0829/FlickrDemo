//
//  PereferenceService.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceProtocol.h"

@protocol PereferenceServiceProtocol <NSObject>
-(ImageListType)lastBrowsedImageListType;
-(void) selectedImageListType:(ImageListType)type;
@end

@interface PereferenceService : NSObject<PersistenceProtocol, PereferenceServiceProtocol>

@end
