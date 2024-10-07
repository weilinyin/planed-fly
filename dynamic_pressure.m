function q = dynamic_pressure(height, velocity)
    %动压计算，输入高度(m)，速度(m/s)，输出密度(kg/m^3)

    rho_0 = 1.2495;
    T_0 = 288.15;
    T = T_0 - 0.0065*height;
    rho = rho_0 * (T/T_0)^4.25588;
    q = 0.5 * rho * velocity^2;
end