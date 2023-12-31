function [y,alpha]=project_to_flat_representation(x);
% [y,alpha]=project_to_flat_representation(x) - normalization of projective points.
% Do a normalization on the projective
% points in x. Each column is considered to
% be a point in homogeneous coordinates.
% Normalize so that the last coordinate becomes 1.
% WARNING! This is not good if the last coordinate is 0.
% INPUT :
%  x     - matrix in which each column is a point.
%        OR structure or imagedata object with points
% OUTPUT :
%  y     - result after normalization (in homogeneous coordinates)
%  alpha - depth

if isa(x,'structure') | isa (x,'imagedata'),
  x=getpoints(x);
end
[a,n]=size(x);
alpha=x(a,:);
y=x./(ones(a,1)*alpha);
