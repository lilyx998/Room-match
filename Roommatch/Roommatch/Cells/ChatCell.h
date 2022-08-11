//
//  MatchCell.h
//  Roommatch
//
//  Created by Lily Yang on 7/19/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Chat.h"
@import Parse;
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessagePreview;
@property (weak, nonatomic) IBOutlet UIImageView *unreadIndicatorImageView;

- (void)configureWithChatObject:(Chat *)chat;

@end

NS_ASSUME_NONNULL_END
