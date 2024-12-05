function out = fn_basis_function(x,p,i)

coeff = p.coeff;
%out   = -2*(coeff(i,1)/coeff(i,3))*((x-coeff(i,2))/coeff(i,3))*exp(-((x-coeff(i,2))/coeff(i,3))^2);

out   = -2*(coeff(i,1)/coeff(i,3))*((x-coeff(i,2))/coeff(i,3))*exp(-((x-coeff(i,2))/coeff(i,3))^2);

end