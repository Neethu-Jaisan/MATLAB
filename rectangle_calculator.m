% Rectangle Area and Perimeter Calculator
% This program calculates the area and perimeter of a rectangle
% given its length and width.

% Define the length and width of the rectangle
length = 5;  % in units
width = 3;   % in units

% Calculate the area
area = length * width;

% Calculate the perimeter
perimeter = 2 * (length + width);

% Display the results
fprintf('For a rectangle with length %.2f units and width %.2f units:\n', length, width);
fprintf('Area = %.2f square units\n', area);
fprintf('Perimeter = %.2f units\n', perimeter);
