%%  
clc 
clear all 
close all


%% calculate the single cell PM to cyto ratio of all the files in the
% folder.
file_names=dir('*.tif');
file_number= numel(dir('*.tif'));
i=1;
while i<=numel(dir('*.tif'))
single_movie=file_names(i).name;
% becareful here (there are self made funcfion to calculate either TCR or 
% zap70 PM to cyto ratio) name as
% single_cell_PM_cyto_ratio_auto_for_TCR_channel or
% single_cell_PM_cyto_ratio;
[cyto,PM,zap_ave,ratio]=single_cell_PM_cyto_ratio_auto_for_TCR_channel(single_movie);

% subplot 311
% imshowpair(cyto,zap_ave);
% colormap gray
% subplot 312
% imshowpair(PM,zap_ave);
% colormap gray
% subplot 313 
% plot(ratio,'*');

% save teh PM_cyto_ratio value of the ROI analyzed to disk.
%xlswrite('PM_to_cyto_ratio.xlsx',temp_ratio,3,'A1');

saved_PM_cyto(i).ratio=ratio;
saved_PM_cyto(i).PM=PM;
saved_PM_cyto(i).cyto=cyto;
i=i+1;
end


%% plot the data
%frame_tick=1:3.77:i*3.77;
for i=1:numel(dir('*.tif'))
    X=1:3.77:numel(saved_PM_cyto(i).ratio)*3.77;
pp=plot(X,saved_PM_cyto(i).ratio,'-k','linewidth',1.1);
hold on
end
hold off 
%title('LckR273K Y505F transfected cell','FontSize',25)
title('LckK273R Y505F','FontSize',21);
xticks(0:10:70);
yticks(0:0.2:1.4);
set(gca,'FontSize',18);
xlim([0, 70]);
ylim([0.5 1.4]);
axis square;
xlabel('Time (second)','FontSize',22);
ylabel('PM to cyto ratio','FontSize',22);

% use imtool edit to remove problem tracks


%% calculate zap70 PM/cyto ratio at the begining and end of the trigectory
for i=1:numel(dir('*.tif'))
mean_beginning(i)=mean(saved_PM_cyto(i).ratio(1:4));
mean_end(i)=mean(saved_PM_cyto(i).ratio(end-5:end-1));
delta_change(i)=(mean_end(i)-mean_beginning(i))/mean_beginning(i);
end
good_raito=delta_change(delta_change>0)';
 plot(good_raito,'k*');
 hold on 
 plot(delta_change,'r+');
 ylim([-0.2 .5]);
%% reploting the good ones
count=1;
 for i=1:numel(dir('*.tif'))
 if end_to_beginning_raito(i)>1
     X=1:3.77:numel(saved_PM_cyto(i).ratio)*3.77;
pp=plot(saved_PM_cyto(i).ratio,'-k','linewidth',1.1);
count=count+1;
 end
 
hold on
end
hold off 
title('Lckwt transfected cell','FontSize',25);
xticks(1:3:24);
yticks(0.3:0.2:1.1);
set(gca,'FontSize',16);
xlim([0, 24]);
ylim([0.3 1.1]);
axis square;
xlabel('Frame number (3.77second / frame)','FontSize',20);
ylabel('zap70 PM to cyto ratio','FontSize',20);
