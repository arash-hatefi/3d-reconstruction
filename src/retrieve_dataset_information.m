% -*- Octave -*-

% Datasets 1-5 are relatively easy, since they have little lens distortion and
% no dominant scene plane. You should get reasonably good reconstructions for
% these datasets.

% Datasets 6-9 are much more difficult, since the scene is dominated by a near
% planar structure. Without handling degeneracies (such as DGENSAC) you will
% almost certainly not get a good 3D model (especially for sequences 7-9). The
% lens distortion is larger for the used camera, hence the threshold is
% increased to 3 pixels. Feel free to adjust it if necessary.

function [K, img_names, init_pair, threshold] = retrieve_dataset_information(dataset)
  if dataset == 1
    img_names = {"data/1/kronan1.JPG", "data/1/kronan2.JPG"};
    im_width = 1936; im_height = 1296;
    focal_length_35mm = 45.0; % from the EXIF data
    init_pair = [1, 2]; % Only 2 images, so only one choice for the initial pair
    threshold = 2.0;
  elseif dataset == 2
    % Corner of a courtyard
    img_names = {"data/2/DSC_0025.JPG", "data/2/DSC_0026.JPG", "data/2/DSC_0027.JPG", "data/2/DSC_0028.JPG", "data/2/DSC_0029.JPG", ...
                 "data/2/DSC_0030.JPG", "data/2/DSC_0031.JPG", "data/2/DSC_0032.JPG", "data/2/DSC_0033.JPG"};
    im_width = 1936; im_height = 1296;
    focal_length_35mm = 43.0; % from the EXIF data
    init_pair = [1, 8]; % Fill in suitable values
    threshold = 2.0;
  elseif dataset == 3
    % Smaller gate of a cathetral
    img_names = {"data/3/DSC_0001.JPG", "data/3/DSC_0002.JPG", "data/3/DSC_0003.JPG", "data/3/DSC_0004.JPG", "data/3/DSC_0005.JPG", ...
                 "data/3/DSC_0006.JPG", "data/3/DSC_0007.JPG", "data/3/DSC_0008.JPG", "data/3/DSC_0009.JPG", "data/3/DSC_0010.JPG", ...
                 "data/3/DSC_0011.JPG", "data/3/DSC_0012.JPG"};
    im_width = 1936; im_height = 1296;
    focal_length_35mm = 43.0; % from the EXIF data
    init_pair = [2, 11]; % Fill in suitable values
    threshold = 2.0;
  elseif dataset == 4
    % Fountain
    img_names = {"data/4/DSC_0480.JPG", "data/4/DSC_0481.JPG", "data/4/DSC_0482.JPG", "data/4/DSC_0483.JPG", "data/4/DSC_0484.JPG", ...
                 "data/4/DSC_0485.JPG", "data/4/DSC_0486.JPG", "data/4/DSC_0487.JPG", "data/4/DSC_0488.JPG", "data/4/DSC_0489.JPG", ...
                 "data/4/DSC_0490.JPG", "data/4/DSC_0491.JPG", "data/4/DSC_0492.JPG", "data/4/DSC_0493.JPG"};
    im_width = 1936; im_height = 1296;
    focal_length_35mm = 43.0; % from the EXIF data
    init_pair = [3, 14]; % Fill in suitable values
    threshold = 2.0;
  elseif dataset == 5
    % Golden statue
    img_names = {"data/5/DSC_0336.JPG", "data/5/DSC_0337.JPG", "data/5/DSC_0338.JPG", "data/5/DSC_0339.JPG", "data/5/DSC_0340.JPG", ...
                 "data/5/DSC_0341.JPG", "data/5/DSC_0342.JPG", "data/5/DSC_0343.JPG", "data/5/DSC_0344.JPG", "data/5/DSC_0345.JPG"};
    im_width = 1936; im_height = 1296;
    focal_length_35mm = 45.0; % from the EXIF data
    init_pair = [2, 4]; % Fill in suitable values
    threshold = 2.0;
  elseif dataset == 6
    % Detail of the Landhaus in Graz.
    img_names = {"data/6/DSCN2115.JPG", "data/6/DSCN2116.JPG", "data/6/DSCN2117.JPG", "data/6/DSCN2118.JPG", "data/6/DSCN2119.JPG", ...
                 "data/6/DSCN2120.JPG", "data/6/DSCN2121.JPG", "data/6/DSCN2122.JPG"};
    im_width = 2272; im_height = 1704;
    focal_length_35mm = 38.0; % from the EXIF data
    init_pair = [2, 5]; % Our suggestion
    threshold = 3.0;
  elseif dataset == 7
    % Triceratops model on a poster.
    img_names = {"data/7/DSCN5144.JPG", "data/7/DSCN5145.JPG", "data/7/DSCN5146.JPG", "data/7/DSCN5147.JPG", "data/7/DSCN5148.JPG", ...
                 "data/7/DSCN5149.JPG", "data/7/DSCN5150.JPG", "data/7/DSCN5151.JPG", "data/7/DSCN5152.JPG", "data/7/DSCN5153.JPG"};
    im_width = 2272; im_height = 1704;
    focal_length_35mm = 38.0; % from the EXIF data
    init_pair = [7, 8]; % Our suggestion
    threshold = 3.0;
  elseif dataset == 8
    % Roman building in Trier
    img_names = {"data/8/DSCN7225.JPG", "data/8/DSCN7226.JPG", "data/8/DSCN7227.JPG", "data/8/DSCN7228.JPG", "data/8/DSCN7229.JPG", ...
                 "data/8/DSCN7230.JPG", "data/8/DSCN7231.JPG", "data/8/DSCN7232.JPG", "data/8/DSCN7233.JPG", "data/8/DSCN7234.JPG"};
    im_width = 2272; im_height = 1704;
    focal_length_35mm = 38.0; % from the EXIF data
    init_pair = [4, 7]; % Our suggestion
    threshold = 3.0;
  elseif dataset == 9
    % Building in Heidelberg.
    % Largely planar facade, tough to get a good 3D model
    img_names = {"data/9/DSCN7408.JPG", "data/9/DSCN7409.JPG", "data/9/DSCN7410.JPG", "data/9/DSCN7411.JPG", ...
                 "data/9/DSCN7412.JPG", "data/9/DSCN7413.JPG", "data/9/DSCN7414.JPG", "data/9/DSCN7415.JPG"};
    im_width = 2272; im_height = 1704;
    focal_length_35mm = 38.0; % from the EXIF data
    init_pair = [1, 2]; % Our suggestion
    threshold = 3.0;
  elseif dataset == 10
    K = [2759.48 0 1520.69; 0 2764.16 1006.81; 0 0 1]; 
    img_names = {"data/10/0000.JPG", "data/10/0001.JPG", "data/10/0002.JPG", "data/10/0003.JPG", ...
                 "data/10/0004.JPG", "data/10/0005.JPG", "data/10/0006.JPG"};
    init_pair = [3, 6];
    threshold = 2.0;
    return
  elseif dataset == 11
    K = [2759.48 0 1520.69; 0 2764.16 1006.81; 0 0 1]; 
    img_names = {"data/11/0000.JPG", "data/11/0001.JPG", "data/11/0002.JPG", "data/11/0003.JPG", ...
                 "data/11/0004.JPG", "data/11/0005.JPG", "data/11/0006.JPG", "data/11/0007.JPG"};
    init_pair = [5, 8];
    threshold = 2.0;
    return
  end
  
  focal_length = max(im_width, im_height) * focal_length_35mm / 35.0;
  K = [focal_length 0 im_width/2; 0 focal_length im_height/2; 0 0 1];
end
