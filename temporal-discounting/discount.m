% DISCOUNT                   Discount value
% 
%     y = discount(v,d,beta,model);
%
%     INPUTS
%     v     - values
%     d     - delays
%     model - String indicating which model to fit. Currently valid are:
%               'exp'       - exponential
%               'hyp'       - Mazur's one-parameter hyperbolic
%               'genhyp'    - two-parameter hyperbolic
%               'betadelta' - Laibson's beta-delta model
%
%     OUTPUTS
%     y     - discounted values
%
%     EXAMPLES
%     To generate a discount function for a model fit by FIT_DISCOUNT_MODEL:
%     >> t = (0:100)';
%     >> discount(ones(size(t)),t,info(i).b(2:end),info(i).model);

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

function y = discount(v,d,beta,model);

if strcmp(model,'exp') % exponential 
   y = v.*exp(-beta(1)*d);
elseif strcmp(model,'hyp') % hyperbolic 
   y = v./(1+beta(1)*d);
elseif strcmp(model,'genhyp') % generalized hyperbolic
   y = v./(1+beta(1)*d).^(beta(2)/beta(1));
elseif strcmp(model,'betadelta') % Beta-delta
   y = v;
   ind = d~=0;
   y(ind) = (beta(1)*beta(2).^d(ind)) .* v(ind);
end
