function distances = calculate_epipolar_errors(F, x1s, x2s)

assert(size(x1s,1)==2 | size(x1s,1)==3, "Wrong x1s shape!");
assert(size(x2s,1)==2 | size(x2s,1)==3, "Wrong x2s shape!");
assert(isequal(size(x1s), size(x2s)), "Size of x1s and x2s must be equal!");
assert(isequal(size(F), [3,3]), "Size of F must be [3,3]!");

if (size(x1s, 1)==2)
    x1s = [x1s; ones(1, size(x1s, 2))];
end
if (size(x2s, 1)==2)
    x2s = [x2s; ones(1, size(x2s, 2))];
end
x1s = project_to_flat_representation(x1s);
x2s = project_to_flat_representation(x2s);

l = F*x1s;
l = l./sqrt(repmat(l(1 ,:).^2 + l(2 ,:).^2 ,[3 1]));
distances = abs(sum(l.*x2s));

end

