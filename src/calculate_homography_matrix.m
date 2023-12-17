function H = calculate_homography_matrix(x1s, x2s)

assert(size(x1s,1)==2 | size(x1s,1)==3, "Wrong x1s shape!");
assert(size(x2s,1)==2 | size(x2s,1)==3, "Wrong x2s shape!");
assert(isequal(size(x1s), size(x2s)), "Size of x1s and x2s must be equal!");
assert(size(x2s,2)==4, "Four points are required to calculate the homography matrix!");

if (size(x1s, 1)==3)
    x1s = project_to_flat_representation(x1s);
    x1s = x1s(1:2,:);
end
if (size(x2s, 1)==3)
    x2s = project_to_flat_representation(x2s);
    x2s = x2s(1:2,:);
end

M = [x1s(1, 1), 0, -x1s(1, 1)*x2s(1, 1), x1s(2, 1), 0, -x1s(2, 1)*x2s(1, 1), 1, 0;
     0, x1s(1, 1), -x1s(1, 1)*x2s(2, 1), 0, x1s(2, 1), -x1s(2, 1)*x2s(2, 1), 0, 1;
     x1s(1, 2), 0, -x1s(1, 2)*x2s(1, 2), x1s(2, 2), 0, -x1s(2, 2)*x2s(1, 2), 1, 0;
     0, x1s(1, 2), -x1s(1, 2)*x2s(2, 2), 0, x1s(2, 2), -x1s(2, 2)*x2s(2, 2), 0, 1;
     x1s(1, 3), 0, -x1s(1, 3)*x2s(1, 3), x1s(2, 3), 0, -x1s(2, 3)*x2s(1, 3), 1, 0;
     0, x1s(1, 3), -x1s(1, 3)*x2s(2, 3), 0, x1s(2, 3), -x1s(2, 3)*x2s(2, 3), 0, 1;
     x1s(1, 4), 0, -x1s(1, 4)*x2s(1, 4), x1s(2, 4), 0, -x1s(2, 4)*x2s(1, 4), 1, 0;
     0, x1s(1, 4), -x1s(1, 4)*x2s(2, 4), 0, x1s(2, 4), -x1s(2, 4)*x2s(2, 4), 0, 1];

if rcond(M)<1e-10
    H = [];
else
    H = [M\x2s(:);1];
    H = reshape(H, [3,3]);
end

end

