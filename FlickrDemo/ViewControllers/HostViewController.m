//
//  HostViewController.m
//  FlickrDemo
//
//  Created by Sida Wang on 12/30/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import "HostViewController.h"
#import "TabBarViewController.h"
#import "PereferenceService.h"

// Could handle selection and pereference in ViewModel (MVVM) or Interacter (VIPER)
@interface HostViewController () {
    TabBarViewController *tabBarViewController;
     id<PereferenceServiceProtocol> pereferenceService;
    UISwipeGestureRecognizer* rightSwipe;
    UISwipeGestureRecognizer* leftSwipe;

}
@property (nonatomic, weak) IBOutlet UISegmentedControl* segControl;
@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGesture];
    
    pereferenceService = [[PereferenceService alloc] init];
    [self recoverUserPereference];

    // Do any additional setup after loading the view.
}

-(void) recoverUserPereference {
    ImageListType type = [pereferenceService lastBrowsedImageListType];
    self.segControl.selectedSegmentIndex = type;
    [self selectCorrectImageListForType:type];
}

-(void)setupGesture {
    rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    
    leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer: leftSwipe];
}

-(void)swiped:(UISwipeGestureRecognizer*)sender{
    if(sender == rightSwipe) {
        [self.segControl setSelectedSegmentIndex: ImageListTypeRecent];
        [self selectCorrectImageListForType: ImageListTypeRecent];
    }
    if(sender == leftSwipe) {
        [self.segControl setSelectedSegmentIndex: ImageListTypeInteresting];
        [self selectCorrectImageListForType: ImageListTypeInteresting];
    }
}

-(IBAction)segControlChanged:(UISegmentedControl*)sender {
    [self selectCorrectImageListForType: sender.selectedSegmentIndex];
}

-(void) selectCorrectImageListForType:(ImageListType) type {
    switch(type) {
        case ImageListTypeRecent:
            tabBarViewController.selectedIndex = ImageListTypeRecent;
            break;
        case ImageListTypeInteresting:
            tabBarViewController.selectedIndex = ImageListTypeInteresting;
            break;
    }
    [pereferenceService selectedImageListType:type];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass: [TabBarViewController class]]) {
        tabBarViewController = segue.destinationViewController;
    }
}

@end
