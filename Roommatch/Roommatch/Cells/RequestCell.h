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

@interface RequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UILabel *interactionMessage;

@property (strong, nonatomic) User *user;

- (void)initWithUserObject:(User *)user;

@end

NS_ASSUME_NONNULL_END
