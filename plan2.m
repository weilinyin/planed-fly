function y=plan2(init_conditions)
% [V; theta; x; y; delta_z; alpha; H*; mass]
%
    % 定义参数
    k_H = 1; % 示例值
    k_dot_H = -10; % 示例值
    S_ref = 0.45; 
    g = 9.81; 
    P = 2000; 
    

    %步长
    dt=0.01;

    % 求解
    y = zeros(8, 8026);
    y(:,1) = init_conditions;
    dydt = zeros(8, 1);
    i=1;
    while(y(3,i)<24000 && y(1,i)>0)
        C_x = 0.2 + 0.005 * rad2deg(y(6,i))^2;
        C_y = 0.25 * rad2deg(y(6,i)) + 0.05 * rad2deg(y(5,i));
        q = dynamic_pressure(y(4,i), y(1,i));

        X = C_x * q * S_ref; 
        Y = C_y * q * S_ref; 

        dydt(1) = (P * cos(y(6,i)) ) / y(8,i) - X / y(8,i) - g * sin(y(2,i)); %V
        dydt(2) = (P * sin(y(6,i)) + Y - y(8,i) * g * cos(y(2,i)-y(6,i))) / (y(8,i) * y(1,i)); %theta 
        dydt(3) = y(1,i) * cos(y(2,i)); % dx/dt
        dydt(4) = y(1,i) * sin(y(2,i)); % dy/dt
        y(7,i+1) = 3050; %H*
        y(5,i+1) = k_H * (y(7,i) - y(4,i)) + k_dot_H * dydt(4) ; %delta_z
        dydt(8) = -0.46;
        if y(5,i+1)>deg2rad(15)
            y(5,i+1) = deg2rad(15);
        elseif y(5,i+1)<-deg2rad(15)
            y(5,i+1) = -deg2rad(15);
        end
        y(6,i+1) = 0.24 * y(5,i); %alpha
        y(1:4,i+1) = y(1:4,i) + dt*dydt(1:4); %积分
        y(8,i+1)= y(8,i) + dt*dydt(8);
        i=i+1;
    end
end

