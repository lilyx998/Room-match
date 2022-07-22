//
//  SwipeView.h
//  Roommatch
//
//  Created by Lily Yang on 7/21/22.
//

#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "User.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface SwipeView : MDCSwipeToChooseView

@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameAndAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchMessageLabel;

- (void)initWithUserObject:(User *)user;

@end

NS_ASSUME_NONNULL_END
