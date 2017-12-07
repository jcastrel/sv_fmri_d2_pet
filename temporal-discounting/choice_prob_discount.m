% CHOICE_PROB                Binary logit choice probability
% 
%     p = choice_prob_discount(vS,vL,d,beta,model);
%
%     INPUTS
%     vS    - values for immediate option
%     vL    - values for delayed option
%     d     - vector of delays
%     beta  - Parameters corresponding to MODEL
%     model - String indicating which model to fit; currently valid are:
%               'exp'       - exponential
%               'hyp'       - Mazur's one-parameter hyperbolic
%               'genhyp'    - two-parameter hyperbolic
%               'betadelta' - Laibson's beta-delta model
%
%     OUTPUTS
%     p     - choice probabilities for the *SHORTER* option
%

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
%     brian 03.14.06 written

function p = choice_prob_discount(vS,vL,d,beta,model);

uS = discount(vS,0,beta(2:end),model);
uL = discount(vL,d,beta(2:end),model);
p = 1 ./ (1 + exp(beta(1)*(uL-uS)));
