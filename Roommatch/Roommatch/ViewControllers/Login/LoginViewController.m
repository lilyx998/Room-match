//
//  LoginViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/7/22.
//

#import "LoginViewController.h"
#import "Utils.h"
#import "User.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)signUp:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if([username isEqualToString:@""] || [password isEqualToString:@""]){
        [Utils alertViewController:self WithMessage:@"Please enter a valid username and password"];
        return;
    }
    
    [self.activityIndicator startAnimating];

    User *user = [User user];
    [user initAllEmpty];
    user.username = username;
    user.password = password;
    user.profileCreated = NO;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            [Utils alertViewController:self WithMessage:error.localizedDescription];
        } else {
            NSLog(@"User registered successfully");
            User* curUser = [User currentUser];
            [curUser addObject:curUser.objectId forKey:@"usersSeen"];
            [curUser saveInBackground]; 
            [self performSegueWithIdentifier:@"Sign Up Segue" sender:nil];
        }
        [self.activityIndicator stopAnimating];
    }];
}

- (IBAction)login:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if([username isEqualToString:@""] || [password isEqualToString:@""]){
        [Utils alertViewController:self WithMessage:@"Please enter a valid username and password"];
        return;
    }
    
    [self.activityIndicator startAnimating];
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [Utils alertViewController:self WithMessage:error.localizedDescription];
        } else {
            NSLog(@"🤓🤓🤓 User logged in successfully");
            [self performSegueWithIdentifier:@"Login Segue" sender:nil];
        }
        [self.activityIndicator stopAnimating];
    }];
}

@end
