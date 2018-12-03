//
//  fileSelectController.m
//  secretManagerkit
//
//  Created by mac  on 2018/11/28.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "fileSelectController.h"
#import "cell_file.h"

@interface fileSelectController ()

@end

@implementation fileSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"载入界面");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"cell_file" bundle:nil] forCellReuseIdentifier:@"cell_file"];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell_file *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_file"];
    if(!cell){
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"cell_file" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
        cell = [[cell_file alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_file"];
    }
    return cell;
}



@end
