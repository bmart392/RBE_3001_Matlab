function [ outarr ] = choose_mn2xy( m , n )

%   +-------Robot-------+   Robot_Interface
%   |                   |
%   |    Zone 0         |
%   |    W = 27; H = 8  |
%   |                   |
%   +------- 290 -------+   Interface_A
%   |                   |
%   |    Zone 5         |
%   |    W = 21; H = 2  |
%   |                   |
%   +------- 325 -------+   Interface_E
%   |                   |
%   |     Zone 10       |
%   | W = 25; H = -18   |
%   |                   |
%   +------- 350 -------+   Interface_I
%   |                   |
%   |      Zone 15      |
%   |   W = 21; H = 55  |
%   |                   |
%   +------- 360 -------+   Interface_K
%   |                   |
%   |      Zone 17      |
%   |   W = 21; H = 35  |
%   |                   |
%   +------- 372 -------+   Interface_M
%   |                   |
%   |       Zone 20     |
%   |   W = 17; H = 18  |
%   |                   |
%   +------- 390 -------+   Interface_Q
%   |                   |
%   |      Zone 25      |
%   |   W = 17; H = 14  |
%   |                   |
%   +------- 410 -------+   Interface_U
%   |                   |
%   |     Zone 30       |
%   |   W = 17; H =12   |
%   |                   |
%   +---- Camera -------+ Interface_Camera



Zone_0_total_width = 27;
Zone_0_total_height = 8;

Interface_A = 290;


Zone_5_total_width = 21;
Zone_5_total_height = 2;


Interface_E = 325;

Zone_10_total_width = 25;
Zone_10_total_height = -18;

Interface_I = 350;

Zone_15_total_width = 21;
Zone_15_total_height = 55;

Interface_K = 360;

Zone_17_total_width = 21;
Zone_17_total_height = 35;


Interface_M = 372;

Zone_20_total_width = 17;
Zone_20_total_height = 18;

Interface_Q = 390;


Zone_25_total_width = 17;
Zone_25_total_height = 14;

Interface_U = 410;

Zone_30_total_width = 17;
Zone_30_total_height = 11;


if n < Interface_A
    
    outarr = mn2xy( m, n, Zone_0_total_width, Zone_0_total_height);
    
elseif (Interface_A <= n && n < Interface_E) 
    
    outarr = mn2xy( m, n, Zone_5_total_width, Zone_5_total_height);
    
elseif (Interface_E <= n && n < Interface_I)     
    
    outarr = mn2xy( m, n, Zone_10_total_width, Zone_10_total_height);
    
elseif (Interface_I <= n && n < Interface_K) 

    outarr = mn2xy( m, n, Zone_15_total_width, Zone_15_total_height);
    
elseif (Interface_K <= n && n < Interface_M) 

    outarr = mn2xy( m, n, Zone_17_total_width, Zone_17_total_height);
    
elseif (Interface_M <= n && n < Interface_Q)
    
    outarr = mn2xy( m, n, Zone_20_total_width, Zone_20_total_height);
    
elseif (Interface_Q <= n && n < Interface_U)   
    
    outarr = mn2xy( m, n, Zone_25_total_width, Zone_25_total_height);
    
elseif n >= Interface_U 
    
    outarr = mn2xy( m, n, Zone_30_total_width, Zone_30_total_height);
    
end

end

