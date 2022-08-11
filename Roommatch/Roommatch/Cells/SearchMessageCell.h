//
//  SearchMessageCell.h
//  Roommatch
//
//  Created by Lily Yang on 8/2/22.
//

#import "Message.h"
#import <UIKit/UIKit.h>
@import Parse; 

NS_ASSUME_NONNULL_BEGIN

@interface SearchMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (void)configureWithMessageObject:(Message *)message;

@end

NS_ASSUME_NONNULL_END
