//
//  SearchMessageCell.m
//  Roommatch
//
//  Created by Lily Yang on 8/2/22.
//

#import "SearchMessageCell.h"

BOOL fromMe;

@implementation SearchMessageCell

- (void)initWithMessageObject:(Message *)message {
    User *fromUser = message.fromUser;
    User *toUser = message.toUser;
    fromMe = [fromUser.objectId isEqualToString:[User currentUser].objectId];
    
    if(fromMe){
        [toUser fetchIfNeeded];
        self.profilePictureImageView.file = toUser.profilePicture;
        [self.profilePictureImageView loadInBackground];
        self.nameLabel.text = toUser.name;
    }
    else{
        self.profilePictureImageView.file = fromUser.profilePicture;
        [self.profilePictureImageView loadInBackground];
        self.nameLabel.text = fromUser.name;
    }
    self.textLabel.text = [[fromUser.name stringByAppendingString:@": "] stringByAppendingString:message.text];
}

@end
