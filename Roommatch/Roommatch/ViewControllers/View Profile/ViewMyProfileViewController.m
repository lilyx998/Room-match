//
//  ViewProfileViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/8/22.
//

#import "ViewMyProfileViewController.h"
#import "LocationViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "User.h"
#import "Utils.h"
@import Parse;
#import <Parse/Parse.h>

@interface ViewMyProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronounsLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *smokingLabel;
@property (weak, nonatomic) IBOutlet UILabel *petsLabel;
@property (weak, nonatomic) IBOutlet UILabel *inCollegeLabel;
@property (weak, nonatomic) IBOutlet UILabel *collegeNameLabel;

@end

@implementation ViewMyProfileViewController

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
    self.genderLabel.text = [@"Gender: " stringByAppendingString:user.gender];
    self.smokingLabel.text = [@"Smoking: " stringByAppendingString:user.smoking];
    self.petsLabel.text = [@"Pets: " stringByAppendingString:user.pets];
    self.inCollegeLabel.text = [@"Student: " stringByAppendingString:user.inCollege];
    self.collegeNameLabel.text = [@"College Name: " stringByAppendingString:user.collegeName];
}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error){
            [Utils alertViewController:self WithMessage:@"Couldn't log out"];
        }
        else{
            SceneDelegate *mySceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            mySceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}

@end
