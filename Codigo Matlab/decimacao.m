function y=decimacao(sinal,N) 
 
for i=1 : (length(sinal)/N) 
    y(i)=sinal(N*i);    %% xd[n} = x[nN]
end; 

