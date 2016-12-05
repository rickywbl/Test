//
//  RSTableViewCell.m
//  TableViewHeightCache
//
//  Created by 王保霖 on 2016/12/1.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "RSTableViewCell.h"

@implementation RSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGSize)sizeThatFits:(CGSize)size{

    CGFloat hight = 0;
    
    hight += [self.title sizeThatFits:CGSizeMake(size.width - 100 -10, 100)].height;
    
    hight += [self.image sizeThatFits:size].height;
    
    return CGSizeMake(size.width, hight + 35);
    
}

@end
