function P2 = extract_P_matrix_from_E(E)

assert(isequal(size(E), [3,3]), "Size of E must be [3,3]!");

[U,~,V] = svd(E);

W = [0, -1, 0;
     1, 0, 0;
     0, 0, 1];
 
P2_1 = [U*W*V', U(:, 3)];
P2_2 = [U*W*V', -U(:, 3)];
P2_3 = [U*W'*V', U(:, 3)];
P2_4 = [U*W'*V', -U(:, 3)];

P2 = {P2_1, P2_2, P2_3, P2_4};

end

