//
//  TabViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/8/22.
//

#import "TabViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if(error){
            NSLog(@"☹️☹️☹️ Couldn't log out: %@", error.localizedDescription);
        }
        else{
            NSLog(@"😇😇😇 Logout success!");
            SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            mySceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}

@end
