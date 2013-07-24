//
//  ViewController.m
//  FacebookTest
//
//  Created by Pan Peter on 13/7/24.
//  Copyright (c) 2013年 Pan Peter. All rights reserved.
//

// reference: https://www.youtube.com/watch?v=mLuaUtbGvEM#at=322

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController () <FBLoginViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.frame = CGRectOffset(loginView.frame,
                                   (self.view.center.x - (loginView.frame.size.width / 2)),
                                   5);
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI event

- (IBAction)postOnWallWithUiButPressed:(id)sender {
    
    
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];

    if([FBDialogs canPresentShareDialogWithParams:params])
    {
        NSURL *linkUrl = [NSURL URLWithString:@"http://www.apple.com"];
        NSURL *imageUrl = [NSURL URLWithString:@"http://passionbean.files.wordpress.com/2012/02/screen-shot-2012-02-15-at-e4b88be58d882-51-30.png"];
        
        [FBDialogs presentShareDialogWithLink:linkUrl name:@"name" caption:@"caption" description:@"description" picture:imageUrl clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
              if(error)
              {
                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                  [alertView show];
                  
              }
                                          
        }];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"please isntall Facebook App" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
    }

}

- (IBAction)postOnWallButPressed:(id)sender {
    
    
    
    
    NSDictionary *postDic = @{@"message":@"hello"};
    
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:postDic HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(error)
        {
           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
           [alertView show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"success" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alertView show];

        }
    }];
     
    
}

- (IBAction)publishStoryButPressed:(id)sender {
    
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    
    if([FBDialogs canPresentShareDialogWithParams:params])
    {
        
        
        id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
        
        // Attach a book object to the action
        action[@"book"] = @{
                            @"type": @"books.book",
                            @"fbsdk:create_object": @YES,
                            @"title": @"The Tipping Point",
                            @"image": @"http://www.renderready.com/wp-content/uploads/2011/02/the_tipping_point.jpg",
                            @"description": @"How Little Things Can Make a Big Difference",
                            @"data": @{@"isbn": @"0-316-31696-2"}
                            };
        
        [FBDialogs presentShareDialogWithOpenGraphAction:action
                                              actionType:@"books.reads"
                                     previewPropertyName:@"book"
                                                 handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                     if(error) {
                                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                                                         [alertView show];
                                                     }
                                                 }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"please isntall Facebook App" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
    }

}


#pragma mark - FBLoginViewDelegate

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        
    }


}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it. This conveniently
        // handles cases like password change or iOS6 app slider state.
        alertTitle = @"Facebook Error";
        alertMessage = error.fberrorUserMessage;
    } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
        // It is important to handle session closures since they can happen
        // outside of the app. You can inspect the error for more context
        // but this sample generically notifies the user.
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    } else {
        // For simplicity, this sample treats other errors blindly.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
