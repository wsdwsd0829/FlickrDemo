//
//  PhotosViewModel.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/26/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//
//services

//#import "FlickrRecentImageServiceProtocol.h"
//#import "FlickrInterestingImageServiceProtocol.h"


#import "PhotosViewModel.h"
#import "FlickrNetworkService.h"
#import "MessageManager.h"

@interface PhotosViewModel() {
    //private backing stores
    NSMutableArray<FlickrImage*>* recentImages;
    NSMutableArray<FlickrImage*>* interestingImages;
    id<FlickrNetworkServiceProtocol> recentImagesService;
    id<FlickrNetworkServiceProtocol> interestingImageService;
    
    //for ui
    id<FlickrNetworkServiceProtocol> imageService;
    NSArray<FlickrImage*>* _images;
    
    //callback handling
    id<MessageManagerProtocol> messageManager;
}
@end

@implementation PhotosViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        //setup services
        recentImages = [NSMutableArray new];
        interestingImages = [NSMutableArray new];
        recentImagesService = [[FlickrNetworkService alloc] init];
        interestingImageService = [[FlickrNetworkService alloc] init];
        
        // actual services
        imageService = recentImagesService;
        _images = recentImages;
        
        messageManager = [[MessageManager alloc] init];
        [self p_initializeLoading];
    }
    return self;
}

- (void)segmentedControlChanged:(NSInteger)index {
    if(index == 0) {
        imageService = recentImagesService;
        _images = recentImages;
    } else {
        imageService = interestingImageService;
        _images = interestingImages;
    }
    //update ui
    self.updateBlock();
}

-(void) loadImages {
    if(imageService == recentImagesService) {
        [imageService loadRecentImages:^(NSArray *imgs, NSError *error) {
            if(!error) {
                if(imgs.count > 0) {
                    [recentImages addObjectsFromArray:imgs];
                    self.updateBlock();
                }
            } else {
                [self p_handleError: error];
            }
        }];
    } else {
        [imageService loadInterestingImages:^(NSArray *imgs, NSError *error) {
            if(!error) {
                if(imgs.count > 0) {
                    [interestingImages addObjectsFromArray:imgs];
                    self.updateBlock();
                }
            } else {
                [self p_handleError: error];
            }
        }];
    }
}

//to initialize loading;
-(void) p_initializeLoading{
    [recentImagesService loadRecentImages:^(NSArray *imgs, NSError *error) {
        if(!error) {
            if(imgs.count > 0) {
                [recentImages addObjectsFromArray:imgs];
                self.updateBlock();
            }
        } else {
            [self p_handleError: error];
        }
    }];
    
    [interestingImageService loadInterestingImages:^(NSArray *imgs, NSError *error) {
        if(!error) {
            if(imgs.count > 0) {
                [interestingImages addObjectsFromArray:imgs];
                self.updateBlock();
            }
        } else {
            [self p_handleError: error];
        }
    }];
}

-(void) p_handleError:(NSError*)error {
    [messageManager showError:error];
}

@end
