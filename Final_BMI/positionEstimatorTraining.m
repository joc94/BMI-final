function modelParameters = positionEstimatorTraining(trainingData)
% Template for our training function for the model
% Inputs: trainingData (trials)
% Outputs: modelParameters (Parameters of our regression model, can be anything we choose)
% ---
% Options for regression models:
% * Linear regression
% * Neural network
% * Radial basis function
% * Gaussian process

% kernel = false; 
% 
% dt = 20; 
% 
% start = 1;
% lag = 0;


% kernel = 'Gaussian'; 
% 
% dt = 1; 
% 
% start = 1;
% lag = 0;

% kernel = 'Gaussian'; 
% dt = 1; 
% start = 1;
% lag = 0;

trees = trainClassifier(trainingData);


kernel = 'Gaussian';
dt = 1;
start = 1;
lag = 20;


trainingData = cart2polar(trainingData,true);
output = fr_processing(trainingData,dt,kernel);
modelParameters = trainKalman(output,dt,lag,start);


modelParameters{9}.trees = trees;



end

