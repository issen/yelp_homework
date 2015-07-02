//
//  FilterViewController.m
//  Yelp
//
//  Created by Issen Su on 6/26/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "SwitchCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *filterSections;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSMutableDictionary *selectedFilters;

- (void) initCategories;
- (void) initFilterSections;
@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self initFilterSections];
        self.selectedFilters = [[NSMutableDictionary alloc] init];
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.filterSections[section][@"label"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filterSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.categories.count;
    return [self.filterSections[section][@"options"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
//    
//    cell.titleLabel.text = self.categories[indexPath.row][@"name"];
//    cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
//    cell.delegate = self;
//    return cell;
    NSDictionary *filterSection = self.filterSections[indexPath.section];
    NSDictionary *filterName = filterSection[@"name"];
    NSDictionary *filterValue = filterSection[@"options"][indexPath.row];
    NSString *filterCode = filterValue[@"code"];
    
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    cell.titleLabel.text = filterValue[@"name"];
    
    cell.delegate = self;
    
//    cell.on = [self.selectedFilters[filterName] containsObject:filterCode];
    if ([filterSection[@"name"] isEqualToString:@"category_filter"]) {
        cell.on = [self.selectedFilters[filterName] containsObject:filterCode];
    } else {
        NSLog(@"selectfilter %@ = %@", filterName,self.selectedFilters[filterName]);
        NSLog(@"code = %@", filterCode);
        if (self.selectedFilters[filterName] == filterCode) {
            cell.on = YES;
        } else {
            cell.on = NO;
        }
    }
    

    
    return cell;
}

#pragma mark - Switch cell Delegate method
- (void) switchCell:(SwitchCell *) cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *section = self.filterSections[indexPath.section];
    NSString *code = section[@"options"][indexPath.row][@"code"];
    
    if ([section[@"name"] isEqualToString:@"category_filter"]) {
        NSMutableSet *selectedOption;
        if (self.selectedFilters[section[@"name"]]) {
            selectedOption = self.selectedFilters[section[@"name"]];
        } else {
            selectedOption = [NSMutableSet set];
        }
        if (value) {
            //[self.selectedCategories addObject:self.categories[indexPath.row]];
            [selectedOption addObject:code];
        
        } else {
            //[self.selectedCategories removeObject:self.categories[indexPath.row]];
            [selectedOption removeObject:code];
        }
        self.selectedFilters[section[@"name"]] = selectedOption;
    } else {
        //loop cells in sections to uncheck.
        NSInteger numberOfRowInSection = [self.tableView numberOfRowsInSection:indexPath.section];
        for (int row = 0; row < numberOfRowInSection ; row++) {
            if (row != indexPath.row) {
                SwitchCell *cellDeactivate = (SwitchCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
                cellDeactivate.on = NO;
            }
        }
        self.selectedFilters[section[@"name"]] = code;
        cell.on = YES;
    }

    NSLog(@"%@", self.selectedFilters);

}

#pragma mark - Private method

- (NSDictionary *) filters {
    NSMutableSet *categories = self.selectedFilters[@"category_filter"];
    NSLog(@"categoru filter count = %ld", categories.count);
    if (categories.count > 0 ) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSString *category in categories) {
            [names addObject:category];
        }
        NSString *categoryFiter = [names componentsJoinedByString:@","];
        self.selectedFilters[@"category_filter"] = categoryFiter;
    }
    return self.selectedFilters;
//    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
//    if (self.selectedCategories.count > 0) {
//        NSMutableArray *names = [NSMutableArray array];
//        for (NSDictionary *category in self.selectedCategories) {
//            [names addObject:category[@"code"]];
//        }
//        NSString *categoryFiter = [names componentsJoinedByString:@","];
//        [filters setObject:categoryFiter forKey:@"category_filter"];
//    }
//    return filters;
    
}


- (void) onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) onApplyButton {
    [self.delegate filterViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) initCategories {
    self.categories =
     @[@{@"name" : @"Afghan", @"code" : @"afghani"},
     @{@"name" : @"African", @"code" : @"african"},
     @{@"name" : @"American, New", @"code" : @"newamerican"}
     ];
}

- (void) initFilterSections {
    NSDictionary *mostPopularFilter = @{
                                        @"label": @"Most Popular",
                                        @"name": @"deals_filter",
                                        @"options": @[
                                                @{@"name": @"Offering a Deal", @"code": @"1"}
                                                ]
                                        };
    
    NSDictionary *distanceFilter = @{
                                     @"label": @"Distance",
                                     @"name": @"radius_filter",
                                     @"options": @[
                                             @{@"name": @"Best Match", @"code": @""},
                                             @{@"name": @"0.3 miles", @"code": @"482"},
                                             @{@"name": @"1 mile", @"code": @"1609"},
                                             @{@"name": @"5 miles", @"code": @"8046"},
                                             @{@"name": @"20 miles", @"code": @"32186"}
                                             ]
                                     };
    
    NSDictionary *sortByFilter = @{
                                   @"label": @"Sort by",
                                   @"name": @"sort",
                                   @"options": @[
                                           @{@"name": @"Best Match", @"code": @"0"},
                                           @{@"name": @"Distance", @"code": @"1"},
                                           @{@"name": @"Rating", @"code": @"2"}
                                           ]
                                   };
    NSDictionary *categoriesFilter = @{
                                       @"label": @"Categories",
                                       @"name": @"category_filter",
                                       @"options": @[
                                               @{@"name": @"Afghan", @"code": @"afghani"},
                                               @{@"name": @"African", @"code": @"african"},
                                               @{@"name": @"American, New", @"code": @"newamerican"},
                                               @{@"name": @"American, Traditional", @"code": @"tradamerican"},
                                               @{@"name": @"Arabian", @"code": @"arabian"},
                                               @{@"name": @"Argentine", @"code": @"argentine"},
                                               @{@"name": @"Armenian", @"code": @"armenian"},
                                               @{@"name": @"Asian Fusion", @"code": @"asianfusion"},
                                               @{@"name": @"Asturian", @"code": @"asturian"},
                                               @{@"name": @"Australian", @"code": @"australian"},
                                               @{@"name": @"Austrian", @"code": @"austrian"},
                                               @{@"name": @"Baguettes", @"code": @"baguettes"},
                                               @{@"name": @"Bangladeshi", @"code": @"bangladeshi"},
                                               @{@"name": @"Barbeque", @"code": @"bbq"},
                                               @{@"name": @"Basque", @"code": @"basque"},
                                               @{@"name": @"Bavarian", @"code": @"bavarian"},
                                               @{@"name": @"Beer Garden", @"code": @"beergarden"},
                                               @{@"name": @"Beer Hall", @"code": @"beerhall"},
                                               @{@"name": @"Beisl", @"code": @"beisl"},
                                               @{@"name": @"Belgian", @"code": @"belgian"},
                                               @{@"name": @"Bistros", @"code": @"bistros"},
                                               @{@"name": @"Black Sea", @"code": @"blacksea"},
                                               @{@"name": @"Brasseries", @"code": @"brasseries"},
                                               @{@"name": @"Brazilian", @"code": @"brazilian"},
                                               @{@"name": @"Breakfast & Brunch", @"code": @"breakfast_brunch"},
                                               @{@"name": @"British", @"code": @"british"},
                                               @{@"name": @"Buffets", @"code": @"buffets"},
                                               @{@"name": @"Bulgarian", @"code": @"bulgarian"},
                                               @{@"name": @"Burgers", @"code": @"burgers"},
                                               @{@"name": @"Burmese", @"code": @"burmese"},
                                               @{@"name": @"Cafes", @"code": @"cafes"},
                                               @{@"name": @"Cafeteria", @"code": @"cafeteria"},
                                               @{@"name": @"Cajun/Creole", @"code": @"cajun"},
                                               @{@"name": @"Cambodian", @"code": @"cambodian"},
                                               @{@"name": @"Canadian", @"code": @"New)"},
                                               @{@"name": @"Canteen", @"code": @"canteen"},
                                               @{@"name": @"Caribbean", @"code": @"caribbean"},
                                               @{@"name": @"Catalan", @"code": @"catalan"},
                                               @{@"name": @"Chech", @"code": @"chech"},
                                               @{@"name": @"Cheesesteaks", @"code": @"cheesesteaks"},
                                               @{@"name": @"Chicken Shop", @"code": @"chickenshop"},
                                               @{@"name": @"Chicken Wings", @"code": @"chicken_wings"},
                                               @{@"name": @"Chilean", @"code": @"chilean"},
                                               @{@"name": @"Chinese", @"code": @"chinese"},
                                               @{@"name": @"Comfort Food", @"code": @"comfortfood"},
                                               @{@"name": @"Corsican", @"code": @"corsican"},
                                               @{@"name": @"Creperies", @"code": @"creperies"},
                                               @{@"name": @"Cuban", @"code": @"cuban"},
                                               @{@"name": @"Curry Sausage", @"code": @"currysausage"},
                                               @{@"name": @"Cypriot", @"code": @"cypriot"},
                                               @{@"name": @"Czech", @"code": @"czech"},
                                               @{@"name": @"Czech/Slovakian", @"code": @"czechslovakian"},
                                               @{@"name": @"Danish", @"code": @"danish"},
                                               @{@"name": @"Delis", @"code": @"delis"},
                                               @{@"name": @"Diners", @"code": @"diners"},
                                               @{@"name": @"Dumplings", @"code": @"dumplings"},
                                               @{@"name": @"Eastern European", @"code": @"eastern_european"},
                                               @{@"name": @"Ethiopian", @"code": @"ethiopian"},
                                               @{@"name": @"Fast Food", @"code": @"hotdogs"},
                                               @{@"name": @"Filipino", @"code": @"filipino"},
                                               @{@"name": @"Fish & Chips", @"code": @"fishnchips"},
                                               @{@"name": @"Fondue", @"code": @"fondue"},
                                               @{@"name": @"Food Court", @"code": @"food_court"},
                                               @{@"name": @"Food Stands", @"code": @"foodstands"},
                                               @{@"name": @"French", @"code": @"french"},
                                               @{@"name": @"French Southwest", @"code": @"sud_ouest"},
                                               @{@"name": @"Galician", @"code": @"galician"},
                                               @{@"name": @"Gastropubs", @"code": @"gastropubs"},
                                               @{@"name": @"Georgian", @"code": @"georgian"},
                                               @{@"name": @"German", @"code": @"german"},
                                               @{@"name": @"Giblets", @"code": @"giblets"},
                                               @{@"name": @"Gluten-Free", @"code": @"gluten_free"},
                                               @{@"name": @"Greek", @"code": @"greek"},
                                               @{@"name": @"Halal", @"code": @"halal"},
                                               @{@"name": @"Hawaiian", @"code": @"hawaiian"},
                                               @{@"name": @"Heuriger", @"code": @"heuriger"},
                                               @{@"name": @"Himalayan/Nepalese", @"code": @"himalayan"},
                                               @{@"name": @"Hong Kong Style Cafe", @"code": @"hkcafe"},
                                               @{@"name": @"Hot Dogs", @"code": @"hotdog"},
                                               @{@"name": @"Hot Pot", @"code": @"hotpot"},
                                               @{@"name": @"Hungarian", @"code": @"hungarian"},
                                               @{@"name": @"Iberian", @"code": @"iberian"},
                                               @{@"name": @"Indian", @"code": @"indpak"},
                                               @{@"name": @"Indonesian", @"code": @"indonesian"},
                                               @{@"name": @"International", @"code": @"international"},
                                               @{@"name": @"Irish", @"code": @"irish"},
                                               @{@"name": @"Island Pub", @"code": @"island_pub"},
                                               @{@"name": @"Israeli", @"code": @"israeli"},
                                               @{@"name": @"Italian", @"code": @"italian"},
                                               @{@"name": @"Japanese", @"code": @"japanese"},
                                               @{@"name": @"Jewish", @"code": @"jewish"},
                                               @{@"name": @"Kebab", @"code": @"kebab"},
                                               @{@"name": @"Korean", @"code": @"korean"},
                                               @{@"name": @"Kosher", @"code": @"kosher"},
                                               @{@"name": @"Kurdish", @"code": @"kurdish"},
                                               @{@"name": @"Laos", @"code": @"laos"},
                                               @{@"name": @"Laotian", @"code": @"laotian"},
                                               @{@"name": @"Latin American", @"code": @"latin"},
                                               @{@"name": @"Live/Raw Food", @"code": @"raw_food"},
                                               @{@"name": @"Lyonnais", @"code": @"lyonnais"},
                                               @{@"name": @"Malaysian", @"code": @"malaysian"},
                                               @{@"name": @"Meatballs", @"code": @"meatballs"},
                                               @{@"name": @"Mediterranean", @"code": @"mediterranean"},
                                               @{@"name": @"Mexican", @"code": @"mexican"},
                                               @{@"name": @"Middle Eastern", @"code": @"mideastern"},
                                               @{@"name": @"Milk Bars", @"code": @"milkbars"},
                                               @{@"name": @"Modern Australian", @"code": @"modern_australian"},
                                               @{@"name": @"Modern European", @"code": @"modern_european"},
                                               @{@"name": @"Mongolian", @"code": @"mongolian"},
                                               @{@"name": @"Moroccan", @"code": @"moroccan"},
                                               @{@"name": @"New Zealand", @"code": @"newzealand"},
                                               @{@"name": @"Night Food", @"code": @"nightfood"},
                                               @{@"name": @"Norcinerie", @"code": @"norcinerie"},
                                               @{@"name": @"Open Sandwiches", @"code": @"opensandwiches"},
                                               @{@"name": @"Oriental", @"code": @"oriental"},
                                               @{@"name": @"Pakistani", @"code": @"pakistani"},
                                               @{@"name": @"Parent Cafes", @"code": @"eltern_cafes"},
                                               @{@"name": @"Parma", @"code": @"parma"},
                                               @{@"name": @"Persian/Iranian", @"code": @"persian"},
                                               @{@"name": @"Peruvian", @"code": @"peruvian"},
                                               @{@"name": @"Pita", @"code": @"pita"},
                                               @{@"name": @"Pizza", @"code": @"pizza"},
                                               @{@"name": @"Polish", @"code": @"polish"},
                                               @{@"name": @"Portuguese", @"code": @"portuguese"},
                                               @{@"name": @"Potatoes", @"code": @"potatoes"},
                                               @{@"name": @"Poutineries", @"code": @"poutineries"},
                                               @{@"name": @"Pub Food", @"code": @"pubfood"},
                                               @{@"name": @"Rice", @"code": @"riceshop"},
                                               @{@"name": @"Romanian", @"code": @"romanian"},
                                               @{@"name": @"Rotisserie Chicken", @"code": @"rotisserie_chicken"},
                                               @{@"name": @"Rumanian", @"code": @"rumanian"},
                                               @{@"name": @"Russian", @"code": @"russian"},
                                               @{@"name": @"Salad", @"code": @"salad"},
                                               @{@"name": @"Sandwiches", @"code": @"sandwiches"},
                                               @{@"name": @"Scandinavian", @"code": @"scandinavian"},
                                               @{@"name": @"Scottish", @"code": @"scottish"},
                                               @{@"name": @"Seafood", @"code": @"seafood"},
                                               @{@"name": @"Serbo Croatian", @"code": @"serbocroatian"},
                                               @{@"name": @"Signature Cuisine", @"code": @"signature_cuisine"},
                                               @{@"name": @"Singaporean", @"code": @"singaporean"},
                                               @{@"name": @"Slovakian", @"code": @"slovakian"},
                                               @{@"name": @"Soul Food", @"code": @"soulfood"},
                                               @{@"name": @"Soup", @"code": @"soup"},
                                               @{@"name": @"Southern", @"code": @"southern"},
                                               @{@"name": @"Spanish", @"code": @"spanish"},
                                               @{@"name": @"Steakhouses", @"code": @"steak"},
                                               @{@"name": @"Sushi Bars", @"code": @"sushi"},
                                               @{@"name": @"Swabian", @"code": @"swabian"},
                                               @{@"name": @"Swedish", @"code": @"swedish"},
                                               @{@"name": @"Swiss Food", @"code": @"swissfood"},
                                               @{@"name": @"Tabernas", @"code": @"tabernas"},
                                               @{@"name": @"Taiwanese", @"code": @"taiwanese"},
                                               @{@"name": @"Tapas Bars", @"code": @"tapas"},
                                               @{@"name": @"Tapas/Small Plates", @"code": @"tapasmallplates"},
                                               @{@"name": @"Tex-Mex", @"code": @"tex-mex"},
                                               @{@"name": @"Thai", @"code": @"thai"},
                                               @{@"name": @"Traditional Norwegian", @"code": @"norwegian"},
                                               @{@"name": @"Traditional Swedish", @"code": @"traditional_swedish"},
                                               @{@"name": @"Trattorie", @"code": @"trattorie"},
                                               @{@"name": @"Turkish", @"code": @"turkish"},
                                               @{@"name": @"Ukrainian", @"code": @"ukrainian"},
                                               @{@"name": @"Uzbek", @"code": @"uzbek"},
                                               @{@"name": @"Vegan", @"code": @"vegan"},
                                               @{@"name": @"Vegetarian", @"code": @"vegetarian"},
                                               @{@"name": @"Venison", @"code": @"venison"},
                                               @{@"name": @"Vietnamese", @"code": @"vietnamese"},
                                               @{@"name": @"Wok", @"code": @"wok"},
                                               @{@"name": @"Wraps", @"code": @"wraps"},
                                               @{@"name": @"Yugoslav", @"code": @"yugoslav"}
                                               ]
                                       };
    self.filterSections = @[mostPopularFilter, distanceFilter, sortByFilter, categoriesFilter];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
