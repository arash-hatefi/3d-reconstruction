function E = estimate_E_with_plain_parallax(x1s, x2s, H, degensac_threshold)

assert(isequal(size(H), [3,3]), "Wrong H shape!");
assert(size(x1s,1)==2 | size(x1s,1)==3, "Wrong x1s shape!");
assert(size(x2s,1)==2 | size(x2s,1)==3, "Wrong x2s shape!");
assert(isequal(size(x1s), size(x2s)), "Size of x1s and x2s must be equal!");
% assert(size(x2s,2)==2, "2 off-plain correspondances are required!");

if (size(x1s, 1)==2)
    x1s = [x1s; ones(1, length(x1s))];
end
if (size(x2s, 1)==2)
    x2s = [x2s; ones(1, length(x2s))];
end
x1s = project_to_flat_representation(x1s);
x2s = project_to_flat_representation(x2s);

errors = sqrt(sum((project_to_flat_representation(H*x1s)-x2s).^2));
H_outliers = errors>degensac_threshold;
if (sum(H_outliers)<2)
	E = 0;
    return
end
H_offseted_x1s = x1s(:, H_outliers);
H_offseted_x2s = x2s(:, H_outliers);
idx = randperm(size(H_offseted_x1s, 2), 2);
offseted_x1s = H_offseted_x1s(:, idx); %Is it good?
offseted_x2s = H_offseted_x2s(:, idx);

x1s_homograohy = project_to_flat_representation(H*offseted_x1s);

ls = cross(offseted_x2s, x1s_homograohy);
e2 = cross(ls(:, 1), ls(:, 2));

E = [0, -e2(3), e2(2); e2(3), 0, -e2(1); -e2(2), e2(1), 0] * H;

end

