//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "MapViewController.h"
#import "DivvyStation.h"

@interface StationsListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSDictionary *bikesDict;
@property NSArray *stationsArray;
@property NSMutableArray *divvyStationsArray;
@property NSMutableArray *filteredDivvy;
@property BOOL filtered;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filteredDivvy = [[NSMutableArray alloc]init];
    self.filtered = NO;
    
    self.searchBar.delegate = self;
    self.bikesDict = [[NSDictionary alloc]init];
    self.divvyStationsArray = [NSMutableArray new];
    
    NSURL *url = [NSURL URLWithString:@"http://www.divvybikes.com/stations/json/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                self.bikesDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
                    self.stationsArray = [self.bikesDict objectForKey:@"stationBeanList"];
                    
                    for (NSDictionary *stationDict in self.stationsArray)
                    {
//                        NSDictionary *divvyDict = [self.bikes objectAtIndex:indexPath.row];
                        
                        NSString *name = [stationDict objectForKey:@"stationName"];
                        NSString *address = [stationDict objectForKey:@"stAddress1"];
                        NSNumber *longitude = [stationDict objectForKey:@"longitude"];
                        NSNumber *latitude = [stationDict objectForKey:@"latitude"];
                        NSString *docks = [[stationDict objectForKey:@"availableBikes"] stringValue];
                        
                        DivvyStation *divvyStation = [[DivvyStation alloc] initWithName:name address:address longitude:longitude latitude:latitude bikeSpots:docks];
                        
                        [self.divvyStationsArray addObject:divvyStation];
                    }
                    
                    [self.tableView reloadData];
                    
//                    NSSortDescriptor * ascendingDistance = [[NSSortDescriptor alloc] initWithKey:@"distanceFromUser" ascending:YES];
//                    NSArray *sortedArray = [self.bikes sortedArrayUsingDescriptors:@[ascendingDistance]];
        }];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filtered) {
        return  self.filteredDivvy.count;
    }
    return self.divvyStationsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (self.filtered)
    {
        DivvyStation *divvyStation = [self.filteredDivvy objectAtIndex:indexPath.row];
        cell.textLabel.text = divvyStation.name;
        cell.detailTextLabel.text = divvyStation.bikeSpots;
    }else{

    DivvyStation *divvyStation = [self.divvyStationsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = divvyStation.name;
    cell.detailTextLabel.text = divvyStation.bikeSpots;
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MapViewController *mapVC = segue.destinationViewController;
    mapVC.divvyStation = [self.divvyStationsArray objectAtIndex:indexPath.row];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        self.filtered = NO;
    }else{
        self.filtered = YES;
        self.filteredDivvy = [NSMutableArray new];
}
    for (DivvyStation *div in self.divvyStationsArray)
    {
        NSRange nameRange = [div.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
        if (nameRange.location != NSNotFound) {
            [self.filteredDivvy addObject:div];
}
        [self.tableView reloadData];
    }
}

@end
