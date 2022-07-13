//
//  TabViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/8/22.
//

#import "TabViewController.h"
#import <Parse/Parse.h>
#import "User.h"

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
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
