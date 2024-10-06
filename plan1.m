function plan1
    % 定义参数
    k_H = 1; % 示例值
    k_dot_H = 1; % 示例值
    S_ref = 1; % 示例值
    m = 1000; % 质量示例值
    g = 9.81; % 重力加速度
    P = 100; % 推力示例值
    
    % 时间范围
    tspan = [0 10]; % 0到10秒
    init_conditions = [0; 0; 0; 0; 0; 0]; % [V; theta; x; y; delta_z; alpha]

    % ODE求解
    [t, sol] = ode45(@(t, y) odefun(t, y, k_H, k_dot_H, S_ref, m, g, P), tspan, init_conditions);

    % 结果可视化
    figure;
    plot(t, sol(:, 1)); % 画速度
    xlabel('Time (s)');
    ylabel('Velocity (V)');
    title('Velocity vs Time');
end

function dydt = odefun(t, y, k_H, k_dot_H, S_ref, m, g, P)
    H_star = 2000 * cos(0.000314 * 1.1 * y(5)) + 5000;
    delta_z = k_H * (H_star - y(5)) + k_dot_H * (0 - y(5)); % 这里需要实际的 \dot{H} 值
    C_x = 0.2 + 0.005 * y(6)^2;
    C_y = 0.25 * y(6) + 0.05 * delta_z;

    X = C_x * 1 * S_ref; % q 值在这里假设为1
    Y = C_y * 1 * S_ref; % q 值在这里假设为1

    dydt = zeros(6, 1);
    dydt(1) = (P * cos(y(6)) * cos(0)) / m - X / m - g * sin(0); % theta 假设为0
    dydt(2) = (P * sin(y(6)) + Y - m * g * cos(0)) / (m * y(1)); % theta 假设为0
    dydt(3) = y(1) * cos(y(2)); % dx/dt
    dydt(4) = y(1) * sin(y(2)); % dy/dt
    dydt(5) = delta_z; % delta_z的变化率
    dydt(6) = - (y(5) / 1); % alpha的变化率，假设 m_z^delta_z 和 m_z^alpha 为1
end
