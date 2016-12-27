//
//  AppDelegate.h
//  FlickrDemo
//
//  Created by Sida Wang on 12/25/16.
//  Copyright © 2016 Sida Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 Done:
    1. gets the list of the most recent pictures or gets the list of the most interesting pictures from Flickr, depending on what the user chooses. This app should display the images in a paging view.
    2. The Service layer (code to connect to Flickr and download images) will be used within the main thread of the application
    3. API calls cannot be blocking (i.e., should be asynchronous).
    4. The application main thread (i.e., UI thread) needs to be notified once the call response is ready, so that it can refresh its display. 
    5. For this exercise, the UI should use a collection view to showcase images.
 */
/*
 TODO: 
    This service layer should be designed so that it could be reused if the application were to grow. It should not be tied to this particular UI.
    $ ApiClient Protocol
    $ Spinner at bottom of collection view,
    $ view model
    $ Remember Offset before switch, recover after switch
    $ Remember User selection
    $ gallary view, SDProgress on image detail loading
    $ replace SDWebImage
    $ replace NetworkLayer
    $ error handling
    //other ideas out 2 collection views
 */

//All class should be prefixed with 3 Letters, like FLKApiClient
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

