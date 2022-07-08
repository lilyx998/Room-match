//
//  LoginViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/7/22.
//

#import "LoginViewController.h"
#import "Lib.h"
#import "User.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)signUp:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if([username isEqualToString:@""] || [password isEqualToString:@""]){
        [Lib alertViewController:self WithMessage:@"Please enter a valid username and password"];
        return;
    }

    User *user = [User user];
    user.username = username;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            [Lib alertViewController:self WithMessage:error.localizedDescription];
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"Sign Up Segue" sender:nil];
        }
    }];
}

- (IBAction)login:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if([username isEqualToString:@""] || [password isEqualToString:@""]){
        [Lib alertViewController:self WithMessage:@"Please enter a valid username and password"];
        return;
    }
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [Lib alertViewController:self WithMessage:error.localizedDescription];
        } else {
            NSLog(@"🤓🤓🤓 User logged in successfully");
            [self performSegueWithIdentifier:@"Login Segue" sender:nil];
        }
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
