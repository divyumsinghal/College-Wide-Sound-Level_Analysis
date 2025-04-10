% Read and preprocess
M = readmatrix('data/FormatedData_Gates.csv','Range','A2:FW151');
N = readmatrix('data/FormatedData_Cafes.csv','Range','A2:FW151');

% Calculate time-of-day averages
Arts_Morning_Avg = (M(:,4) + M(:,19) + M(:,34) + M(:,49)) / 4;
Arts_Afternoon_Avg = (M(:,9) + M(:,24) + M(:,39) + M(:,54)) / 4;
Arts_Evening_Avg = (M(:,14) + M(:,29) + M(:,44) + M(:,59)) / 4;

Front_Morning_Avg = (M(:,64) + M(:,79) + M(:,94) + M(:,109)) / 4;
Front_Afternoon_Avg = (M(:,69) + M(:,84) + M(:,99) + M(:,114)) / 4;
Front_Evening_Avg = (M(:,74) + M(:,89) + M(:,104) + M(:,119)) / 4;

Sports_Morning_Avg = (M(:,124) + M(:,139) + M(:,154) + M(:,169)) / 4;
Sports_Afternoon_Avg = (M(:,129) + M(:,144) + M(:,159) + M(:,174)) / 4;
Sports_Evening_Avg = (M(:,134) + M(:,149) + M(:,164) + M(:,179)) / 4;

Pav_Morning_Avg = (N(:,4) + N(:,19) + N(:,34) + N(:,49)) / 4;
Pav_Afternoon_Avg = (N(:,9) + N(:,24) + N(:,39) + N(:,54)) / 4;
Pav_Evening_Avg = (N(:,14) + N(:,29) + N(:,44) + N(:,59)) / 4;

Buttery_Morning_Avg = (N(:,64) + N(:,79) + N(:,94) + N(:,109)) / 4;
Buttery_Afternoon_Avg = (N(:,69) + N(:,84) + N(:,99) + N(:,114)) / 4;
Buttery_Evening_Avg = (N(:,74) + N(:,89) + N(:,104) + N(:,119)) / 4;

Dining_Morning_Avg = (N(:,124) + N(:,139) + N(:,154) + N(:,169)) / 4;
Dining_Afternoon_Avg = (N(:,129) + N(:,144) + N(:,159) + N(:,174)) / 4;
Dining_Evening_Avg = (N(:,134) + N(:,149) + N(:,164) + N(:,179)) / 4;

% Consolidate by location
Arts_All = [Arts_Morning_Avg; Arts_Afternoon_Avg; Arts_Evening_Avg];
Front_All = [Front_Morning_Avg; Front_Afternoon_Avg; Front_Evening_Avg];
Sports_All = [Sports_Morning_Avg; Sports_Afternoon_Avg; Sports_Evening_Avg];

Gates_All = [Arts_All; Front_All; Sports_All];

Pav_All = [Pav_Morning_Avg; Pav_Afternoon_Avg; Pav_Evening_Avg];
Buttery_All = [Buttery_Morning_Avg; Buttery_Afternoon_Avg; Buttery_Evening_Avg];
Dining_All = [Dining_Morning_Avg; Dining_Afternoon_Avg; Dining_Evening_Avg];

Cafes_All = [Pav_All; Buttery_All; Dining_All];


locations = {
    'Gates', Gates_All;
    'Cafes', Cafes_All;
    'Arts', Arts_All;
    'Front', Front_All;
    'Sports', Sports_All;
    'Pav', Pav_All;
    'Buttery', Buttery_All;
    'Dining', Dining_All
};

distributions = {'Lognormal', 'Weibull', 'Exponential', 'Normal', 'Gamma', 'Logistic'};

% A nexted JSON of form
% {
%     "Arts": {
%         "Mean": mean_value,
%         "Std": std_value,
%         "Distributions": {
%             "Lognormal": {
%                 "Params": [param1, param2],
%                 "Chi2Stat": Chi2Stat_value,
%                 "PValue": p_value
%             },
%             "Weibull": {
%                 "Params": [param1, param2],
%                 "Chi2Stat": Chi2Stat_value,
%                 "PValue": p_value
%             },
%             ...
%         }
%     },
%     "Front": {
%         ...
%     },
%     "Sports": {
%         ...
%     }
% }
stats = struct();

% Loop over each location and fit distributions
for i = 1:size(locations, 1)
    loc_name = locations{i, 1};
    data = locations{i, 2};

    % Remove any NaN values and ensure positive data (sound levels)
    data = data(~isnan(data) & data > 0);

    % Basic statistics
    stats.(loc_name).Mean = mean(data);
    stats.(loc_name).Std = std(data);

    % Create figure for visualization
    figure('Name', loc_name);
    [hist_counts, edges] = histcounts(data, 'Normalization', 'pdf');
    bin_centers = (edges(1:end-1) + edges(2:end))/2;
    bar(bin_centers, hist_counts, 1, 'FaceColor', [1 1 0], 'BarWidth', 1, 'DisplayName', 'Observed Sound Level');
    hold on;

    % X values for plotting PDFs
    x = linspace(min(data), max(data), 100);

    % Fit distributions and store results
    for j = 1:length(distributions)
        dist_name = distributions{j};

        % Fit distribution
        pd = fitdist(data, dist_name);

        % Store parameters
        stats.(loc_name).Distributions.(dist_name).Params = pd.ParameterValues;

        % Calculate expected frequencies
        % expected_pdf = pdf(pd, bin_centers);
        % expected_freq = expected_pdf * sum(hist_counts) * diff(edges(1:2));

        % Perform Chi-squared test
        % observed = hist_counts * sum(hist_counts) * diff(edges(1:2)); % Convert to counts
        [~, p_value, chi2_stat] = chi2gof(data, 'Edges', edges, ...
            'CDF', @(x) cdf(pd, x), 'NParams', numel(pd.ParameterValues));

        % Store Chi-squared test results
        stats.(loc_name).Distributions.(dist_name).Chi2Stat = chi2_stat;
        stats.(loc_name).Distributions.(dist_name).PValue = p_value;

        % Plot fitted distribution
        y = pdf(pd, x);
        plot(x, y, 'LineWidth', 2, 'DisplayName', dist_name);


    end

    % Figure formatting
    title(['Distribution Fits for ' loc_name]);
    xlabel('Value');
    ylabel('Probability Density');
    legend('show');
    grid on;
    hold off;

    % Save the figure
    saveas(gcf, ['probability_distributions/' loc_name '.png']);
end

jsonText = jsonencode(stats);
fid = fopen(['probability_distributions/stats_output.json'], 'w');
fwrite(fid, jsonText, 'char');
fclose(fid);
