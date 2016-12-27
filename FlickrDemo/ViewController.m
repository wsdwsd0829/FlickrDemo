//
//  ViewController.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "ViewController.h"
//vms
#import "PhotosViewModel.h"
//models
#import "FlickrImage.h"
//views
#import "ImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

NSInteger const PreloadingOffset = 10; //must smaller than PageCount in FlickerService, otherwise no new page will loaded

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
}
@property (nonatomic) PhotosViewModel* viewModel;

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

    //setup UI
    //this could change enum order and do not change storyboard to swap segment position
    [self.setmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [self.setmentedControl setTitle:@"Recent" forSegmentAtIndex:(int)ImageListTypeRecent];
    [self.setmentedControl setTitle:@"Interesting" forSegmentAtIndex:(int)ImageListTypeInteresting];
    
    //setup dependencies: ViewModel
    self.viewModel = [[PhotosViewModel alloc] init];
    [self setupViewModel];
}

-(void)setupViewModel {
    ViewController* __weak weakSelf = self;
    self.viewModel.updateBlock = ^() {
        ViewController* strongSelf = weakSelf;
        [strongSelf.collectionView reloadData];
        switch(strongSelf.viewModel.type) {
            case ImageListTypeRecent:
                strongSelf.setmentedControl.selectedSegmentIndex = ImageListTypeRecent;
                break;
            case ImageListTypeInteresting:
                strongSelf.setmentedControl.selectedSegmentIndex = ImageListTypeInteresting;
                break;
        }
    };
}

//MARK: user actions
- (IBAction)segmentedControlChanged:(UISegmentedControl *)sender {
    [self.viewModel segmentedControlChanged: (ImageListType)(sender.selectedSegmentIndex)];
}

//MARK: collectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.viewModel.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    [self p_configCell:cell forItemAtIndexPath:indexPath];
    return cell;
}
-(void) p_configCell:(UICollectionViewCell*)cell forItemAtIndexPath:(NSIndexPath*) indexPath {
    if([cell isKindOfClass:[ImageCell class]]) {
        ImageCell* imageCell = (ImageCell*)cell;
        //use SDWebImage and comment below for better performance
         //[imageCell.imageView sd_setImageWithURL:[NSURL URLWithString:  self.viewModel.images[indexPath.row].originalImageUrlString] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        //Handle image caching myself
        if(self.viewModel.images[indexPath.row].image) {
            imageCell.imageView.image = self.viewModel.images[indexPath.row].image;
        } else {
            [self.viewModel loadImageForIndexPath:indexPath withHandler:^() {
                //make sure cell still visible
                ImageCell *updateCell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
               // NSLog(@"afterIndex %ld", (long)indexPath.row);
                if (updateCell){
                    //some annimation effect, Bug: not always animate
                    [UIView transitionWithView:imageCell.imageView
                                      duration:1.0f
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        imageCell.imageView.image = self.viewModel.images[indexPath.row].image;
                                    } completion:nil];
                    //imageCell.imageView.image = self.viewModel.images[indexPath.row].image;
                }
            }];
        }
    }
    
    //NSLog(@"indexPath: %@", indexPath);
    if(indexPath.row + PreloadingOffset == self.viewModel.images.count) {
        [self.viewModel loadImages];
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

@end
