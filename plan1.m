
    % 定义参数
    k_H = 15; % 示例值
    k_dot_H = 1; % 示例值
    S_ref = 0.45; 
    m = 300; 
    g = 9.81; 
    P = 0; 
    
    %初始条件
    init_conditions = [300; 0; 0; 7000; 0; 0 ;7000]; 
                    % [V; theta; x; y; delta_z; alpha; H*]

    %步长
    dt=0.1;
    %时长
    ts=10;

    % 求解
    y = zeros(7, ts/dt);
    y(:,1) = init_conditions;
    dydt = zeros(7, 1);
    i=1;
    while(y(3,i)<9100 && y(1,i)>0)
        C_x = 0.2 + 0.005 * rad2deg(y(6,i))^2;
        C_y = 0.25 * rad2deg(y(6,i)) + 0.05 * rad2deg(y(5,i));
        q = dynamic_pressure(y(4,i), y(1,i));

        X = C_x * q * S_ref; 
        Y = C_y * q * S_ref; 

        dydt(1) = (P * cos(y(6,i)) ) / m - X / m - g * sin(y(2,i)); %V
        dydt(2) = (P * sin(y(6,i)) + Y - m * g * cos(y(2,i)-y(6,i))) / (m * y(1,i)); %theta 
        dydt(3) = y(1,i) * cos(y(2,i)); % dx/dt
        dydt(4) = y(1,i) * sin(y(2,i)); % dy/dt
        y(5,i+1) = k_H * (y(7,i) - y(4,i)) ; %delta_z
        if y(5,i+1)>deg2rad(15)
            y(5,i+1) = deg2rad(15);
        elseif y(5,i+1)<deg2rad(15)
            y(5,i+1) = -deg2rad(15);
        end
        y(6,i+1) = 0.24 * y(5,i); %alpha
        y(7,i+1) = 2000 * cos(0.000314 * 1.1 * y(3,i)) + 5000; %H*
        y(1:4,i+1) = y(1:4,i) + dt*dydt(1:4); %积分
        i=i+1;
    end
    % 结果可视化
    figure;
    plot(y(3, :), y(4, :)); % xy图
    xlabel('X (m)');
    ylabel('Y (m)');
    title('X vs Y');


