//
//  ViewProfileViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/8/22.
//

#import "ViewProfileViewController.h"
#import "User.h"
@import Parse;
#import <Parse/Parse.h>

@interface ViewProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
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
@property (weak, nonatomic) IBOutlet UILabel *instagramLabel;

@end

@implementation ViewProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User* user = [User currentUser];
    
    self.imageView.file = user.profilePicture;
    [self.imageView loadInBackground];
    
    self.nameLabel.text = [@"Name: " stringByAppendingString:user.name];
    self.ageLabel.text = [@"Age: " stringByAppendingString:user.age];
    self.pronounsLabel.text = [@"Pronouns: " stringByAppendingString:user.pronouns];
    self.locationLabel.text = [@"Location: " stringByAppendingString:user.city];
    
    
    NSString *priceRange = [[user.priceLow stringByAppendingString:@" - "] stringByAppendingString:user.priceHigh];
    self.priceRangeLabel.text = [@"Price Range: $" stringByAppendingString:priceRange];
    self.bioLabel.text = [@"Bio: " stringByAppendingString:user.bio];
    self.smokingLabel.text = [@"Smoking: " stringByAppendingString:user.smoking];
    self.petsLabel.text = [@"Pets: " stringByAppendingString:user.pets];
    self.inCollegeLabel.text = [@"Student: " stringByAppendingString:user.inCollege];
    self.collegeNameLabel.text = [@"College Name: " stringByAppendingString:user.collegeName];
    self.instagramLabel.text = [@"Instagram Tag: " stringByAppendingString:user.instagramTag];
}

@end
