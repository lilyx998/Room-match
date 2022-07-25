//
//  ProfileCell.m
//  Roommatch
//
//  Created by Lily Yang on 7/18/22.
//

#import "RequestCell.h"
#import "Utils.h"

@implementation RequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.profilePictureImageView setHidden:NO];
    [self.nameLabel setHidden:NO];
    [self.bioLabel setHidden:NO];
    [self.noButton setHidden:NO];
    [self.yesButton setHidden:NO];
    [self.interactionMessage setHidden:YES];
}

- (void)initWithUserObject:(User *)user {
    self.user = user;
    self.nameLabel.text = user.name;
    self.bioLabel.text = user.bio;
    self.profilePictureImageView.file = user.profilePicture;
    [self.profilePictureImageView loadInBackground];
}

- (IBAction)tapNo:(id)sender {
    User *curUser = [User currentUser];
    
    [curUser.usersSeen addObject:self.user.objectId];
    curUser.usersSeen = curUser.usersSeen;
    [curUser saveInBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Requests"];
    [query whereKey:@"from" equalTo:self.user.objectId];
    [query whereKey:@"to" equalTo:curUser.objectId];
    NSArray* results = [query findObjects];
    [results[0] deleteInBackground];
    
    [self clearCellAndDisplayMessage:@"Rejected match request 🫢"];
}

- (IBAction)tapYes:(id)sender {
    User *curUser = [User currentUser];
    
    [curUser.usersSeen addObject:self.user.objectId];
    curUser.usersSeen = curUser.usersSeen;
    [curUser saveInBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Requests"];
    [query whereKey:@"from" equalTo:self.user.objectId];
    [query whereKey:@"to" equalTo:curUser.objectId];
    NSArray* results = [query findObjects];

    [self clearCellAndDisplayMessage:@"It's a match! 🥳"];
    [results[0] deleteInBackground];
    PFObject *match = [PFObject objectWithClassName:@"Matches"];
    match[@"user1"] = self.user.objectId;
    match[@"user2"] = curUser.objectId;
    [match saveInBackground];
    return;
}

- (void)clearCellAndDisplayMessage:(NSString *)message {
    [self.profilePictureImageView setHidden:YES];
    [self.nameLabel setHidden:YES];
    [self.bioLabel setHidden:YES];
    [self.noButton setHidden:YES];
    [self.yesButton setHidden:YES];
    
    self.interactionMessage.text = message;
    [self.interactionMessage setHidden:NO];
    
    [self.delegate didInteractWithUser]; 
}

@end
