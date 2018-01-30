
pos1 = [ 0 5 5 ];
numinterpolatoins = 9;


pos_1_linkcoeff_1 = [0 5, 0, 0, 0, pos1(1)];
pos_1_linkcoeff_2 = [0 5, 0, 0, 0, pos1(2)];
pos_1_linkcoeff_3 = [0 5, 0, 0, 0, pos1(3)];
desiredpos = gentraj_fullrobot(pos_1_linkcoeff_1,... 
    pos_1_linkcoeff_2,pos_1_linkcoeff_3, numinterpolatoins);

pos2 = [ 7 8 -3 ];
i = numinterpolatoins + 2;
j = i + numinterpolatoins ;

pos_2_linkcoeff_1 = [0 5, 0, 0, pos1(1), pos2(1)];
pos_2_linkcoeff_2 = [0 5, 0, 0, pos1(2), pos2(2)];
pos_2_linkcoeff_3 = [0 5, 0, 0, pos1(3), pos2(3)];
desiredpos(i:j,:) = gentraj_fullrobot(pos_2_linkcoeff_1,... 
    pos_2_linkcoeff_2,pos_2_linkcoeff_3, numinterpolatoins);


pos3 = [ 0 0 0 ];
i = j +1;
j = i + numinterpolatoins ;

pos_3_linkcoeff_1 = [0 5, 0, 0, pos2(1), pos3(1)];
pos_3_linkcoeff_2 = [0 5, 0, 0, pos2(2), pos3(2)];
pos_3_linkcoeff_3 = [0 5, 0, 0, pos2(3), pos3(3)];
desiredpos(i:j,:) = gentraj_fullrobot(pos_3_linkcoeff_1,... 
    pos_3_linkcoeff_2,pos_3_linkcoeff_3, numinterpolatoins);
disp(desiredpos);