//
//  PhotoGridViewController.m
//  CustomImagePickerLibrary
//
//  Created by Hema on 08/05/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import "PhotoGridViewController.h"
#define kCellsPerRow 3

@interface PhotoGridViewController () {
    NSMutableArray *selectedArrayCount;
    int maximumCount;
}
@property (weak, nonatomic) IBOutlet UICollectionView *imageGridCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *selectedCountLabel;

@end

@implementation PhotoGridViewController
@synthesize assets;
@synthesize assetsGroup;
@synthesize selectedCountLabel;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //set maximum slected images
    maximumCount=6;
    
    selectedArrayCount=[[NSMutableArray alloc]init];
    
    selectedCountLabel.hidden=YES;
    //allow multiple selection
    [self.imageGridCollectionView setAllowsMultipleSelection:YES];
    
    //set 3 images in one row in collection view
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.imageGridCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow-1);
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow);
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //set navigation bar not hidden
    self.navigationController.navigationBar.hidden=NO;
    //fetch photos from group
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    if (!self.assets) {
        assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets addObject:result];
        }
    };
    //filter only photos
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];//change filter for videos
    [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
    [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.imageGridCollectionView reloadData];
}

#pragma mark - Collection view delegate and datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"photoCell";
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    // load the asset for this cell
    ALAsset *asset = self.assets[indexPath.row];
    CGImageRef thumbnailImageRef = [asset aspectRatioThumbnail];
    UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailImageRef];
    // apply the image to the cell
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
     UIImageView *selectedImage = (UIImageView*)[cell viewWithTag:2];
    imageView.image = thumbnail;
    if (cell.selected==YES) {
        selectedImage.hidden=NO;
    }
    else {
        selectedImage.hidden=YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedArrayCount.count<maximumCount) {
        UICollectionViewCell *selectedCell =[collectionView cellForItemAtIndexPath:indexPath];
        UIImageView *selectedImage = (UIImageView*)[selectedCell viewWithTag:2];
        selectedImage.hidden=NO;
        // Determine the selected items by using the indexPath
        UIImage *selectedRecipe = [self.assets objectAtIndex:indexPath.row];
        // Add the selected item into the array
        [selectedArrayCount addObject:selectedRecipe];
        if (selectedArrayCount.count==0) {
            selectedCountLabel.hidden=YES;
        }
        else if (selectedArrayCount.count==1){
            selectedCountLabel.hidden=NO;
            selectedCountLabel.text=[NSString stringWithFormat:@"%d photo selected",(int)selectedArrayCount.count];
        }
        else {
            selectedCountLabel.hidden=NO;
            selectedCountLabel.text=[NSString stringWithFormat:@"%d photos selected",(int)selectedArrayCount.count];
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            //show toast
            NSString *message = [NSString stringWithFormat:@"You can select a maximum of %d images.",maximumCount];
            UIAlertController * toast = [UIAlertController
                                         alertControllerWithTitle:nil
                                         message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:toast animated:YES completion:nil];
            int duration = 2; // duration in seconds
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{                [toast dismissViewControllerAnimated:YES completion:nil];
            });
        });
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *selectedCell =[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *selectedImage = (UIImageView*)[selectedCell viewWithTag:2];
    selectedImage.hidden=YES;
    UIImage *selectedRecipe = [self.assets objectAtIndex:indexPath.row];
    // Add the selected item into the array
    [selectedArrayCount removeObject:selectedRecipe];
    if (selectedArrayCount.count==0) {
        selectedCountLabel.hidden=YES;
    }
    else if (selectedArrayCount.count==1){
        selectedCountLabel.hidden=NO;
        selectedCountLabel.text=[NSString stringWithFormat:@"%d photo selected",(int)selectedArrayCount.count];
    }
    else {
        selectedCountLabel.hidden=NO;
        selectedCountLabel.text=[NSString stringWithFormat:@"%d photos selected",(int)selectedArrayCount.count];
    }
    if (selectedArrayCount.count==0) {
        self.imageGridCollectionView.allowsSelection=YES;
    }
}

@end
