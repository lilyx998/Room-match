//
//  SendMessageCell.h
//  Roommatch
//
//  Created by Lily Yang on 7/28/22.
//

#import <UIKit/UIKit.h>
@import Parse;
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface SendMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *userProfilePicture;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

- (void)initWithMessageObject:(Message *)message;

@end

NS_ASSUME_NONNULL_END
