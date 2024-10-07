function y=plan3(init_conditions)
% [V; theta; x; y; delta_z; alpha; H*; mass]
%
    % 定义参数
    S_ref = 0.45;  
    g = 9.81; 
    P = 0; 
    K = 4;
    x_t=30000;
    y_t=0;

    %步长
    dt=0.01;

    % 求解
    y = zeros(8, 4116);
    y(:,1) = init_conditions;
    dydt = zeros(8, 1);
    i=1;

    while(y(4,i)>0 && sqrt((y(3,i)-x_t)^2+(y(4,i)-y_t)^2)>1 && y(1,i)>0)
        C_x = 0.2 + 0.005 * rad2deg(y(6,i))^2;
        C_y = 0.25 * rad2deg(y(6,i)) + 0.05 * rad2deg(y(5,i));
        q = dynamic_pressure(y(4,i), y(1,i));

        X = C_x * q * S_ref; 
        Y = C_y * q * S_ref; 

        dydt(1) = (P * cos(y(6,i)) ) / y(8,i) - X / y(8,i) - g * sin(y(2,i)); %V
        [~,dydt(2)] = Proportional_Guidance(y(3,i), y(4,i), x_t, y_t, y(1,i), 0, y(2,i), 0, K);%theta 
        dydt(3) = y(1,i) * cos(y(2,i)); % dx/dt
        dydt(4) = y(1,i) * sin(y(2,i)); % dy/dt
        y(6,i+1)=deg2rad((y(8,i) * y(1,i) * dydt(2)+y(8,i) * g * cos(y(2,i)))/(0.25 * q *S_ref))-0.05 * y(5,i);%alpha
        y(5,i+1)=0.1/0.024*y(6,i+1);%delta_z
        if y(5,i+1)>deg2rad(15)
            y(5,i+1) = deg2rad(15);
        elseif y(5,i+1)<-deg2rad(15)
            y(5,i+1) = -deg2rad(15);
        end
        y(1:4,i+1) = y(1:4,i) + dt*dydt(1:4); %积分
        y(8,i+1)= y(8,i) + dt*dydt(8);
        i=i+1;
    end
end

