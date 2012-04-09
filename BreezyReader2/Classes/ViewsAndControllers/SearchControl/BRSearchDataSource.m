//
//  BRSearchDataSource.m
//  BreezyReader2
//
//  Created by 金 津 on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BRSearchDataSource.h"

@interface BRSearchDataSource ()

@end

@implementation BRSearchDataSource

@synthesize delegate = _delegate;
@synthesize results = _results;
@synthesize keywords = _keywords;
@synthesize request = _request;
@synthesize client = _client;

-(void)dealloc{
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    [self.client clearAndCancel];
    self.client = nil;
    self.results = nil;
    self.keywords = nil;
    [super dealloc];
}

-(id)init{
    self = [super init];
    if (self){
        self.results = [NSMutableArray array];
    }
    
    return self;
}

-(void)startSearchWithKeywords:(NSString *)keywords{
    _searching = YES;
    self.keywords = keywords;
    self.results = nil;;
    [self.delegate dataSourceDidStartSearching:self];
}

-(void)searchFinished{
    _searching = NO;
    [self.delegate performSelectorOnMainThread:@selector(dataSourceDidFinishSearching:) withObject:self waitUntilDone:NO];
    [self.delegate performSelectorOnMainThread:@selector(dataSourceDidLoadMore:) withObject:self waitUntilDone:NO];
}

-(void)loadMoreSearchResult{
    [self.delegate dataSourceDidStartLoadMore:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNumber = 0;
    if (_searching){
        rowNumber = 1;
    }else {
        rowNumber = [self.results count];
    }
    return rowNumber;
}

-(id)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

-(id)objectAtIndexPath:(NSIndexPath*)indexPath{
    return [self.results objectAtIndex:indexPath.row];
}

-(BOOL)hasMore{
    return NO;
}

-(BOOL)isLoading{
    return [self.request isExecuting];
}

@end