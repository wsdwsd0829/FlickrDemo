//
//  FlickrImage.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Photo : NSObject

@property (nonatomic, copy, readonly) NSString* identifier;
@property (nonatomic, copy, readonly) NSString* originalImageUrlString;
@property (nonatomic, copy, readonly) NSString* thumbnailImageUrlString;
@property (nonatomic, copy) NSString* title;

-(instancetype) initWithOriginalImageUrlString: (NSString*) ori withThumbnailImageUrlString: (NSString*) thumb withIdentifier:(NSString*) identifier;
@end
