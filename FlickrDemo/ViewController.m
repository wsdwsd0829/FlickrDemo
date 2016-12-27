//
//  ViewController.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "ViewController.h"
//services
#import "FlickrNetworkService.h"
//#import "FlickrRecentImageServiceProtocol.h"
//#import "FlickrInterestingImageServiceProtocol.h"
//models
#import "FlickrImage.h"
//vies
#import "ImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSMutableArray<FlickrImage*>* recentImages;
    NSMutableArray<FlickrImage*>* interestingImages;
//    id<FlickrRecentImageServiceProtocol> recentImagesService;
//    id<FlickrInterestingImageServiceProtocol> interestingService;
    FlickrNetworkService* recentImagesService;
    FlickrNetworkService* interestingImageService;
    //for ui
    FlickrNetworkService* imageService;
    NSMutableArray<FlickrImage*>* images;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *setmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //setup collectionview
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = flowLayout;

    //setup services
    recentImages = [NSMutableArray new];
    interestingImages = [NSMutableArray new];
    recentImagesService = [[FlickrNetworkService alloc] init];
    interestingImageService = [[FlickrNetworkService alloc] init];
    // actual services
    imageService = recentImagesService;
    images = recentImages;
    [self p_initializeLoading];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex == 0) {
        imageService = recentImagesService;
        images = recentImages;
    } else {
        imageService = interestingImageService;
        images = interestingImages;
    }
    [self.collectionView reloadData];
}

//MARK: collectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    [self p_configCell:cell forItemAtIndexPath:indexPath];
    return cell;
}
-(void) p_configCell:(UICollectionViewCell*)cell forItemAtIndexPath:(NSIndexPath*) indexPath {
    if([cell isKindOfClass:[ImageCell class]]) {
        ImageCell* imageCell = (ImageCell*)cell;
        [imageCell.imageView sd_setImageWithURL:[NSURL URLWithString: images[indexPath.row].originalImageUrlString] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    NSLog(@"indexPath: %@", indexPath);
    if(indexPath.row + 10 == images.count) {
        [self p_loadImages];
    }
}
//MARK: collectionView delegate (UICollectionViewDelegateFlowLayout)

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake(self.collectionView.bounds.size.width / 2, 100);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void) p_loadImages {
    if(imageService == recentImagesService) {
        [imageService loadRecentImages:^(NSArray *imgs, NSError *error) {
            [recentImages addObjectsFromArray:imgs];
            [self.collectionView reloadData];
        }];
    } else {
        [imageService loadInterestingImages:^(NSArray *imgs, NSError *error) {
            [interestingImages addObjectsFromArray:imgs];
            [self.collectionView reloadData];
        }];
    }
}

//to initialize loading;
-(void) p_initializeLoading{
    [recentImagesService loadRecentImages:^(NSArray *imgs, NSError *error) {
        [recentImages addObjectsFromArray:imgs];
        [self.collectionView reloadData];
    }];
    [interestingImageService loadInterestingImages:^(NSArray *imgs, NSError *error) {
        [interestingImages addObjectsFromArray:imgs];
        [self.collectionView reloadData];
    }];

}
@end
