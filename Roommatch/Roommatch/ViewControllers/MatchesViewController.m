//
//  MatchesViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/19/22.
//

#import "MatchesViewController.h"
#import "User.h"
#import <Parse/Parse.h>
#import "MatchCell.h"

@interface MatchesViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *usersToDisplay;

@end

@implementation MatchesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    [self queryMatches];
}

- (void)queryMatches {
    self.usersToDisplay = [NSMutableArray array];
    User *curUser = [User currentUser];
    
    PFQuery *queryCurrentUserIsUser1 = [PFQuery queryWithClassName:@"Matches"];
    [queryCurrentUserIsUser1 whereKey:@"user1" equalTo:curUser.objectId];
    PFQuery *queryCurrentUserIsUser2 = [PFQuery queryWithClassName:@"Matches"];
    [queryCurrentUserIsUser2 whereKey:@"user2" equalTo:curUser.objectId];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryCurrentUserIsUser1, queryCurrentUserIsUser2]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *matches, NSError *error) {
        if (matches) {
            for(PFObject *matchPair in matches){
                NSString *idString = matchPair[@"user1"];
                if([idString isEqualToString:curUser.objectId])
                    idString = matchPair[@"user2"];
                PFUser* matchUser = [PFQuery getUserObjectWithId:idString];
                [self.usersToDisplay addObject:matchUser];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell" forIndexPath:indexPath];
    
    User* user = self.usersToDisplay[indexPath.row];
    [cell initWithUserObject:user];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersToDisplay.count;
}

@end
