//
//  ProfileDetailsViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/19/22.
//

#import "ProfileDetailsViewController.h"
@import Parse;

@interface ProfileDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
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

@implementation ProfileDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFields];
}

- (void)setFields {
    self.titleLabel.text = [self.user.name stringByAppendingString:@"'s Profile"];
    
    self.profilePictureImageView.file = self.user.profilePicture;
    [self.profilePictureImageView loadInBackground];
    
    self.nameLabel.text = [@"Name: " stringByAppendingString:self.user.name];
    self.ageLabel.text = [@"Age: " stringByAppendingString:self.user.age];
    self.pronounsLabel.text = [@"Pronouns: " stringByAppendingString:self.user.pronouns];
    self.locationLabel.text = [@"Location: " stringByAppendingString:self.user.city];
    
    
    NSString *priceRange = [[[@(self.user.priceLow.integerValue) stringValue] stringByAppendingString:@" - "] stringByAppendingString:[@(self.user.priceHigh.integerValue) stringValue]];
    self.priceRangeLabel.text = [@"Price Range: $" stringByAppendingString:priceRange];
    self.bioLabel.text = [@"Bio: " stringByAppendingString:self.user.bio];
    self.smokingLabel.text = [@"Smoking: " stringByAppendingString:self.user.smoking];
    self.petsLabel.text = [@"Pets: " stringByAppendingString:self.user.pets];
    self.inCollegeLabel.text = [@"Student: " stringByAppendingString:self.user.inCollege];
    self.collegeNameLabel.text = [@"College Name: " stringByAppendingString:self.user.collegeName];
    self.instagramTagLabel.text = [@"Instagram Tag: " stringByAppendingString:self.user.instagramTag];
}

@end
