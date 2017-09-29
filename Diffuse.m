function [ DA ] = Diffuse( A )
%Diffuse Diffuse the stuff in A
%   This function allows you to diffuse stuff in A. After you are done, multiply by appropriate constant that represents D*dt/dx^2

DA = [ A( 2:end , :   ) ; A( 1 , :) ] + [   A( end , :    ) ; A( 1 : end-1 , : ) ] + [ A(  :  ,  2:end   ) , A( : , 1 ) ] + [   A( : , end     ) , A( : ,  1 : end-1  )   ]   - 4*A;


end

