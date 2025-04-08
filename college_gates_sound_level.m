M = readmatrix('data/FormatedData_Gates.xlsx','Range','A2:FW151');

Arts_Morning_Avg = (M(:,4) + M(:,19) + M(:,34) + M(:,49)) / 4;
Arts_Afternoon_Avg = (M(:,9) + M(:,24) + M(:,39) + M(:,54)) / 4;
Arts_Evening_Avg = (M(:,14) + M(:,29) + M(:,44) + M(:,59)) / 4;

Front_Morning_Avg = (M(:,64) + M(:,79) + M(:,94) + M(:,109)) / 4;
Front_Afternoon_Avg = (M(:,69) + M(:,84) + M(:,99) + M(:,114)) / 4;
Front_Evening_Avg = (M(:,74) + M(:,89) + M(:,104) + M(:,119)) / 4;

Sports_Morning_Avg = (M(:,124) + M(:,139) + M(:,154) + M(:,169)) / 4;
Sports_Afternoon_Avg = (M(:,129) + M(:,144) + M(:,159) + M(:,174)) / 4;
Sports_Evening_Avg = (M(:,134) + M(:,149) + M(:,164) + M(:,179)) / 4;

datasets = {
    'Arts Morning', Arts_Morning_Avg;
    'Arts Afternoon', Arts_Afternoon_Avg;
    'Arts Evening', Arts_Evening_Avg;
    'Front Morning', Front_Morning_Avg;
    'Front Afternoon', Front_Afternoon_Avg;
    'Front Evening', Front_Evening_Avg;
    'Sports Morning', Sports_Morning_Avg;
    'Sports Afternoon', Sports_Afternoon_Avg;
    'Sports Evening', Sports_Evening_Avg;
};

central_tendencies_table = cell(length(datasets), 11);
central_tendencies_table(1,:) = {
    'Dataset', ...
    'Mean (dB)', ...
    'Median (dB)', ...
    'Standard Deviation (dB)', ...
    'Variance (dB)', ...
    '1st Quartile (dB)', ...
    '3rd Quartile (dB)', ...
    'Min (dB)' , ...
    'Max (dB)' , ...
    '5% Trimmed Mean (dB)', ...
    '20% Trimmed Mean (dB)'
};


figure('Name', 'Line Plots for All Datasets');

for i = 1:length(datasets)
    data_label = datasets{i,1};
    data = datasets{i,2};

    subplot(3, 3, i);
    x = linspace(0, 750, length(data));

    plot(x, data, '-o');
    title(['Sound Level vs Time for ', data_label]);
    xlabel('Time averaged over 5s interval (s)');
    ylabel('Sound Level (dB)');
    legend(data_label, 'Location', 'best');
    grid on;
end

saveas(gcf, 'stats/Line_Plots_All_Datasets.png');

figure('Name', 'Histograms for All Datasets');

for i = 1:length(datasets)
    data_label = datasets{i,1};
    data = datasets{i,2};

    subplot(3, 3, i);
    histogram(data, 'Normalization', 'probability');

    title(['Histogram of ', data_label]);
    xlabel('Sound Level (dB)');
    ylabel('Probability');
    grid on;
end

saveas(gcf, 'stats/Histograms_All_Datasets.png');

figure('Name', 'Overlay Plot for All Datasets');

colors = lines(length(datasets));

hold on;
for i = 1:length(datasets)
    data_label = datasets{i,1};
    data = datasets{i,2};
    x = linspace(0, 750, length(data));

    plot(x, data, 'Color', colors(i, :), 'LineWidth', 1.5, 'DisplayName', data_label);
end

title('Overlay Plot of All Sound Level Datasets');
xlabel('Time averaged over 5s interval (s)');
ylabel('Sound Level (dB)');
legend('Location', 'bestoutside');
grid on;

saveas(gcf, 'stats/Overlay_Plot_All_Datasets.png');
hold off;

colors = lines(3);

figure('Name', 'Line Plots for Arts, Sports, Front');
subplot(3, 1, 1);
plot(linspace(0, 750, length(Arts_Morning_Avg)), Arts_Morning_Avg, 'Color', colors(1,:), 'DisplayName', 'Morning');
hold on;
plot(linspace(0, 750, length(Arts_Afternoon_Avg)), Arts_Afternoon_Avg, 'Color', colors(2,:), 'DisplayName', 'Afternoon');
plot(linspace(0, 750, length(Arts_Evening_Avg)), Arts_Evening_Avg, 'Color', colors(3,:), 'DisplayName', 'Evening');
title('Arts');
xlabel('Time (s)');
ylabel('Sound Level (dB)');
legend;
hold off;

subplot(3, 1, 2);
plot(linspace(0, 750, length(Sports_Morning_Avg)), Sports_Morning_Avg, 'Color', colors(1,:), 'DisplayName', 'Morning');
hold on;
plot(linspace(0, 750, length(Sports_Afternoon_Avg)), Sports_Afternoon_Avg, 'Color', colors(2,:), 'DisplayName', 'Afternoon');
plot(linspace(0, 750, length(Sports_Evening_Avg)), Sports_Evening_Avg, 'Color', colors(3,:), 'DisplayName', 'Evening');
title('Sports');
xlabel('Time (s)');
ylabel('Sound Level (dB)');
legend;
hold off;

subplot(3, 1, 3);
plot(linspace(0, 750, length(Front_Morning_Avg)), Front_Morning_Avg, 'Color', colors(1,:), 'DisplayName', 'Morning');
hold on;
plot(linspace(0, 750, length(Front_Afternoon_Avg)), Front_Afternoon_Avg, 'Color', colors(2,:), 'DisplayName', 'Afternoon');
plot(linspace(0, 750, length(Front_Evening_Avg)), Front_Evening_Avg, 'Color', colors(3,:), 'DisplayName', 'Evening');
title('Front');
xlabel('Time (s)');
ylabel('Sound Level (dB)');
legend;
hold off;

saveas(gcf, 'stats/Line_Plots_Location.png');


figure('Name', 'Line Plots for Morning, Afternoon, Evening');
subplot(3, 1, 1);
plot(linspace(0, 750, length(Arts_Morning_Avg)), Arts_Morning_Avg, 'Color', colors(1,:), 'DisplayName', 'Arts');
hold on;
plot(linspace(0, 750, length(Sports_Morning_Avg)), Sports_Morning_Avg, 'Color', colors(2,:), 'DisplayName', 'Sports');
plot(linspace(0, 750, length(Front_Morning_Avg)), Front_Morning_Avg, 'Color', colors(3,:), 'DisplayName', 'Front');
title('Morning');
xlabel('Time (s)');
ylabel('Sound Level (dB)');
legend;
hold off;

subplot(3, 1, 2);
plot(linspace(0, 750, length(Arts_Afternoon_Avg)), Arts_Afternoon_Avg, 'Color', colors(1,:), 'DisplayName', 'Arts');
hold on;
plot(linspace(0, 750, length(Sports_Afternoon_Avg)), Sports_Afternoon_Avg, 'Color', colors(2,:), 'DisplayName', 'Sports');
plot(linspace(0, 750, length(Front_Afternoon_Avg)), Front_Afternoon_Avg, 'Color', colors(3,:), 'DisplayName', 'Front');
title('Afternoon');
xlabel('Time (s)');
ylabel('Sound Level (dB)');
legend;
hold off;

subplot(3, 1, 3);
plot(linspace(0, 750, length(Arts_Evening_Avg)), Arts_Evening_Avg, 'Color', colors(1,:), 'DisplayName', 'Arts');
hold on;
plot(linspace(0, 750, length(Sports_Evening_Avg)), Sports_Evening_Avg, 'Color', colors(2,:), 'DisplayName', 'Sports');
plot(linspace(0, 750, length(Front_Evening_Avg)), Front_Evening_Avg, 'Color', colors(3,:), 'DisplayName', 'Front');
title('Evening');
xlabel('Time (s)');
ylabel('Sound Level (dB)');
legend;
hold off;

saveas(gcf, 'stats/Line_Plots_Time.png');

for i = 1:length(datasets)
    data_label = datasets{i,1};
    data = datasets{i,2};

    mean_val = mean(data);
    median_val = median(data);
    std_dev = std(data);
    variance_val = var(data);

    q1 = quantile(data, 0.25);
    q3 = quantile(data, 0.75);

    trimmed_mean_5 = trimmean(data, 5);
    trimmed_mean_20 = trimmean(data, 20);

    min_d = min(data);
    max_d = max(data);

    central_tendencies_table{i+1, 1} = data_label;
    central_tendencies_table{i+1, 2} = mean_val;
    central_tendencies_table{i+1, 3} = median_val;
    central_tendencies_table{i+1, 4} = std_dev;
    central_tendencies_table{i+1, 5} = variance_val;
    central_tendencies_table{i+1, 6} = q1;
    central_tendencies_table{i+1, 7} = q3;
    central_tendencies_table{i+1, 8} = min_d;
    central_tendencies_table{i+1, 9} = max_d;
    central_tendencies_table{i+1, 10} = trimmed_mean_5;
    central_tendencies_table{i+1, 11} = trimmed_mean_20;
end

central_tendencies_table = cell2table(central_tendencies_table(2:end,:), ...
    'VariableNames', central_tendencies_table(1,:));

disp('Central Tendencies Table:');
disp(central_tendencies_table);

writetable(central_tendencies_table, 'stats/Central_Tendencies.csv');
disp('Central tendencies saved as Central_Tendencies.csv');
