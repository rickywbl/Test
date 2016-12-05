//
//  ViewController.m
//  TableViewHeightCache
//
//  Created by 王保霖 on 2016/12/1.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+RSHeightCache.h"
#import "RSTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RSTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];

}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [self configWithCell:cell indexPath:indexPath];
    
    return  cell;
    
    
}

-(void)configWithCell:(RSTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{

    cell.NoAutoSizing = NO;
    
    NSArray *arr = @[@"但是当TableView的cell中包含图片时，使用SDWebImage加载图片虽然是异步过程，但是仍然十分占用系统资源。那么我们就要想一个办法去优化加载图片的逻辑。",@"但是当TableView的ce",@"但是当TableView的ce但是当TableView的ce但是当TableView的ce但是当TableView的ce",@"但是当TableView的ce",@"但是当TableView的ce但是当TableView的ce但是当TableView的ce但是当TableView的ce但是当TableView的ce",@"但是当TableView的ce但是当TableView的ce",@"但是当TableView的ce但是当TableView的ce但是当TableView的ce",@"但是当TableView的ce但是当TableView的ce",@"但是当TableView的ce但是当TableView的ce"];
    
    cell.title.text = arr[indexPath.row];
    
    NSString * name = indexPath.row%2?@"home_独家特供":@"矢量图";
    [cell.image setImage:[UIImage imageNamed:name]];
    
    cell.title.numberOfLines = 0;
    

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 9;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tableView rs_heightForCellWithIdentifier:@"cell" cacheByKey:indexPath configuration:^(RSTableViewCell * cell) {
        
        [self configWithCell:cell indexPath:indexPath];
    }];

}





@end
