%load the measured line intensity and pair correlation values
% that exported from Ales' software to Origin and finally to excel file. 
[~,sheets]=xlsfinfo('TCR cy2 10 channel' );
for i=1:numel(sheets)
data{i}=xlsread('TCR cy2 10 channel',sheets{i});
end

%% try to remove the NaN by deteting the original cell element and 
% reassign a copy that produced by rmmissing function.
data_new=cell(1,20);
for i=1:numel(sheets)
data_new{i}=rmmissing(data{i}(:,5:10));
end

for i=1:numel(sheets)
data{i}(:,5:10)=[];
end

for i=1:numel(sheets)
data{i}(1:20,5:10)=data_new{i}(:,1:6);
end

%% quick view of intensity correlation of TCR and Lck line scan.
for i=1:numel(sheets)
TCR_LCK_line_intensity_correlation(i)=corr(data{i}(:,2),data{i}(:,4));
scatter(data{i}(:,2),data{i}(:,4));
% lsline;
% pause(0.8)
end
plot(TCR_LCK_line_intensity_correlation,'k*')



%% segregate the TCR intensity line profile into 20 segement to prepare
% for 20 points pearon correlation. 
mean_of_20_segement=zeros(20,numel(sheets));
for i=1:numel(sheets)
vec1=data{i}(1:52,4);       
vec2=data{i}(52:103,4);
vec3=data{i}(103:154,4);
vec4=data{i}(154:205,4);
vec5=data{i}(205:256,4);
padded_new=cat(1,vec1,vec2,vec3,vec4,vec5);
temp_vec=vec2mat(padded_new,13)';
mean_of_20_segement(:,i)=mean(temp_vec);
end
% the above code is readjust the 256 pixels into 260 pixels so that
% it can be split equally into 20 part with each part contain 13 pixels.
figure 
subplot 211
plot(data{i}(:,4))
subplot 212
plot(mean_of_20_segement)

%% scatter plot of all the data, here each PC segment alone the line is considered,
% which produces 20 set of dat multiple 20 PC segment = 400 data points or single point FCS. 
TCR_int_all=mean_of_20_segement(:);
Lck_int_all=[];
Lck_con_all=[];
Lck_DC_all=[];
for i=1:numel(sheets)
    Lck_int_temp=data{i}(1:20,10);
    Lck_con_temp=data{i}(1:20,8);
    Lck_DC_temp=data{i}(1:20,6);
    Lck_int_all=cat(1,Lck_int_all,Lck_int_temp);
    Lck_con_all=cat(1,Lck_con_all,Lck_con_temp);
    Lck_DC_all=cat(1,Lck_DC_all,Lck_DC_temp);
end

subplot 321
scatter (TCR_int_all,Lck_int_all,'k.');
%lsline;
xlabel('LIC-CD3z CY2KO int','FontSize', 16);
ylabel('Lck int','FontSize', 16);
pbaspect([1 1 1]);
ax=gca;
ax.FontSize=10;

subplot 322
scatter(Lck_int_all,Lck_DC_all,'k.');
%lsline;
ylim([0 40]);
xlabel('Lck int ','FontSize', 16);
ylabel('Lck DC','FontSize', 16)
pbaspect([1 1 1]);
ax=gca;
ax.FontSize=10;

subplot 323
scatter(TCR_int_all,Lck_DC_all,'k.');
%lsline;
ylim([0 40]);
xlabel('LIC-CD3z CY2KO int','FontSize', 16)
ylabel('Lck DC','FontSize', 16)
pbaspect([1 1 1]);
ax=gca;
ax.FontSize=10;

subplot 324
%[p,s]=polyfit(Lck_int_all,Lck_con_all,1);
%[y_fit, delta]=polyval(p,Lck_int_all,s);
scatter(Lck_int_all,Lck_con_all,'k.');
%lsline;
ylim([0 100]);
%h.Color = 'b';
% hold on
% plot(Lck_int_all,y_fit+2*delta,'m:',Lck_int_all,y_fit-2*delta,'m--')
xlabel('Lck int','FontSize', 16)
ylabel('Lck con','FontSize', 16)
pbaspect([1 1 1]);
ax=gca;
ax.FontSize=10;

subplot 325
scatter(TCR_int_all,Lck_con_all,'k.');
%lsline;
ylim([0 100]);
xlabel('LIC-CD3z CY2KO int','FontSize', 16)
ylabel('Lck con','FontSize', 16)
pbaspect([1 1 1]);
ax=gca;
ax.FontSize=10;

subplot 326
scatter(Lck_con_all,Lck_DC_all,'k.');
%lsline;
ylim([0 40]);
xlabel('Lck con','FontSize', 16)
ylabel('Lck DC','FontSize', 16)
pbaspect([1 1 1]);
ax=gca;
ax.FontSize=10;


fig=gcf;
fig.WindowState='maximized';
saveas(gcf,'scatter.png');
