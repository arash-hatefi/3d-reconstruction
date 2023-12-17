function [P2_normal, X] = get_valid_P(P1_normal, E, x1s, x2s)

assert(size(x1s,1)==2 | size(x1s,1)==3, "Wrong x1s shape!");
assert(size(x2s,1)==2 | size(x2s,1)==3, "Wrong x2s shape!");
assert(size(x1s, 2)==size(x2s, 2), "Length of x1s and x2s must be equal");
assert(isequal(size(P1_normal), [3,4]), "Size of P1_normal must be [3,4]!");
assert(isequal(size(E), [3,3]), "Size of E must be [3,3]!");

if (size(x1s, 1)==2)
    x1s = [x1s; ones(1, size(x1s, 2))];
end
if (size(x2s, 1)==2)
    x2s = [x2s; ones(1, size(x2s, 2))];
end
x1s = project_to_flat_representation(x1s);
x2s = project_to_flat_representation(x2s);

P2_normal_candidates = extract_P_matrix_from_E(E);

if (det(P2_normal_candidates{1}(1:3,1:3))<0)
    P2_normal_candidates{1} = -1 * P2_normal_candidates{1};
end
if (det(P2_normal_candidates{2}(1:3,1:3))<0)
    P2_normal_candidates{2} = -1 * P2_normal_candidates{2};
end
if (det(P2_normal_candidates{3}(1:3,1:3))<0)
    P2_normal_candidates{3} = -1 * P2_normal_candidates{3};
end
if (det(P2_normal_candidates{4}(1:3,1:3))<0)
    P2_normal_candidates{4} = -1 * P2_normal_candidates{4};
end

[X1, lambda1_1, lambda2_1] = calculate_3D_point_from_DLT(P1_normal, P2_normal_candidates{1}, x1s, x2s);
[X2, lambda1_2, lambda2_2] = calculate_3D_point_from_DLT(P1_normal, P2_normal_candidates{2}, x1s, x2s);
[X3, lambda1_3, lambda2_3] = calculate_3D_point_from_DLT(P1_normal, P2_normal_candidates{3}, x1s, x2s);
[X4, lambda1_4, lambda2_4] = calculate_3D_point_from_DLT(P1_normal, P2_normal_candidates{4}, x1s, x2s);

sum1 = sum((lambda1_1>0) & (lambda2_1>0));
sum2 = sum((lambda1_2>0) & (lambda2_2>0));
sum3 = sum((lambda1_3>0) & (lambda2_3>0));
sum4 = sum((lambda1_4>0) & (lambda2_4>0));

if (sum1>=sum1 && sum1>=sum2 && sum1>=sum3 && sum1>=sum4)
    P2_normal = P2_normal_candidates{1};
    X = X1;
elseif (sum2>=sum1 && sum2>=sum2 && sum2>=sum3 && sum2>=sum4)
    P2_normal = P2_normal_candidates{2};
    X = X2;
elseif (sum3>=sum1 && sum3>=sum2 && sum3>=sum3 && sum3>=sum4)
    P2_normal = P2_normal_candidates{3};
    X = X3;
else
    P2_normal = P2_normal_candidates{4};
    X = X4;
end

end

