//
//  RequestsViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/19/22.
//

#import "RequestsViewController.h"
#import "User.h"
#import "RequestCell.h"
#import <Parse/Parse.h>

@interface RequestsViewController () <UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *usersToDisplay;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self; 
    
    UINib *nib = [UINib nibWithNibName:@"ProfileCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"profileCell"];
    
    [self queryRequests];
}

- (void)queryRequests {
    PFQuery *query = [PFQuery queryWithClassName:@"Requests"];
    User *curUser = [User currentUser];
    
    [query whereKey:@"to" equalTo:curUser.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *requests, NSError *error) {
        if (requests) {
            self.usersToDisplay = [NSMutableArray array];
            for(PFObject *request in requests){
                PFUser* user = [PFQuery getUserObjectWithId:request[@"from"]];
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
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    
    User* user = self.usersToDisplay[indexPath.row];
    [cell initWithUserObject:user];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersToDisplay.count;
}

@end
