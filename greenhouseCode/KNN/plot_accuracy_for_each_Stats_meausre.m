% title("ON Events")
% title("OFF Events")
% title("ON/OFF Events")
% title("Number of Events") 
% title("Events Duration") 
% title("X Mean")
% title("Y Mean") 
% title("X Stdv")
% title("Y Stdv")

figure(2);

% ONEventC
subplot(3,3,1)
results = [87.7659574468085;83.5106382978724;84.0425531914894;82.9787234042553;85.6382978723404;80.8510638297872;82.4468085106383;77.6595744680851;82.9787234042553;81.9148936170213;77.1276595744681;81.9148936170213;80.8510638297872;78.7234042553192;77.6595744680851;80.8510638297872;75.5319148936170;75.5319148936170;70.7446808510638;70.7446808510638;72.3404255319149;71.2765957446809;73.4042553191489;70.7446808510638;69.6808510638298]';
% results = results*100;
bar(results); hold on
yl = yline(100/3,'--','Chance 33.33 %','fontsize',11,'LineWidth',3);
yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
% yline(50);
str={'k=1','k=3','k=5','k=7','k=9','k=11','k=13','k=15','k=17','k=19','k=21','k=23','k=25'...
    ,'k=27','k=29','k=31','k=33','k=35','k=37','k=39','k=41','k=43','k=45','k=47','k=49'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',10, 'YGrid', 'on', 'XGrid', 'off')
xlabel("K value");
ylabel("Accuracy (% Correct)");
title("ON Events")
xtickangle(45)
xlim([0 35])
ylim([0 110])

% OFF Events
subplot(3,3,2)
results = [56.3829787234043;51.0638297872340;51.0638297872340;51.0638297872340;50.5319148936170;50.5319148936170;52.1276595744681;50.5319148936170;50;50;50.5319148936170;49.4680851063830;49.4680851063830;49.4680851063830;50;50;50.5319148936170;50;49.4680851063830;49.4680851063830;50;50;49.4680851063830;49.4680851063830;50]';
% results = results*100;
bar(results); hold on
yl = yline(100/3,'--','Chance 33.33 %','fontsize',11,'LineWidth',3);yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
% yline(50);
str={'k=1','k=3','k=5','k=7','k=9','k=11','k=13','k=15','k=17','k=19','k=21','k=23','k=25'...
    ,'k=27','k=29','k=31','k=33','k=35','k=37','k=39','k=41','k=43','k=45','k=47','k=49'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',8, 'YGrid', 'on', 'XGrid', 'off')
xlabel("K value");
ylabel("Accuracy (% Correct)");
title("OFF Events")
xtickangle(45)
xlim([0 35])
ylim([0 110])

% ONOFFRatioC 
subplot(3,3,3)
results = [99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830]';
results = results*100;
bar(results); hold on
yl = yline(100/3,'--','Chance 33.33 %','fontsize',11,'LineWidth',3);yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
% yline(50);
str={'k=1','k=3','k=5','k=7','k=9','k=11','k=13','k=15','k=17','k=19','k=21','k=23','k=25'...
    ,'k=27','k=29','k=31','k=33','k=35','k=37','k=39','k=41','k=43','k=45','k=47','k=49'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',8, 'YGrid', 'on', 'XGrid', 'off')
xlabel("K value");
ylabel("Accuracy (% Correct)");
title("ON/OFF Ratio")
xtickangle(45)
xlim([0 35])
ylim([0 110])

% TotalEventC 
subplot(3,3,4)
results = [52.1276595744681;49.4680851063830;50;49.4680851063830;49.4680851063830;50;49.4680851063830;48.9361702127660;48.9361702127660;49.4680851063830;49.4680851063830;48.9361702127660;49.4680851063830;49.4680851063830;49.4680851063830;48.9361702127660;48.9361702127660;48.9361702127660;50;49.4680851063830;49.4680851063830;49.4680851063830;50;50.5319148936170;49.4680851063830]';
% results = results*100;
bar(results); hold on
yl = yline(100/3,'--','Chance 33.33 %','fontsize',11,'LineWidth',3);yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
% yline(50);
str={'k=1','k=3','k=5','k=7','k=9','k=11','k=13','k=15','k=17','k=19','k=21','k=23','k=25'...
    ,'k=27','k=29','k=31','k=33','k=35','k=37','k=39','k=41','k=43','k=45','k=47','k=49'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',8, 'YGrid', 'on', 'XGrid', 'off')
xlabel("K value");
ylabel("Accuracy (% Correct)");
title("Number of Events")
xtickangle(45)
xlim([0 35])
ylim([0 110])

% DurationC 
subplot(3,3,5)
results = [96.2765957446809;96.8085106382979;95.7446808510638;96.2765957446809;96.2765957446809;96.8085106382979;97.3404255319149;97.3404255319149;97.3404255319149;96.8085106382979;97.3404255319149;97.8723404255319;97.8723404255319;97.3404255319149;97.3404255319149;97.8723404255319;97.3404255319149;97.8723404255319;97.3404255319149;97.3404255319149;97.3404255319149;96.8085106382979;97.3404255319149;97.3404255319149;96.8085106382979]';
% results = results*100;
bar(results); hold on
yl = yline(100/3,'--','Chance 33.33 %','fontsize',11,'LineWidth',3);yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
% yline(50);
str={'k=1','k=3','k=5','k=7','k=9','k=11','k=13','k=15','k=17','k=19','k=21','k=23','k=25'...
    ,'k=27','k=29','k=31','k=33','k=35','k=37','k=39','k=41','k=43','k=45','k=47','k=49'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',8, 'YGrid', 'on', 'XGrid', 'off')
xlabel("K value");
ylabel("Accuracy (% Correct)");
title("Events Duration")
xtickangle(45)
xlim([0 35])
ylim([0 110])

% XmeanC
subplot(3,3,6)
results = [96.8085106382979;96.8085106382979;96.2765957446809;96.8085106382979;97.3404255319149;97.8723404255319;97.8723404255319;98.4042553191489;98.4042553191489;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660]';
% results = results*100;
bar(results); hold on
yl = yline(100/3,'--','Chance 33.33 %','fontsize',11,'LineWidth',3);yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
% yline(50);
str={'k=1','k=3','k=5','k=7','k=9','k=11','k=13','k=15','k=17','k=19','k=21','k=23','k=25'...
    ,'k=27','k=29','k=31','k=33','k=35','k=37','k=39','k=41','k=43','k=45','k=47','k=49'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',8, 'YGrid', 'on', 'XGrid', 'off')
xlabel("K value");
ylabel("Accuracy (% Correct)");
title("X Mean")
xtickangle(45)
xlim([0 35])
ylim([0 110])

% YmeanC
subplot(3,3,7)
results = [98.9361702127660;99.4680851063830;98.9361702127660;97.8723404255319;98.9361702127660;98.4042553191489;98.9361702127660;98.4042553191489;98.9361702127660;98.4042553191489;100;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830]';
% results = results*100;
bar(results); hold on
yl = yline(100/3,'--','Chance 33.33 %','fontsize',11,'LineWidth',3);yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
% yline(50);
str={'k=1','k=3','k=5','k=7','k=9','k=11','k=13','k=15','k=17','k=19','k=21','k=23','k=25'...
    ,'k=27','k=29','k=31','k=33','k=35','k=37','k=39','k=41','k=43','k=45','k=47','k=49'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',8, 'YGrid', 'on', 'XGrid', 'off')
xlabel("K value");
ylabel("Accuracy (% Correct)");
title("Y Mean")
xtickangle(45)
xlim([0 35])
ylim([0 110])

% XstdvC
subplot(3,3,8)
results = [99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830;99.4680851063830]';
% results = results*100;
bar(results); hold on
yl = yline(100/3,'--','Chance 33.33 %','fontsize',11,'LineWidth',3);yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
% yline(50);
str={'k=1','k=3','k=5','k=7','k=9','k=11','k=13','k=15','k=17','k=19','k=21','k=23','k=25'...
    ,'k=27','k=29','k=31','k=33','k=35','k=37','k=39','k=41','k=43','k=45','k=47','k=49'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',8, 'YGrid', 'on', 'XGrid', 'off')
xlabel("K value");
ylabel("Accuracy (% Correct)");
title("X Stdv")
xtickangle(45)
xlim([0 35])
ylim([0 110])

% YstdvC
subplot(3,3,9)
results = [96.8085106382979;97.3404255319149;96.8085106382979;97.3404255319149;97.8723404255319;97.8723404255319;98.4042553191489;98.4042553191489;98.4042553191489;98.4042553191489;98.4042553191489;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660;98.9361702127660]';
% results = results*100;
bar(results); hold on
yl = yline(100/3,'--','Chance 33.33 %','fontsize',11,'LineWidth',3);yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
% yline(50);
str={'k=1','k=3','k=5','k=7','k=9','k=11','k=13','k=15','k=17','k=19','k=21','k=23','k=25'...
    ,'k=27','k=29','k=31','k=33','k=35','k=37','k=39','k=41','k=43','k=45','k=47','k=49'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',8, 'YGrid', 'on', 'XGrid', 'off')
xlabel("K value");
ylabel("Accuracy (% Correct)");
title("Y Stdv")
xtickangle(45)
xlim([0 35])
ylim([0 110])