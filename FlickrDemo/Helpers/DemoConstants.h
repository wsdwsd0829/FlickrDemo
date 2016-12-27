//
//  DemoConstants.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ImageListType) {
    ImageListTypeRecent, ImageListTypeInteresting
};

@interface DemoConstants : NSObject

extern NSString* const kErrorDisplayUserInfoKey;

extern NSString* const kUserDefaultsImagePreference;
extern NSString* const kUserDefaultsImageListRecent;
extern NSString* const kUserDefaultsImageListInteresting;
@end
