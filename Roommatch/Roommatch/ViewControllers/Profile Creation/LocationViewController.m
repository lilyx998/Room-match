//
//  LocationViewController.m
//  Roommatch
//
//  Created by Lily Yang on 7/14/22.
//

#import "LocationViewController.h"
#import "User.h"
#import "CityTableViewCell.h"
#import "Utils.h"

@interface LocationViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *selectedCity;

@property (nonatomic) NSString *prefix;
@property (nonatomic) NSArray *cities;

@property (strong, nonatomic) CityTableViewCell *selectedCell;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cities = [NSArray array];
    self.prefix = @"";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    User *curUser = [User currentUser];
    if(curUser.profileCreated)
        self.selectedCity = curUser.city; 
    
    [self queryCitiesStartingWithPrefix];
}

- (IBAction)tappedNext:(id)sender {
    if(!self.selectedCity){
        [Utils alertViewController:self WithMessage:@"Must select a city"];
        return;
    }
    [User currentUser].city = self.selectedCity;
    [self performSegueWithIdentifier:@"Selected Location Segue" sender:nil];
}


#pragma mark - TableView with city names

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    cell.cityNameLabel.text = self.cities[indexPath.row];
    if([cell.cityNameLabel.text isEqualToString:self.selectedCity]){
        [cell.checkImageView setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
        self.selectedCell = cell;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectedCell){
        [self.selectedCell.checkImageView setImage:[UIImage systemImageNamed:@""]];
    }
    CityTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.checkImageView setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
    self.selectedCell = cell;
    self.selectedCity = cell.cityNameLabel.text;
}


#pragma mark - Query city names with search text

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(queryCitiesStartingWithPrefix) object:nil];
    self.prefix = searchText;
    [self performSelector:@selector(queryCitiesStartingWithPrefix) withObject:nil afterDelay:1.0];
}

- (void)queryCitiesStartingWithPrefix {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    
    NSDictionary *headers = @{ @"X-RapidAPI-Key": [dict objectForKey: @"GeoDB Key"],
                               @"X-RapidAPI-Host": [dict objectForKey: @"GeoDB Host"] };
    
    NSString* URLString = [[@"https://wft-geo-db.p.rapidapi.com/v1/geo/cities?limit=10&countryIds=Q30&namePrefix=" stringByAppendingString:self.prefix] stringByAppendingString:@"&sort=-population&types=CITY"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSMutableArray* cityNames = [NSMutableArray array];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers   error:nil];
            NSArray *cities = dataDictionary[@"data"];
            
            for(NSDictionary *city in cities){
                NSString *cityString = [[city[@"city"] stringByAppendingString:@", "] stringByAppendingString:city[@"regionCode"]];
                [cityNames addObject:cityString];
            }
            self.cities = cityNames;
        }
        dispatch_semaphore_signal(sema);
    }];
    [dataTask resume];
    
    if (![NSThread isMainThread]) {
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else {
        while (dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW)) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        }
    }
    if(self.selectedCell)
        [self.selectedCell.checkImageView setImage:[UIImage systemImageNamed:@""]];
    [self.tableView reloadData];
}

@end
