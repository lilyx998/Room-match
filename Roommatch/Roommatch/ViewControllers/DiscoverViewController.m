//
//  DiscoverViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/18/22.
//

#import "DiscoverViewController.h"
#import "RequestCell.h"
#import <Parse/Parse.h>
#import "User.h"

int userIdx;

@interface DiscoverViewController ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *usersToDisplay;
@property (strong, nonatomic) MDCSwipeToChooseViewOptions *options;
@property (weak, nonatomic) IBOutlet UIView *swipeContentView;
@property (weak, nonatomic) IBOutlet UILabel *noUsersToDisplayLabel;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    self.options = [MDCSwipeToChooseViewOptions new];
    self.options.likedText = @"Yes 🫂";
    self.options.nopeText = @"Nope 🫣";
    self.options.delegate = self;
    
    
//    MDCSwipeToChooseView *view = [[MDCSwipeToChooseView alloc] initWithFrame:self.view.bounds
//                                                                         options:self.options];
//    view.imageView.image = [UIImage imageNamed:@"cat"];
//    [self.view addSubview:view];

    
    
    [self queryUsers];
//    [self displayNextUser];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [self queryAndDisplayUsers];
//}

- (void)queryUsers {
    userIdx = 0; 
    PFQuery *query = [User query];
    User *curUser = [User currentUser];
    
    [query whereKey:@"city" equalTo:curUser.city];
    [query whereKey:@"priceHigh" greaterThanOrEqualTo:curUser.priceLow];
    [query whereKey:@"priceLow" lessThanOrEqualTo:curUser.priceHigh];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users) {
            self.usersToDisplay = [NSMutableArray array];
            for(PFObject* user in users){
                if([curUser.usersSeen containsObject:user.objectId])
                    continue;
                [self.usersToDisplay addObject:user];
            }
            [self displayNextUser];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        
        [self.refreshControl endRefreshing];
    }];
}

- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction {
//    if (direction == MDCSwipeDirectionLeft) {
        return YES;
//    } else {
//        // Snap the view back and cancel the choice.
//        [UIView animateWithDuration:0.16 animations:^{
//            view.transform = CGAffineTransformIdentity;
//            view.center = [view superview].center;
//        }];
//        return NO;
//    }
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        [self swipedLeft];
    } else {
        [self swipedRight]; 
    }
    userIdx++;
    [self displayNextUser];
}

- (void)displayNextUser {
    if(userIdx == self.usersToDisplay.count){
        [self noMoreUsersToDisplay];
        return;
    }
    User *user = self.usersToDisplay[userIdx];
    
    SwipeView *view = [[[NSBundle mainBundle] loadNibNamed:@"SwipeView" owner:self options:nil] objectAtIndex:0];
    view = [view initWithFrame:self.swipeContentView.frame options:self.options];
    [view initWithUserObject:user];
    view.frame = self.swipeContentView.frame;
    [self.view addSubview:view];
}

- (void)noMoreUsersToDisplay {
    [self.noUsersToDisplayLabel setHidden:NO]; 
}

- (void)swipedLeft {
    User *curUser = [User currentUser];
    User *them = self.usersToDisplay[userIdx];
    [curUser.usersSeen addObject:them.objectId];
    curUser.usersSeen = curUser.usersSeen;
    [curUser saveInBackground];
}

- (void)swipedRight {
    User *curUser = [User currentUser];
    User *them = self.usersToDisplay[userIdx];
    
    [curUser.usersSeen addObject:them.objectId];
    curUser.usersSeen = curUser.usersSeen;
    [curUser saveInBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Requests"];
    [query whereKey:@"from" equalTo:them.objectId];
    [query whereKey:@"to" equalTo:curUser.objectId];
    NSArray* results = [query findObjects];
    if(results.count != 0){
        [results[0] deleteInBackground];
        // match animation!!!
        PFObject *match = [PFObject objectWithClassName:@"Matches"];
        match[@"user1"] = them.objectId;
        match[@"user2"] = curUser.objectId;
        [match saveInBackground];
        return;
    }
    
    PFObject *request = [PFObject objectWithClassName:@"Requests"];
    request[@"from"] = curUser.objectId;
    request[@"to"] = them.objectId;
    [request saveInBackground];
}

@end
