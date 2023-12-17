function [Xs, Ps_normal, errors] = perform_bundle_adjustment(Xs, xs, Ps_normal, n_iter, lambda, lambda_decay_factor)

if nargin<6
    lambda_decay_factor = 2;
end
if nargin<5
    lambda = 2;
end
if nargin<4
    n_iter = 300;
end

[init_err, ~] = calculate_reprojection_error(Ps_normal, Xs, xs);
errors = init_err;

for i=1:n_iter
    [r, J] = linearize_reprojection_error_model(Ps_normal, Xs, xs, "X");
    C = J'*J+lambda*speye(size(J ,2));
    c = J'*r;
    delta = -C\c ;
    [new_Xs, ~] = update_optimization_solution(delta, Ps_normal, Xs, "X");
    
    [r, J] = linearize_reprojection_error_model(Ps_normal, Xs, xs, "P");
    C = J'*J+lambda*speye(size(J ,2));
    c = J'*r;
    delta = -C\c ;
    [~, new_Ps_normal] = update_optimization_solution(delta, Ps_normal, Xs, "P");
    
    [error, ~] = calculate_reprojection_error(new_Ps_normal, new_Xs, xs);
    if error<errors(end)
        errors = [errors, error];
        Xs = new_Xs;
        Ps_normal = new_Ps_normal;
    else
        lambda = lambda * lambda_decay_factor;
    end
end

Xs = project_to_flat_representation(Xs);

end

