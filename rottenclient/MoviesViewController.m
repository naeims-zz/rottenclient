//
//  MoviesViewController.m
//  rottenclient
//
//  Created by Naeim Semsarilar on 2/3/15.
//  Copyright (c) 2015 naeim. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

-(void)makeMovieListRequest:(NSString*)endpointUrl completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))completionHandler ;
@end

@implementation MoviesViewController

NSString* apiKey = @"uv9vztvx4nqmbcde5qbtne9h";
NSString* moviesListFormat = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/%@.json?country=us&apikey=%@";
NSString* upcomingListEndpoint;
NSString* boxOfficeListEndpoint;

- (void)viewDidLoad {
    [super viewDidLoad];

    // configure endpoints
    upcomingListEndpoint = [NSString stringWithFormat:moviesListFormat, @"upcoming", apiKey];
    boxOfficeListEndpoint = [NSString stringWithFormat:moviesListFormat, @"box_office", apiKey];
    
    // configure table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    self.tableView.rowHeight = 80;
    
    // make request to get data
    [self onRefresh];
    
    // configure other things
    self.title = @"Box Office Movies";
    
    // refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.refreshControl removeConstraints:self.refreshControl.constraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)makeMovieListRequest:(NSString*)endpointUrl completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))completionHandler {
    NSURL *url = [NSURL URLWithString:endpointUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:completionHandler];
}

- (void)onRefresh {
    [self makeMovieListRequest:boxOfficeListEndpoint completionHandler:^void (NSURLResponse *response, NSData *data, NSError *connectionError) {
        // parse the response and reload data
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        self.movies = responseDictionary[@"movies"];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    // set up cell UI
    cell.titleLabel.text = movie[@"title"];
    
    NSInteger audienceScore = [[movie valueForKeyPath:@"ratings.audience_score"] integerValue];
    NSString* audienceRating = [movie valueForKeyPath:@"ratings.audience_rating"];
    if (!audienceRating) {
        audienceRating = @"WTS";
    }
    NSInteger criticsScore = [[movie valueForKeyPath:@"ratings.critics_score"] integerValue];
    NSString* criticsRating = [movie valueForKeyPath:@"ratings.critics_rating"];
    
    if (audienceScore >= 0) {
        cell.audienceRating.text = [NSString stringWithFormat:@"%ld%%", audienceScore];
        [cell.audienceIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", audienceRating]]];
    } else {
        cell.audienceRating.hidden = YES;
        cell.audienceIcon.hidden = YES;
    }
    
    if (criticsScore >= 0) {
        cell.criticsRating.text = [NSString stringWithFormat:@"%ld%%", criticsScore];
        [cell.criticsIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", criticsRating]]];
    } else {
        cell.criticsRating.hidden = YES;
        cell.criticsIcon.hidden = YES;
    }
    
    // mpaa
    NSString* mpaa = movie[@"mpaa_rating"];
    if (mpaa && [mpaa length] > 0) {
        cell.mpaaLabel.layer.borderColor = [UIColor grayColor].CGColor;
        cell.mpaaLabel.layer.borderWidth = 1.0;
        cell.mpaaLabel.text = [NSString stringWithFormat:@" %@ ", mpaa];
        [cell.mpaaLabel sizeToFit];
    } else {
        cell.mpaaLabel.hidden = YES;
    }
    
    NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:url]];
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    
    vc.movie = self.movies[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
