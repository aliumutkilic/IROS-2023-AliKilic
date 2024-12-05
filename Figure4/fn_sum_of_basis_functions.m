function out = fn_sum_of_basis_functions(x,p)  

coeff = p.coeff;
n     = size(coeff,1); % number of basis functions in the sum
out   = zeros(1,length(x));
for i = 1:n
  out = out + fn_basis_function(x,p,i);
end

end