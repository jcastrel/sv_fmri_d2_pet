% Set up some delays and magnitudes for fake data
nreps = 100; % # repeats per condition
%udel = linspace(0,24,10); % unique delays (longer option)
%umag = linspace(110,300,10); % unique magnitudes (longer option)
udel = linspace(0,24,6); % unique delays (longer option)
umag = linspace(110,350,6); % unique magnitudes (longer option)

[d,vL] = meshgrid(udel,umag);
d = repmat(d(:),nreps,1);
vL = repmat(vL(:),nreps,1);

nobs = length(d);
vS = 100*ones(nobs,1); % assume a fixed shorter magnitude

% Generate underlying choice probabilities
%true_model = [.11 .036]; % first parameter is logistic slope, the rest are for the discount function
%p = choice_prob(vS,vL,d,true_model,'hyp'); 
true_model = [.11 .8 .96]; % first parameter is logistic slope, the rest are for the discount function
p = choice_prob_discount(vS,vL,d,true_model,'betadelta'); 

% Simulate choice data for the above model
choice = zeros(size(p));
for i = 1:length(p)
   if rand<=p(i)
      choice(i) = 1;
   end
end

% Fit three discounting models
info = fit_discount_model(choice,vS,vL,d,{'exp' 'hyp' 'betadelta'});

% Plot the results
plot_discount_fit(choice,vS,vL,d,info);

% On average the parameters should be right
true_model
info(2).b'

% On average the correct model should win
disp('The smallest AIC or BIC is the best model, and on average should select the column matching the true model\n');
[info.AIC]
[info.BIC]