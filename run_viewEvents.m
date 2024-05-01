% Define the data types for each column
opts = detectImportOptions("24050101.TXT");
opts.VariableTypes = {'int32', 'string', 'string', 'int32'};

% Read the table with specified data types
A = readtable("24050101.TXT", opts);

% Rename the columns
A.Properties.VariableNames = {'Trial', 'Key', 'Value', 'Millis'};


% Extract and sort unique events
uniqueKeys = unique(A.Key);
sortedKeys = sort(uniqueKeys);

% Create a mapping of keys to y-axis values
keyMap = containers.Map(sortedKeys, 1:length(sortedKeys));

% Prepare x and y data for plotting
xData = A.Millis;
yData = arrayfun(@(x) keyMap(x), A.Key);

% Colors for each unique y-value
colors = parula(length(sortedKeys));

% Create the plot
clc;
close all;
figure('Position',[0 0 1400 800]);
hold on;
for i = 1:length(sortedKeys)
    % Select data for this key
    idx = A.Key == sortedKeys(i);
    scatter(xData(idx), yData(idx), 'o', 'filled', 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', 'none');
end

% Add vertical lines for "IR1" events
ir1_indices = A.Key == "IR1";
xline(A.Millis(ir1_indices), 'Color', 'w', 'LineWidth', 2);

% Grid, labels, and title
set(gca, 'YGrid', 'on', 'XGrid', 'off');
ylabel('Events');
xlabel('Millis');
yticks(1:length(sortedKeys));
yticklabels(sortedKeys);
set(gca, 'TickLabelInterpreter', 'none');

% Extract date and time from the table assuming they are provided as 'date' and 'time'
dateStr = A.Value(A.Key == "date");
timeStr = A.Value(A.Key == "time");
title(['Event Timing ' char(dateStr) ' ' char(timeStr)]);

hold off;
exportgraphics(gcf, 'Figure_EventTiming.png');