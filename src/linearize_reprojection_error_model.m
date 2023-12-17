function [r,J] = linearize_reprojection_error_model(P, Xs, xs, mode)

    if nargin<4
        mode = "X";
    end
    mode = string(sort(convertStringsToChars(mode)));

    if (mode=="X")
        J = J_X(P,Xs,xs);
        r = r_X(P,Xs,xs);
    elseif (mode=="P")
        J = J_P(P,Xs,xs);
        r = r_P(P,Xs,xs);
    elseif (mode=="PX")
        J = J_PX(P,Xs,xs);
        r = r_PX(P,Xs,xs);
    else
        error("Unknown mode!");
    end
    
end

function r = r_X(P,Xs,xs)
    for i=1:length(xs)
        xs{i} = project_to_flat_representation(xs{i});
    end

    m = length(P);
    n = length(Xs);

    r = zeros(2*m*n, 1);
    idx = 1;
    for j=1:n
        for i=1:m
            Pi = P{i};
            Xj = Xs(:,j);
            xi = xs{i};
            xij = xi(:,j);
            xij_proj = project_to_flat_representation(Pi*Xj);
            r(idx:idx+1) = xij(1:2)-xij_proj(1:2);
            idx = idx + 2;
        end
    end
end

function r = r_P(P,Xs,xs)
    r = r_X(P,Xs,xs);
end

function r = r_PX(P,Xs,xs)
    r = r_X(P,Xs,xs);
end

function J = J_X(P,Xs,xs)

    for i=1:length(xs)
        xs{i} = project_to_flat_representation(xs{i});
    end

    m = length(P);
    n = length(Xs);

    J = sparse(zeros(2*m*n, 4*n));
    for j=1:n
        tmp = zeros(2*m, 4);
        for i=1:m
            Pi = P{i};
            Xj = Xs(:,j);
            x = Pi*Xj;
            J_i_X_j = [Pi(3,:)*x(1)/x(3)^2-Pi(1,:)/x(3); ...
                       Pi(3,:)*x(2)/x(3)^2-Pi(2,:)/x(3)];
            tmp(2*i-1:2*i,:) = J_i_X_j;
        end
        J((j-1)*2*m+1:2*j*m, (j-1)*4+1:4*j) = tmp;
    end

end

function J = J_P(P,Xs,xs)

    for i=1:length(xs)
        xs{i} = project_to_flat_representation(xs{i});
    end

    m = length(P);
    n = length(Xs);

    J = sparse(zeros(2*m*n, 12*m));
    idx = 1;
    for j=1:n
        for i=1:m
            Pi = P{i};
            Xj = Xs(:,j);
            x = Pi*Xj;
            J_P_Pi_Xj = [-1/x(3), 0, x(1)/x(3)^2; 0, -1/x(3), x(2)/x(3)^2] * kron(Xj', eye(3));
            J(idx:idx+1, (i-1)*12+1:12*i) = J_P_Pi_Xj;
            idx = idx + 2;
        end
    end
end

function J = J_PX(P,Xs,xs)

    for i=1:length(xs)
        xs{i} = project_to_flat_representation(xs{i});
    end

    m = length(P);
    n = length(Xs);
    J = sparse(zeros(2*m*n, 4*n+12*m));
    idx = 1;
    for j=1:n
        for i=1:m        
            Pi = P{i};
            Xj = Xs(:,j);
            x = Pi*Xj;
            J_X_Pi_Xj = [Pi(3,:)*x(1)/x(3)^2-Pi(1,:)/x(3); ...
                         Pi(3,:)*x(2)/x(3)^2-Pi(2,:)/x(3)];
            J(idx:idx+1, 12*m+4*(j-1)+1:12*m+4*j) = J_X_Pi_Xj;

            J_P_Pi_Xj = [-1/x(3), 0, x(1)/x(3)^2; 0, -1/x(3), x(2)/x(3)^2] * kron(Xj', eye(3));
            J(idx:idx+1, 12*(i-1)+1:12*i) = J_P_Pi_Xj;

            idx = idx + 2;
        end
    end

end