% Read and preprocess
M = readmatrix('data/FormatedData_Gates.xlsx','Range','A2:FW151');

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

% Consolidate by location
Arts_All = [Arts_Morning_Avg; Arts_Afternoon_Avg; Arts_Evening_Avg];
Front_All = [Front_Morning_Avg; Front_Afternoon_Avg; Front_Evening_Avg];
Sports_All = [Sports_Morning_Avg; Sports_Afternoon_Avg; Sports_Evening_Avg];

locations = {'Arts', Arts_All; 'Front', Front_All; 'Sports', Sports_All};
distributions = {'Lognormal', 'Weibull', 'Exponential', 'Normal', 'Gamma', 'Logistic', 'Kernel'};

% A nexted json of form
% {
%     "Arts": {
%         "Mean": mean_value,
%         "Std": std_value,
%         "Distributions": {
%             "Lognormal": {
%                 "Params": [param1, param2],
%                 "AIC": aic_value
%             },
%             "Weibull": {
%                 "Params": [param1, param2],
%                 "AIC": aic_value
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
stats = {};

% Loop over each location and fit distributions
for i = 1:size(locations, 1)
    loc_name = locations{i, 1};
    data = locations{i, 2};

    % store the location name, mean and std
    mean_value = mean(data);
    std_value = std(data);

    % Store stats for the location
    stats.(loc_name).Mean = mean_value;
    stats.(loc_name).Std = std_value;

    % Fit distributions to the data
    for j = 1:length(distributions)
        dist_name = distributions{j};

        params = fitdist(data, dist_name);


    end
end
