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
#import "ProfileDetailsViewController.h"
#import "SwipeView.h"
#import "Chat.h"

#import "Roommatch-Swift.h"

int userIdx;

@interface DiscoverViewController () <SwipeViewDelegate>

@property (strong, nonatomic) SwipeView *currentSwipeView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) NSMutableArray *usersToDisplay;
@property (strong, nonatomic) MDCSwipeToChooseViewOptions *options;
@property (weak, nonatomic) IBOutlet UIView *swipeContentView;
@property (weak, nonatomic) IBOutlet UILabel *noUsersToDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchMessageLabel;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    self.options = [MDCSwipeToChooseViewOptions new];
    self.options.likedText = @"Yes";
    self.options.nopeText = @"Nope";
    self.options.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    if(self.currentSwipeView)
        [self.currentSwipeView removeFromSuperview];
    [self queryUsers];
}

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
    }];
}

- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        [self swipedLeft];
        [self displayNextUser];
    } else {
        [self swipedRight];
    }
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
    self.currentSwipeView = view;
    view.delegate = self; 
    [self.view addSubview:view];
}

- (void)noMoreUsersToDisplay {
    [self.noUsersToDisplayLabel setHidden:NO]; 
}

- (void)swipedLeft {
    User *curUser = [User currentUser];
    User *them = self.usersToDisplay[userIdx++];
    
    [curUser addObject:them.objectId forKey:@"usersSeen"];
    [curUser saveInBackground];
}

- (void)swipedRight {
    User *curUser = [User currentUser];
    User *them = self.usersToDisplay[userIdx++];
    
    [curUser addObject:them.objectId forKey:@"usersSeen"];
    [curUser saveInBackground];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Request"];
    [query whereKey:@"from" equalTo:them];
    [query whereKey:@"to" equalTo:curUser];
    NSArray* results = [query findObjects];
    if(results.count != 0){
        [results[0] deleteInBackground];
        [self matchAnimation];
        Chat *chat = [Chat new];
        chat.user1 = curUser;
        chat.user2 = them;
        chat.lastMessageText = @"Send a message!";
        chat.messages = [NSMutableArray array];
        [chat saveInBackground]; 
        return;
    }
    
    PFObject *request = [PFObject objectWithClassName:@"Request"];
    request[@"from"] = curUser;
    request[@"to"] = them;
    [request saveInBackground];
    [self displayNextUser];
}

- (void)matchAnimation {
    ConfettiAnimation * confettiAnimation = [[ConfettiAnimation alloc] init];
    [self.matchMessageLabel setHidden:NO];

    [confettiAnimation playMatchAnimationForView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [NSThread sleepForTimeInterval:2.0f];
      dispatch_async(dispatch_get_main_queue(), ^{
          [self.matchMessageLabel setHidden:YES];
          [self displayNextUser];
      });
    });
}

- (void)showDetailedView {
    [self performSegueWithIdentifier:@"discoverDetailedView" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProfileDetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.user = self.usersToDisplay[userIdx];
}

@end
