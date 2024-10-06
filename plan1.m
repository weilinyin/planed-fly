
    % 定义参数
    k_H = -1; % 示例值
    k_dot_H = 1; % 示例值
    S_ref = 0.45; 
    m = 300; 
    g = 9.81; 
    P = 2000; 
    
    %初始条件
    init_conditions = [300; 0; 0; 7000; 0; 0 ;7000]; % [V; theta; x; y; delta_z; alpha; H*]

    %步长
    dt=1;
    %时长
    ts=100;

    % 求解
    y = zeros(7, 100/ts);
    y(:,1) = init_conditions;
    dydt = zeros(7, 1);
    for i=2:ts/dt

        C_x = 0.2 + 0.005 * rad2deg(y(6))^2;
        C_y = 0.25 * rad2deg(y(6)) + 0.05 * rad2deg(y(5));
        q = dynamic_pressure(y(4), y(1));

        X = C_x * q * S_ref; 
        Y = C_y * q * S_ref; 

        dydt(1) = (P * cos(y(6)) ) / m - X / m - g * sin(y(2)); %V
        dydt(2) = (P * sin(y(6)) + Y - m * g * cos(y(2)-y(6))) / (m * y(1)); %theta 
        dydt(3) = y(1) * cos(y(2)); % dx/dt
        dydt(4) = y(1) * sin(y(2)); % dy/dt
        y(5) = k_H * (y(7) - y(4)) + k_dot_H * (dydt(7) - dydt(4)); %delta_z
        dydt(6) = 0.24 * y(5); %alpha
        dydt(7) = 2000 * cos(0.000314 * 1.1 * y(3)) + 5000; %H*
        y(:,i) = y(:,i-1) + dt*dydt; %积分
    end
    % 结果可视化
    figure;
    plot(y(3, :), y(4, :)); % xy图
    xlabel('X (m)');
    ylabel('Y (m)');
    title('X vs Y');


