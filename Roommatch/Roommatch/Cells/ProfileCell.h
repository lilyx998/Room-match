//
//  ProfileCell.h
//  Roommatch
//
//  Created by Lily Yang on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "User.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@property (strong, nonatomic) User *user;

- (void)initWithUserObject:(User *)user;

@end

NS_ASSUME_NONNULL_END
