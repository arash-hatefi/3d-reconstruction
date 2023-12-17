clear;
clc;
close all;

try
    vl_version verbose
catch
    run("install_VLFeat_toolbox.m");
end

dataset_number = 11;
pair = find_best_initial_image_pair(dataset_number);

fprintf("Best Inital Pair for dataset %d: [%d, %d]\n", dataset_number, pair(1), pair(2));