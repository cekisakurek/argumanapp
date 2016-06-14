//
//  ArgumentDetailsViewController.m
//  Arguman
//
//  Created by Cihan Emre Kisakurek (Company) on 09/06/16.
//  Copyright © 2016 cekisakurek. All rights reserved.
//

#import "ArgumentDetailsViewController.h"
#import "ArgumentTableHeaderView.h"
#import "PremiseCell.h"
#import "Argument.h"
#import "PremiseDetailsViewController.h"

@interface ArgumentDetailsViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong) UITableView *tableView;
@property (strong) ArgumentTableHeaderView *headerView;
@property (strong) PremiseCell *heightCalculaterCell;
@end

@implementation ArgumentDetailsViewController

- (instancetype)initWithArgument:(Argument *)argument
{
    self = [super init];
    if (self)
    {
        self.argument = argument;
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[PremiseCell class] forCellReuseIdentifier:@"cell"];

    self.headerView = [[ArgumentTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 100)];
    self.tableView.tableHeaderView = self.headerView;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.headerView setArgument:self.argument];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.argument.topLayerPremises.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PremiseCell *cell = (PremiseCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    // Configure the cell...

    Premise *premise = self.argument.topLayerPremises[indexPath.row];
    [cell setPremise:premise];
    if (premise.childPremises.count)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Premise *premise = self.argument.topLayerPremises[indexPath.row];

    if (premise.childPremises.count)
    {
        PremiseDetailsViewController *detailsViewController = [[PremiseDetailsViewController alloc] initWithPremise:premise];
        [self.navigationController pushViewController:detailsViewController animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Determine which reuse identifier should be used for the cell at this
    // index path.
    //    NSString *reuseIdentifier = ...;

    // Use a dictionary of offscreen cells to get a cell for the reuse
    // identifier, creating a cell and storing it in the dictionary if one
    // hasn't already been added for the reuse identifier. WARNING: Don't
    // call the table view's dequeueReusableCellWithIdentifier: method here
    // because this will result in a memory leak as the cell is created but
    // never returned from the tableView:cellForRowAtIndexPath: method!

    if (!self.heightCalculaterCell) {
        self.heightCalculaterCell = [[PremiseCell alloc] init];

    }

    Premise *premise = self.argument.topLayerPremises[indexPath.row];
    [self.heightCalculaterCell setPremise:premise];


    // Configure the cell with content for the given indexPath, for example:
    // cell.textLabel.text = someTextForThisCell;
    // ...

    // Make sure the constraints have been set up for this cell, since it
    // may have just been created from scratch. Use the following lines,
    // assuming you are setting up constraints from within the cell's
    // updateConstraints method:
    [self.heightCalculaterCell setNeedsUpdateConstraints];
    [self.heightCalculaterCell updateConstraintsIfNeeded];

    // Set the width of the cell to match the width of the table view. This
    // is important so that we'll get the correct cell height for different
    // table view widths if the cell's height depends on its width (due to
    // multi-line UILabels word wrapping, etc). We don't need to do this
    // above in -[tableView:cellForRowAtIndexPath] because it happens
    // automatically when the cell is used in the table view. Also note,
    // the final width of the cell may not be the width of the table view in
    // some cases, for example when a section index is displayed along
    // the right side of the table view. You must account for the reduced
    // cell width.
    self.heightCalculaterCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.heightCalculaterCell.bounds));

    // Do the layout pass on the cell, which will calculate the frames for
    // all the views based on the constraints. (Note that you must set the
    // preferredMaxLayoutWidth on multi-line UILabels inside the
    // -[layoutSubviews] method of the UITableViewCell subclass, or do it
    // manually at this point before the below 2 lines!)
    [self.heightCalculaterCell setNeedsLayout];
    [self.heightCalculaterCell layoutIfNeeded];

    // Get the actual height required for the cell's contentView
    CGFloat height = [self.heightCalculaterCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    // Add an extra point to the height to account for the cell separator,
    // which is added between the bottom of the cell's contentView and the
    // bottom of the table view cell.
    height += 10.0f;
    
    return height;
}

@end
