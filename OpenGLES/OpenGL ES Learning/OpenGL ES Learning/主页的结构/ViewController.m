//
//  ViewController.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/1/24.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "ViewController.h"
#import "QGCell.h"
#import "QGModel.h"
#import "QGViewController.h"
#import "QGViewController1.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)NSArray *modesArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView *tab = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tab];
    [tab registerClass:[QGCell class] forCellReuseIdentifier:QGCellID];
    tab.delegate = self;
    tab.dataSource = self;
    
    self.modesArray = @[
        [QGModel createModelWithTitle:@"绘制三角形状"],
        [QGModel createModelWithTitle:@"正方形渐变"],
        [QGModel createModelWithTitle:@"加载图片"],
        [QGModel createModelWithTitle:@"两个图片纹理混合"],
        [QGModel createModelWithTitle:@"正方体五个面相同"],
        [QGModel createModelWithTitle:@"正方体五个面不同"],
        [QGModel createModelWithTitle:@"加载视频"],
        [QGModel createModelWithTitle:@"3D立体球体"],
        [QGModel createModelWithTitle:@"3D 贴图"],
        [QGModel createModelWithTitle:@"3D材质, 环境光"],
        [QGModel createModelWithTitle:@"光照+贴图"],
        [QGModel createModelWithTitle:@"封装的GLES"],
    ];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QGCell *cell = [tableView dequeueReusableCellWithIdentifier:QGCellID];
    QGModel *model = self.modesArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QGViewController *vc = [[QGViewController alloc]init];
    vc.type = indexPath.row;

    QGViewController1 *vc1 = [[QGViewController1 alloc]init];
    [self presentViewController:vc1 animated:YES completion:nil];
}
@end
