//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "BusinessCell.h"
#import "Business.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate ,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *businessTableView;

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *business;

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];

    }
    return self;
}

- (void) dismissKeyBoard {
    [self.navigationItem.titleView resignFirstResponder];
}

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"%@",searchBar.text);
    [self fetchBusinessesWithQuery:searchBar.text params:nil];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {

    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        NSArray *businessDict = response[@"businesses"];
        self.business = [Business businessWithDictionaries:businessDict];
        [self.businessTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.businessTableView.dataSource = self;
    self.businessTableView.delegate = self;
    
    [self.businessTableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.businessTableView.rowHeight = UITableViewAutomaticDimension;
    self.businessTableView.estimatedRowHeight = 100;
    
    self.title = @"Yelp";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.business.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    //NSLog(@"%@",cell);
    
    cell.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 99999);
    cell.contentView.bounds = cell.bounds;
    [cell layoutIfNeeded];
    
    
    //cell.nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(cell.nameLabel.frame)
    cell.business = self.business[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - Filter delegate methods
- (void) filterViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters {
    // fire new network event.
    NSLog(@"fire new network event : %@", filters);
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
}

#pragma mark - Private method

- (void)onFilterButton {
    FilterViewController *vc = [[FilterViewController alloc] init];
    vc.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}

@end
