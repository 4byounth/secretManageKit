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


-(void)setData:(NSString *)path{
    
    NSDirectoryEnumerator *enumerator = [_fileManager enumeratorAtPath:path];
    //创建临时可变数组
    NSMutableArray<fileProperty *>*tempArray = [NSMutableArray array];
    
    //遍历属性
    NSString *fileName;
    
    while(fileName = [enumerator nextObject]){
        NSLog(@"%@",fileName);
        //跳过子路径
        [enumerator skipDescendants];
        //去掉隐藏的系统文件
        if([fileName isEqualToString:@"__MACOSX"]){
            continue;
        }
        NSString *fileType;
        NSLog(@"%@",enumerator.fileAttributes.fileType);
        if([enumerator.fileAttributes.fileType isEqualToString:NSFileTypeRegular]){
            fileType = [[fileName pathExtension] lowercaseString];
            if([fileType isEqualToString:@""]){
                fileType = @"未知";
            }
        }
        else if([enumerator.fileAttributes.fileType isEqualToString:NSFileTypeDirectory]){
            fileType = @"D";
        }
        fileProperty *model = [[fileProperty alloc] init];
        NSNumber *fileSize = [[NSNumber alloc] initWithLong:(long)enumerator.fileAttributes.fileSize];
        
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSString *createDate = [formate stringFromDate:enumerator.fileAttributes.fileCreationDate];
        
        model.fileName = fileName;
        model.fileType = fileType;
        model.fileSize = fileSize.stringValue;
        model.createDate = createDate;
        
//        model.fileSize = [[NSString alloc] initWithFormat:@"%d" arguments:(int)enumerator.fileAttributes.fileSize/1024];
        [tempArray addObject:model];
    }
    self.fileArray = tempArray;
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if(isDir){
        [self.tableView reloadData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"载入界面");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"cell_file" bundle:nil] forCellReuseIdentifier:@"cell_file"];
    self.fileManager = [NSFileManager defaultManager];
    NSString *homePath = NSHomeDirectory();
    self.current_path = homePath;
    [self setData:homePath];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell_file *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_file"];
    if(!cell){
        cell = [[cell_file alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_file"];
    }
    [cell fillData:_fileArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    cell_file *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.current_path = [_current_path stringByAppendingFormat:@"/%@",cell.label_file_name.text];
    [self setData:self.current_path];
}


@end
