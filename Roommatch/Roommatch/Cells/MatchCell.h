//
//  MatchCell.h
//  Roommatch
//
//  Created by Lily Yang on 7/19/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@import Parse;
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface MatchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *instagramLabel;

- (void)initWithUserObject:(User *)user;

@end

NS_ASSUME_NONNULL_END
