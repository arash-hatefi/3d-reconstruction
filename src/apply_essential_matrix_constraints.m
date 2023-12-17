function E = apply_essential_matrix_constraints(E_approx)

assert(isequal(size(E_approx), [3,3]), "Size of E_approx must be [3,3]!");

[U, ~, V] = svd(E_approx);
if (det(U*V')<0)
    V = -V;
end
E = U*diag([1 1 0])*V';

%E = E / E(3,3);

end

