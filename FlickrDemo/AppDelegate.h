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
    base requirements:
    1. gets the list of the most recent pictures or gets the list of the most interesting pictures from Flickr, depending on what the user chooses. This app should display the images in a paging view.
    2. The Service layer (code to connect to Flickr and download images) will be used within the main thread of the application
    3. API calls cannot be blocking (i.e., should be asynchronous).
    4. The application main thread (i.e., UI thread) needs to be notified once the call response is ready, so that it can refresh its display. 
    5. For this exercise, the UI should use a collection view to showcase images.
 --------------------------
    6. view model (MVVM pattern)
    7. favor protocols (ApiClient, NetworkService)
    8. error handling through MessageManager (reusable service)
    9. Remember User selection (persist layer example)
    10. replace/mock SDWebImage (using mem cache, can delete on post Notification for each FlickrImageObject)
    11. rotation handling
    12. gesture/embed controller
    13. custom view controller animation transition

 */
/*
 TODO: 
    This service layer should be designed so that it could be reused if the application were to grow. It should not be tied to this particular UI.
 
    $ gallary view, SDProgress on image detail loading (opt1. horizontal scroll, opt2. collection view, opt2: pageviewcontroller
    $ replace NetworkLayer
    $ refactor AFHttpManager
    $ Spinner at bottom of collection view

    $try table view
 
    $ reachability
    $ low network testing
 
    $ show image with alpha
    $ test code
    $ create template
 
    $ Remember Offset before switch, recover after switch; hard if one colleciotn view;-> better use 2
    //other ideas out 2 collection views
 */

//Note: All class should be prefixed with 3 Letters, like FLKApiClient, not here for less typing.
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

