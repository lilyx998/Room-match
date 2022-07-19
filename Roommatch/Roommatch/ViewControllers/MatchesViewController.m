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
    [self queryMatchesWhereCurrentUserIsKey:@"user1" matchIsKey:@"user2"];
    [self queryMatchesWhereCurrentUserIsKey:@"user2" matchIsKey:@"user1"];
}

- (void)queryMatchesWhereCurrentUserIsKey:(NSString *)currentUserKey matchIsKey:(NSString *)matchKey{
    PFQuery *query = [PFQuery queryWithClassName:@"Matches"];
    User *curUser = [User currentUser];
    
    [query whereKey:currentUserKey equalTo:curUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *requests, NSError *error) {
        if (requests) {
            self.usersToDisplay = [NSMutableArray array];
            for(PFObject *request in requests){
                PFUser* user = request[matchKey];
                user = [PFQuery getUserObjectWithId:user.objectId];
                [self.usersToDisplay addObject:user];
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
