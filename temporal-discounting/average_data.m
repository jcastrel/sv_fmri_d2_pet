% AVERAGE_DATA               Group binary data
% 
%     [pmat,udel,umag] = average_data(choice,d,vL);
%
%     Build a matrix of averages choice per delay & magnitude.
%
%     INPUTS
%     choice - The data should be *ungrouped*, such that CHOICE is a column of 
%              0s and 1s, where 1 indicates a choice of the shorter option.
%     d      - delays
%     vL     - values for *DELAYED* option
%
%     OUTPUTS
%     pmat   - choice probabilities for the *SHORTER* option formatted as a
%              #delays X #values matrix. NaNs are inserted where there was
%              no data
%     udel   - vector unique delays
%     umag   - vector of unique values
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
% 

function [pmat,udel,umag] = average_data(choice,d,vL);

udel =  unique(d); % unique delays
ndel = length(udel);
umag =  unique(vL); % unique magnitudes
nmag = length(umag);
pmat = NaN*zeros(ndel,nmag);
for i = 1:ndel
   for j = 1:nmag
      ind = (d==udel(i)) & (vL==umag(j));
      if sum(ind) > 0
         pmat(i,j) = sum(choice(ind))/sum(ind);
      end
   end
end
