//
//  FlickrImage.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FlickrImage : NSObject

@property (nonatomic) UIImage* image;
@property (nonatomic, copy, readonly) NSString* originalImageUrlString;
@property (nonatomic, copy, readonly) NSString* thumbnailImageUrlString;

-(instancetype) initWithOriginalImageUrlString: (NSString*) ori withThumbnailImageUrlString: (NSString*) thumb;
@end
