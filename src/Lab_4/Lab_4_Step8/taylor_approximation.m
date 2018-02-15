function qd = taylor_approximation( q0, pd, threshold )

% iterating/current angles
qi = q0;

all_joint_positions_q0 =  forward_kinematics_rad(qi);
    
qi_xyz = all_joint_positions_q0(4,:)';


case1 = (pd(1)-qi_xyz(1)) >= threshold(1) ...
    || (pd(1)-qi_xyz(1)) <= -threshold(1);

case3 = (pd(3)-qi_xyz(3)) >= threshold(3) ...
    || (pd(3)-qi_xyz(3)) <= -threshold(3);


while (case1 || case3)
    qi = inverse_kin_jacobs2(pd, qi);
    
    all_joint_positions_qi =  forward_kinematics_rad(qi);
    qi_xyz = all_joint_positions_qi(4,:)';
    
    case1 = (pd(1)-qi_xyz(1)) >= threshold(1) ...
        || (pd(1)-qi_xyz(1)) <= -threshold(1);
    case3 = (pd(3)-qi_xyz(3)) >= threshold(3) ...
        || (pd(3)-qi_xyz(3)) <= -threshold(3);    
end

qd = qi;


end

