% Step 1: Read orthomosaick image from folder path
  PomeNIR = imread('20181030 USDA Pome 30m overlap85 NIR.tif');
% Step 2: For MAPIR camera, there are 4 channels, read them
  R = PomeNIR(:,:,1);
  Green = PomeNIR(:,:,2);
  NIR = PomeNIR(:,:,3);
  NON = PomeNIR(:,:,4);
% Step 3: White panel calibration calculation
  DNWhite = imread('2015_0728_223525_007.tif');
% Find the area of interest
  roi = DNWhite(2080:2420,1472:1972,:);
  roi_red = roi(:,:,1);
  roi_nir = roi(:,:,3);
% Calculate the average for reference panel
  DNw_red= mean(roi_red(:)) * ones(22607,12039, 'uint16'); 
  DNw_nir= mean(roi_nir(:)) * ones(22607,12039, 'uint16'); 
% Step 4: DARK PANEL CALIBRATION CALCULATION
  DNDark = imread('2015_0728_223538_009.tif');
  dark_roi = DNDark(2088:2268,1392:1508,:);
% Find the area of interest
  dark_roi_red = dark_roi(:,:,1);
  dark_roi_nir = dark_roi(:,:,3);
% Calculate the average for dark reference panel
  DNd_red= mean(dark_roi_red(:)) * ones(22607,12039, 'uint16'); 
  DNd_nir= mean(dark_roi_nir(:)) * ones(22607,12039, 'uint16');

  NIR_ref = im2double((NIR - DNd_nir)) ./im2double((DNw_nir -  DNd_nir));
  R_ref = im2double((R -  DNd_red)) ./ im2double((DNw_red - DNd_red));
% Calculate NDVI
  ndvi = (NIR_ref - R_ref) ./ (NIR_ref + R_ref);
  I2 = imrotate(ndvi, 180);
% Image display 
  figure
  imshow(ndvi)
  figure
  imshow(I2)
    
  imwrite(I2, 'ndvi.png');