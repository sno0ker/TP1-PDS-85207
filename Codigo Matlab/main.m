load handel.mat
N=1;
Fs=8000;
 %%===========================================================================================================%%
 %%                                        	CAPTAÇÃO DE SOM                                                   %%
 %%===========================================================================================================%%
som = audiorecorder(8000,16,1);     %% Fs=8000Hz, nBits = 16, 1 canal -> Cria um objeto
recordblocking(som, 10);             %% Grava durante 10 segundos
double_som= getaudiodata(som);     %% Converte o objeto de audio em double, permitindo reproduzir, visualizar e manipular

figure
plot(double_som);
title('Sinal de som original');
xlabel('Tempo');
ylabel('Amplitude');
figure
freqz(double_som);                
title('Diagrama de bode do sinal de som original');
filename = 'som_original.wav';
audiowrite(filename,double_som,Fs);
for N=2: 8
    Fs=8000/N;
    %%===========================================================================================================%%
    %%                                         DECIMAÇÃO SEM FILTRAGEM                                           %%
    %%===========================================================================================================%%
    
    decimado_nao_filtrado=decimacao(double_som,N);
    figure
    plot(decimado_nao_filtrado);
    title(sprintf('Sinal de som nao filtrado com N=%d',N));
    figure
    freqz(decimado_nao_filtrado);
    title(sprintf('Diagrame de bode do sinal de som não filtrado com N=%d',N));
    filename=sprintf('NaoFiltradoN=%d.wav',N);
    
    audiowrite(filename,decimado_nao_filtrado,round(Fs));    
    %%===========================================================================================================%%
    %%                                         DESIGN DO FILTRO                                                  %%
    %%===========================================================================================================%   
    banda_passante=pi/N;
    banda_rejeicao= banda_passante + 0.2*banda_passante;
    Wp= 2*tan(banda_passante/2);
    Ws= 2*tan(banda_rejeicao/2);
    Rp=-20*log10(1-0.01); %%Ganho 1 (1) ripple de 40 db (0.01)
    Rs=60;
    [n,Wp]=ellipord(Wp,Ws,Rp,Rs,'s');
    [b,a]=ellip(n,Rp,Rs,Wp,'s');
    [numd,dend]=bilinear(b,a,1);
    figure
    freqz(numd,dend);
    title(sprintf('Diagrama de Bode do filtro para N=%d',N));
  
    %%===========================================================================================================%%
    %%                                         DECIMAÇÃO COM FILTRAGEM                                           %%
    %%===========================================================================================================%%
   
    %% APLICAÇAO DO FILTRO  
    sinal_filtrado=filter(numd,dend,double_som);
    figure
    plot(sinal_filtrado);
    title('Sinal de som filtrado não decimado');
    figure
    freqz(sinal_filtrado);
    title('Diagrama de bode do sinal de som filtrado não decimado');   
    %%DECIMAÇÃO    
    sinal_final=decimacao(sinal_filtrado,N);
    figure
    plot(sinal_final);
    title(sprintf('Sinal de som filtrado decimado com N=%d',N));
    figure
    freqz(sinal_final);
    title(sprintf('Diagrama de bode do sinal filtrado decimado e com N=%d',N));
    filename=sprintf('FiltradoN=%d.wav',N);
    audiowrite(filename,sinal_final,round(Fs));
    
end
