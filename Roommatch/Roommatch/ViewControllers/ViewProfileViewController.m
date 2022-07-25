//
//  ViewProfileViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/8/22.
//

#import "ViewProfileViewController.h"
#import "LocationViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "User.h"
@import Parse;
#import <Parse/Parse.h>

@interface ViewProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronounsLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *smokingLabel;
@property (weak, nonatomic) IBOutlet UILabel *petsLabel;
@property (weak, nonatomic) IBOutlet UILabel *inCollegeLabel;
@property (weak, nonatomic) IBOutlet UILabel *collegeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *instagramTagLabel;

@end

@implementation ViewProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User* user = [User currentUser];
    
    self.profilePictureImageView.file = user.profilePicture;
    [self.profilePictureImageView loadInBackground];
    
    self.nameLabel.text = [@"Name: " stringByAppendingString:user.name];
    self.ageLabel.text = [@"Age: " stringByAppendingString:user.age];
    self.pronounsLabel.text = [@"Pronouns: " stringByAppendingString:user.pronouns];
    self.locationLabel.text = [@"Location: " stringByAppendingString:user.city];
    
    
    NSString *priceRange = [[[@(user.priceLow.integerValue) stringValue] stringByAppendingString:@" - "] stringByAppendingString:[@(user.priceHigh.integerValue) stringValue]];
    self.priceRangeLabel.text = [@"Price Range: $" stringByAppendingString:priceRange];
    self.bioLabel.text = [@"Bio: " stringByAppendingString:user.bio];
    self.smokingLabel.text = [@"Smoking: " stringByAppendingString:user.smoking];
    self.petsLabel.text = [@"Pets: " stringByAppendingString:user.pets];
    self.inCollegeLabel.text = [@"Student: " stringByAppendingString:user.inCollege];
    self.collegeNameLabel.text = [@"College Name: " stringByAppendingString:user.collegeName];
    self.instagramTagLabel.text = [@"Instagram Tag: " stringByAppendingString:user.instagramTag];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LocationViewController *vc = [segue destinationViewController];
    vc.selectedCity = [User currentUser].city;
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
