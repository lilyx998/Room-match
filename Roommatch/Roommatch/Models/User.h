//
//  User.h
//  Roommatch
//
//  Created by Lily Yang on 7/7/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* age;
@property (strong, nonatomic) NSString* pronouns;
@property (strong, nonatomic) NSString* priceLow;
@property (strong, nonatomic) NSString* priceHigh;
@property (strong, nonatomic) PFFileObject* profilePicture; 
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* bio;
@property (strong, nonatomic) NSString* smoking;
@property (strong, nonatomic) NSString* pets;
@property (strong, nonatomic) NSString* inCollege;
@property (strong, nonatomic) NSString* collegeName;
@property (strong, nonatomic) NSString* instagramTag;



@end

NS_ASSUME_NONNULL_END
