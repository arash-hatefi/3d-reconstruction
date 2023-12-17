clear;
clc;
close all;

addpath('./src');

try
    vl_version verbose
catch
    run("./lib/install_VLFeat_toolbox.m");
end

dataset_number = 1;
execute_structure_from_motion(dataset_number);