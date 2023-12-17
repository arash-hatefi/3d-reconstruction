function E = find_Essential_matrix_from_P_matrices(P1_normalized, P2_normalized)

assert(isequal(size(P1_normalized), [3,4]), "Size of P1_normalized must be [3,4]!");
assert(isequal(size(P1_normalized), [3,4]), "Size of P1_normalized must be [3,4]!");

R1 = P1_normalized(1:3, 1:3);
t1 = P1_normalized(:, 4);

R2 = P2_normalized(1:3, 1:3);
t2 = P2_normalized(:, 4);

R12 = R2 * R1';
t12 = t2 - R12*t1;

t21x = [0, -t12(3), t12(2); t12(3), 0, -t12(1); -t12(2), t12(1), 0];

E = t21x*R12;
E = E / E(1,1);

end

