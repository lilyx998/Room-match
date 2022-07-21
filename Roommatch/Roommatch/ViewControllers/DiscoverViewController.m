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

@interface DiscoverViewController () <UITableViewDataSource, RequestCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *usersToDisplay;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryAndDisplayUsers) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    UINib *nib = [UINib nibWithNibName:@"ProfileCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"profileCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self queryAndDisplayUsers];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)queryAndDisplayUsers {
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
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    
    User* user = self.usersToDisplay[indexPath.row];
    [cell initWithUserObject:user];
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersToDisplay.count;
}

- (void)didInteractWithUser {
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(queryAndDisplayUsers) object:nil];
    [self performSelector:@selector(queryAndDisplayUsers) withObject:nil afterDelay:2.0];
}

@end
