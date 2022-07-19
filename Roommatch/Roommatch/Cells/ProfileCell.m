//
//  ProfileCell.m
//  Roommatch
//
//  Created by Lily Yang on 7/18/22.
//

#import "ProfileCell.h"
#import "Utils.h"

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithUserObject:(User *)user {
    self.user = user;
    self.nameLabel.text = user.name;
    self.bioLabel.text = user.bio;
    self.profilePictureImageView.file = user.profilePicture;
    [self.profilePictureImageView loadInBackground];
}

- (IBAction)tapNo:(id)sender {
    User *me = [User currentUser];
    [me.usersSeen addObject:self.user.objectId];
    me.usersSeen = me.usersSeen;
    [me saveInBackground];
    NSLog(@"Tapped No");
}

- (IBAction)tapYes:(id)sender {
    User *curUser = [User currentUser];
    
    [curUser.usersSeen addObject:self.user.objectId];
    curUser.usersSeen = curUser.usersSeen;
    [curUser saveInBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Requests"];
    [query whereKey:@"from" equalTo:self.user];
    [query whereKey:@"to" equalTo:curUser];
    NSArray* results = [query findObjects];
    if(results.count != 0){
        [results[0] deleteInBackground];
        PFObject *match = [PFObject objectWithClassName:@"Matches"];
        match[@"user1"] = self.user;
        match[@"user2"] = curUser;
        [match saveInBackground];
        return;
    }
    
    PFObject *request = [PFObject objectWithClassName:@"Requests"];
    request[@"from"] = curUser;
    request[@"to"] = self.user;
    [request saveInBackground];
}

@end
