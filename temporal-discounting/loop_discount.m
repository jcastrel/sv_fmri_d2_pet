function [data,results] = loop_discount
    
    % Load data from two-armed discount task.
    %
    % USAGE: data = load_discount_data
    %
    % OUTPUTS:
    %   data - [S x 1] structure, where S is the number of subjects, with the following fields:
    %           .vS - value of the smaller-sooner option
    %           .vL - value of the larger-later option
    %           .d - delay between options
    %           .choice - choice made (1 = SS, 0 = LL)
    %           .C - number of choice options
    %           .N - number of trials
    %
    % Jaime Castrellon, 2017
    
    
D = csvread('/Volumes/CASTRELLON/selfreg/selfreg_ddisc_2015.csv',1);
subs = unique(D(:,1));      % subjects
    for i = 1:length(subs)
        ix = D(:,1)==subs(i);
        data(i).vS = D(ix,2);
        data(i).vL = D(ix,3);
        data(i).d = D(ix,4);
        data(i).choice = D(ix,5);        
        data(i).C = length(unique(data(i).choice));
        data(i).N = length(data(i).choice);
         % data for current subject
         vS = data(i).vS;            % value of smaller-sooner reward
         vL = data(i).vL;            % value of larger-later reward
         d = data(i).d;              % delay   
         choice = data(i).choice;    % choice
         results(i) = fit_discount_model(choice,vS,vL,d,'hyp');
    end
    
for i = 1:length(results);
    results(i).SV_chosen_transpose = transpose(results(i).SV_chosen); 
    results(i).SV_unchosen_transpose = transpose(results(i).SV_unchosen); 
end    
    
concat_SV_chosen = vertcat(results.SV_chosen_transpose);    
concat_SV_unchosen = vertcat(results.SV_unchosen_transpose);
end
    
