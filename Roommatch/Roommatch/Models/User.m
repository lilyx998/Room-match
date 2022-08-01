//
//  User.m
//  Roommatch
//
//  Created by Lily Yang on 7/7/22.
//

#import "User.h"
#import "Utils.h"

@implementation User

@dynamic name;
@dynamic age;
@dynamic pronouns;
@dynamic priceLow;
@dynamic priceHigh;
@dynamic profilePicture;
@dynamic city;
@dynamic bio;
@dynamic smoking;
@dynamic gender;
@dynamic pets;
@dynamic inCollege;
@dynamic collegeName;
@dynamic profileCreated;
@dynamic preferenceMale;
@dynamic preferenceFemale;
@dynamic preferenceNonbinary;
@dynamic preferenceDogs;
@dynamic preferenceCats;
@dynamic preferenceOtherPets;
@dynamic preferenceCollege;
@dynamic usersSeen;
@dynamic preferenceSmoking;

- (void)initAllEmpty {
    self.age = @"";
    self.pronouns = @"";
    self.priceLow = [NSNumber numberWithInt:(-1)];
    self.priceHigh = [NSNumber numberWithInt:(-1)];
    self.profilePicture = [Utils getPFFileFromImage:[UIImage imageNamed:@"Profile Picture Placeholder"]];
    self.city = @"";
    self.bio = @"";
    self.smoking = @"";
    self.gender = @""; 
    self.pets = @"";
    self.inCollege = @"";
    self.collegeName = @"";
    self.profileCreated = NO;
    
    self.preferenceMale = YES;
    self.preferenceFemale = YES;
    self.preferenceNonbinary = YES;
    self.preferenceDogs = YES;
    self.preferenceCats = YES;
    self.preferenceOtherPets = YES;
    self.preferenceCollege = NO;
    self.preferenceSmoking = YES; 
    
    self.usersSeen = [NSMutableArray array]; 
}

@end
