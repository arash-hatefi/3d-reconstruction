function [X_new, Ps_new] = update_optimization_solution(delta, Ps, X, mode)

    if nargin<4
        mode = "X";
    end
    mode = string(sort(convertStringsToChars(mode)));
    
    if (mode=="X")
        X_new = project_to_flat_representation(X + reshape(delta, size(X)));
        Ps_new = Ps;
    elseif (mode=="P")
        X_new = X;
        Ps_new = Ps;
        for i=1:length(Ps)
            Ps_new{i} = Ps_new{i} + reshape(delta(12*(i-1)+1:12*i), [3,4]);
        end
    elseif (mode=="PX")
        X_new = X + reshape(delta(end-numel(X)+1:end), size(X));
        Ps_new = Ps;
        for i=1:length(Ps)
            Ps_new{i} = Ps_new{i} + reshape(delta(12*(i-1)+1:12*i), [3,4]);
        end
    else
        error("Unknown mode!");
    end
end

