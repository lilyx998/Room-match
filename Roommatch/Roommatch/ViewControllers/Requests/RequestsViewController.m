//
//  RequestsViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/19/22.
//

#import "RequestsViewController.h"
#import "TheirProfileDetailsViewController.h"
#import "User.h"
#import "RequestCell.h"
#import <Parse/Parse.h>

@interface RequestsViewController () <UITableViewDataSource, RequestCellDelegate>

@property (strong, nonatomic) NSMutableArray *usersToDisplay;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation RequestsViewController


#pragma mark - View initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(queryAndDisplayRequests) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.tableView.dataSource = self; 
}

- (void)viewWillAppear:(BOOL)animated {
    [self.activityIndicator startAnimating];
    [self queryAndDisplayRequests];
}

- (void)queryAndDisplayRequests {
    PFQuery *query = [PFQuery queryWithClassName:@"Request"];
    User *curUser = [User currentUser];
    
    [query whereKey:@"to" equalTo:curUser];
    [query orderByDescending:@"updatedAt"]; 
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *requests, NSError *error) {
        if (requests) {
            self.usersToDisplay = [NSMutableArray array];
            for(PFObject *request in requests){
                [self.usersToDisplay addObject:request[@"from"]];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    }];
}


#pragma mark - Table view of Requests

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestCell" forIndexPath:indexPath];
    
    User *user = self.usersToDisplay[indexPath.row];
    [cell configureWithUserObject:user];
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersToDisplay.count;
}


#pragma mark - Refresh after user interaction

- (void)didInteractWithUser {
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(queryAndDisplayRequests) object:nil];
    [self performSelector:@selector(queryAndDisplayRequests) withObject:nil afterDelay:2.0];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    User *userToPass = self.usersToDisplay[indexPath.row];
    TheirProfileDetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.user = userToPass;
}

@end
