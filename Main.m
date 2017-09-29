%% Reaction diffursion in 1920x1080
close all

clear all

%% parameters

video = VideoWriter('movie.avi');
video.FrameRate = 30;
video.Quality = 100;
open(video);

 myfigure = figure('Position',  [  50, 50 , 1980 , 1080   ] ); %set up what your figure needs to look like

h = 72*2;
w = 128*2;
numarrows = 14;

spot = repmat( [h/2,w/2] , numarrows , 1 );
spotspeed=rand(numarrows,2)-0.5;

dt = 0.1; 
Da = 0.2;
Db = 0.05;
f = 0.055;
maxf = 0.055;
minf = 0.015;
%f = linspace(0.001 , 0.06 , h);
%f = repmat( f , w , 1  );
%k = linspace(0.04 , 0.06 , w);
%k = repmat( k , h , 1  );

k= 0.06;

%% initialize

A = ones(h,w);
B = 0*rand(h,w)*2;

[audiofile,Fs] = audioread('Drums.flac') ;%read audio file

audiolength = 40*30*(numel(audiofile(:,1)) / (Fs)); %captureinterval*framerate*audioduration
cmax = 0; %set max on colorbar

for i = 1:round(audiolength)-1

    
%% React ahd diffuse

A = A  + dt *  (- A.*B.^2 + f.*(1 - A))   +   Da*dt*Diffuse(A) ;

B = B + dt * ( A.*B.^2 - (f + k ).*B )  +  Db*dt*Diffuse(B) ;

%if mean(B(:))<0.1  , B (  ceil(rand()*h  ) , ceil(rand()*w  )   ) = 1; end

%% change other parameters

if audiofile( ceil( i/audiolength*numel(audiofile(:,1))) , 1  ) > 0.8, spotspeed = 3*(rand(numarrows,2) - 0.5); end %change direction of movement with same frequency as bpm

spot = spot + spotspeed*dt; 
spotin(:,1) = mod(round(spot(:,1)) -1 , h   ) + 1; spotin(:,2) = mod(round(spot(:,2)) -1 , w   ) + 1;

if audiofile( ceil( i/audiolength*numel(audiofile(:,1))) , 1  ) > 0.8, f = maxf; end %change f with kick bass

f = f - dt*0.01*(f - minf); %f goes no lower than minf

if f > 0.02 %only color stuff when f is above a certain value

for j = 1:numarrows, B( spotin(j,1)     , spotin(j,2) ) =  wmean( [ B( spotin(j,1)     , spotin(j,2) ) , 0.6] , [1 ,  (f - minf)/(maxf-minf)*10] )   ; end %weighted mean to decided how much effect arrows will have on pixel

end

if mod(i,40)==0

%surf(B , 'EdgeColor' , 'none'); view(0,90);
pcolor(B)
axis off
cmax = max( cmax , max(B(:))) ;
caxis([0   cmax  ])
shading interp
%camlight
%colormap jet
colormap bone
drawnow

frame = getframe(); writeVideo(video,frame);

end

end

close(video)