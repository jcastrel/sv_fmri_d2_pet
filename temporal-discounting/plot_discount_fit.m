% PLOT_DISCOUNTING_FIT       
% 
%     plot_discount_fit(choice,vS,vL,d,info);
%
%     Some plots for discounting model fits.
%       Top panel is data grouped by magnitude of the longer option
%       Middle panel is data grouped by delay of the longer option
%       Bottom panel is the inferred discount function
%
%     INPUTS
%     choice - The data should be *ungrouped*, such that CHOICE is a column of 
%              0s and 1s, where 1 indicates a choice of the shorter option.
%     vS     - shorter values
%     vL     - longer values
%     d      - delays (for longer option)
%     info   - Struct array from FIT_DISCOUNTING_MODEL
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

%optional loop through all subjects
%for i = 1:length(results); plot_discount_fit(data(i).choice,data(i).vS,data(i).vL,data(i).d,results(i)); end



function plot_discount_fit(choice,vS,vL,d,info);

c = repmat(['r' 'b' 'g' 'k' 'm' 'c' 'y'],1,10);
s = repmat(['s' 'o' 'v' '^' 'p' 'd'],1,10);
l = repmat({'-' ':' '--' '-.' '-' ':'},1,10); 
ms = 12;
lw = 2;
jitterSD = 0.1;

[pmat,udel,umag] = average_data(choice,d,vL);

% Plot choice data along with the model fits (sort by magnitude)
figure; 
subplot(311); hold on
t = (.9*min(udel):1.1*max(udel))';
for i = 1:length(umag)
   for j = 1:length(info)
      temp = choice_prob_discount(vS(1)*ones(size(t)),umag(i)*ones(size(t)),t,info(j).b,info(j).model);
      plot(t,temp,[c(i) l{j}],'linewidth',lw);
   end
end
for i = 1:length(umag)
   plot(udel+jitterSD*rand(size(udel)),pmat(:,i),[c(i) s(i)],'markersize',ms,'markerfacecolor',c(i));
end
ylabel('Prob(Immediate)');
xlabel('Time');
set(gca,'tickdir','out')
axis([t(1) t(end) 0 1]);

% Plot choice data along with the model fits  (sort by delay)
subplot(312); hold on
m = (.9*min(umag):1.1*max(umag))';
for i = 1:length(udel)
   for j = 1:length(info)
      temp = choice_prob_discount(vS(1)*ones(size(m)),m,udel(i)*ones(size(m)),info(j).b,info(j).model);
      plot(m,temp,[c(i) l{j}],'linewidth',lw);
   end
end
for i = 1:length(udel)
   plot(umag+jitterSD*rand(size(umag)),pmat(i,:),[c(i) s(i)],'markersize',ms,'markerfacecolor',c(i));
end
ylabel('Prob(Immediate)');
xlabel('Magnitude');
set(gca,'tickdir','out')
axis([m(1) m(end) 0 1]);
%legend(udel(i));

% Plot inferred discount functions
subplot(313); hold on
for i = 1:length(info)
   plot(t,discount(ones(size(t)),t,info(i).b(2:end),info(i).model),['k' l{i}],'linewidth',lw);
end
%title('Inferred Discount Function');
ylabel('Discounted value');
xlabel('Time');
set(gca,'tickdir','out')
%axis([t(1) t(end) 0 1]);
axis tight;
for i = 1:length(info)
   str{i} = info(i).model;
end
legend(str);