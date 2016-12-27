//
//  PhotosViewModel.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrImage.h"

@interface PhotosViewModel : NSObject 
@property (nonatomic, readonly) NSArray<FlickrImage*>* images;
@property (nonatomic, copy) void(^updateBlock)();

- (void)segmentedControlChanged:(NSInteger)index;
-(void) loadImages;
@end

