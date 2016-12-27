//
//  FlickrRecentImageService.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "FlickrRecentImageService.h"

@implementation FlickrRecentImageService

-(void)loadImages:(FlickrImageListHandler)handler {
    [self loadRecentImages:handler];
}

@end
