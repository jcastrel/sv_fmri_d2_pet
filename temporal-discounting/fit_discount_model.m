% FIT_DISCOUNTING_MODEL      Fit a variety of probabilistic discounting models
% 
%     [info,p] = fit_discount_model(choice,vS,vL,d,model);
%
%     Fits a binary logit modelchoi by maximum likelihood.
%
%     INPUTS
%     choice      - Dependent variable. The data should be *ungrouped*,
%                   such that CHOICE is a column of 0s and 1s, where 1 indicates 
%                   a choice of the shorter option.
%     vS          - values for immediate option
%     vL          - values for delayed option
%     d           - vector of delays
%     model       - String indicating which model to fit; currently valid are:
%                     'exp'       - exponential
%                     'hyp'       - Mazur's one-parameter hyperbolic
%                     'genhyp'    - two-parameter hyperbolic
%                     'betadelta' - Laibson's beta-delta model
%                   Multiple models can be fit by passing in a cell array
%                   of strings. 
%
%     OUTPUTS
%     info       - data structure with following fields:
%                     .nobs      - number of observations
%                     .nb        - number of parameters
%                     .optimizer - function minimizer used
%                     .exitflag  - see FMINSEARCH
%                     .b         - fitted parameters; note that for all the
%                                  available models, the first element of B
%                                  is a noise term for the logistic
%                                  function, the remaining elements are
%                                  parameters for the selected discount
%                                  functions. eg., for model='exp', B(2) is
%                                  the time constant of the exponential
%                                  decay.
%                     .LL        - log-likelihood evaluated at maximum
%                     .LL0       - restricted (minimal model) log-likelihood
%                     .AIC       - Akaike's Information Criterion 
%                     .BIC       - Schwartz's Bayesian Information Criterion 
%                     .r2        - pseudo r-squared
%                   This is a struct array if multiple models are fit.
%     p           - Estimated choice probabilities evaluated at the values
%                   delays specified by the inputs vS, vL, dS, dL. This is
%                   a cell array if multiple models are fit.
%
%     EXAMPLES
%     see TEST_FAKE_DATA

%     $ Copyright (C) 2011 Brian Lau http://www.subcortex.net/ $
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%     REVISION HISTORY:
%     brian 03.10.06 written
%     brian 03.14.06 added fallback to FMINSEARCH, multiple fit capability

function [info,p] = fit_discount_model(choice,vS,vL,d,model);

% If multiple model fits requested, loop and pack
if iscell(model)
   for i = 1:length(model)
      [info(i),p{i}] = fit_discount_model(choice,vS,vL,d,model{i});
   end
   return;
end

nobs = length(choice);

% Initialize parameters (this could be smarter)
if strcmp(model,'genhyp')
   b0 = [.1 0.01 0.01]';
elseif strcmp(model,'betadelta')
   b0 = [.1 0.5 0.975]';
else
   b0 = [.1 0.01]';
end

% Fit model, attempting to use FMINUNC first, then falling back to FMINSEARCH
if exist('fminunc','file')
   try
      optimizer = 'fminunc';
      OPTIONS = optimset('Display','off','LargeScale','off');
      [b,negLL,exitflag,convg,g,H] = fminunc(@local_negLL,b0,OPTIONS,choice,vS,vL,d,model);
      if exitflag ~= 1 % trap occasional linesearch failures
         optimizer = 'fminsearch';
         fprintf('FMINUNC failed to converge, switching to FMINSEARCH\n');
      end         
   catch
      optimizer = 'fminsearch';
      fprintf('Problem using FMINUNC, switching to FMINSEARCH\n');
   end
else
   optimizer = 'fminsearch';
end

if strcmp(optimizer,'fminsearch')
   optimizer = 'fminsearch';
   OPTIONS = optimset('Display','off','TolCon',1e-6,'TolFun',1e-5,'TolX',1e-5,...
      'DiffMinChange',1e-4,'Maxiter',1000,'MaxFunEvals',2000);
   [b,negLL,exitflag,convg] = fminsearch(@local_negLL,b0,OPTIONS,choice,vS,vL,d,model);
end

if exitflag ~= 1
   fprintf('Optimization FAILED, #iterations = %g\n',convg.iterations);
else
   fprintf('Optimization CONVERGED, #iterations = %g\n',convg.iterations);
end

% Choice probabilities (for SHORTER)
p = choice_prob_discount(vS,vL,d,b,model);

% Unrestricted log-likelihood
LL = -negLL;
% Restricted log-likelihood
LL0 = sum((choice==1).*log(0.5) + (1 - (choice==1)).*log(0.5));

info.nobs = nobs;
info.nb = length(b);
info.model = model;
info.optimizer = optimizer;
info.exitflag = exitflag;
info.b = b;
info.LL = LL;
info.LL0 = LL0;
info.AIC = -2*LL + 2*length(b);
info.BIC = -2*LL + length(b)*log(nobs);
info.r2 = 1 - LL/LL0;
info.p = p;
info.invtemp = b(1);
info.k = b(2);

%Calculate SV of each option (uS/uL) and chosen option (SV)
info.uS = discount(vS,0,b(2),model);
info.uL = discount(vL,d,b(2),model);
for i = 1:length(choice)
      if choice(i) == 1
          info.SV_chosen(i) = info.uL(i);
          info.SV_unchosen(i) = info.uS(i);
      else
           info.SV_chosen(i) = info.uS(i);
           info.SV_unchosen(i) = info.uL(i);
      end
      info.SV_diff(i) = info.SV_chosen(i) - info.SV_unchosen(i);
end
%----- LOCAL FUNCTIONS
function sumerr = local_negLL(beta,choice,vS,vL,d,model);

p = choice_prob_discount(vS,vL,d,beta,model);

% Trap log(0)
ind = p == 1;
p(ind) = 0.9999;
ind = p == 0;
p(ind) = 0.0001;
% Log-likelihood
err = (choice==1).*log(p) + (1 - (choice==1)).*log(1-p);
% Sum of -log-likelihood
sumerr = -sum(err);
