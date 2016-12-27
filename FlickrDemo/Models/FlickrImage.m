//
//  FlickrImage.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "FlickrImage.h"

@implementation FlickrImage

-(instancetype) initWithOriginalImageUrlString: (NSString*) ori withThumbnailImageUrlString: (NSString*) thumb {
    self = [super init];
    if (self) {
        _originalImageUrlString = ori;
        _thumbnailImageUrlString = thumb;
    }
    return self;
}

@end
