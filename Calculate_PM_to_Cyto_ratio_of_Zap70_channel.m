%%  this code requires croped single cell movies regardless of image size
clc 
clear all 
close all


%% calculate the single cell PM to cyto ratio of all the files in the
% folder.
file_names=dir('*.tif');
file_number= numel(dir('*.tif'));
i=1;
while i<=numel(dir('*.tif'))
    %this is to get list of all the file names
single_movie=file_names(i).name;
% single_cell_PM_cyto_ratio_auto is a self made function 
[cyto,PM,zap_ave,ratio]=single_cell_PM_cyto_ratio_auto(single_movie);
% save the calculated ratios and mean PM and Cyto values for each cell, the
%result is compiled in a structure. 
saved_PM_cyto(i).ratio=ratio;
saved_PM_cyto(i).PM=PM;
saved_PM_cyto(i).cyto=cyto;
i=i+1;
end


%% plot the data
%frame_tick=1:3.77:i*3.77;
for i=1:numel(dir('*.tif'))
    X=1:3.77:numel(saved_PM_cyto(i).ratio)*3.77;
plot(X,saved_PM_cyto(i).ratio,'*-k','linewidth',1);
hold on
end
hold off 
% title('LckR273K Y505F transfected cell','FontSize',25)
xticks(0:10:70);
set(gca,'FontSize',18);
xlim([0, 70]);
ylim([0.3 1.2]);
axis square;
xlabel('Time (second)','FontSize',22);
ylabel('PM to cyto ratio','FontSize',22);

% use imtool edit to remove problem non-sense tracks


%% calculate the increaes of zap70 PM/cyto ratio from the begining to the end of the trigectories
for i=1:numel(dir('*.tif'))
mean_beginning(i)=mean(saved_PM_cyto(i).ratio(1:4));
mean_end(i)=mean(saved_PM_cyto(i).ratio(end-5:end-1));
delta_change(i)=(mean_end(i)-mean_beginning(i))/mean_beginning(i);
end
good_raito=delta_change(delta_change>-0.02)';
 plot(good_raito,'k*');
 hold on
 plot(delta_change,'r+');
 ylim([-0.2 .5]);
%% reploting the good tracks
count=1;
 for i=1:numel(dir('*.tif'))
 if delta_change(i)>-0.1;
    X=1:3.77:numel(saved_PM_cyto(i).ratio)*3.77;
pp=plot(X,saved_PM_cyto(i).ratio,'-k','linewidth',1.1);
count=count+1;
 end
hold on
end
hold off 

title('LckK273R Y505F','FontSize',21);
xticks(0:10:70);
yticks(0:0.2:1.4);
set(gca,'FontSize',18);
xlim([0, 70]);
ylim([0.2 1.0]);
axis square;
xlabel('Time (seconds)','FontSize',22);
ylabel('PM to cyto ratio','FontSize',22);
