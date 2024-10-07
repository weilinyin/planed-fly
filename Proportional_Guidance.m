function  [q,dthetadt]=Proportional_Guidance(x_m,y_m,x_t,y_t,v_m,v_t,theta_m,theta_t,K)
    %比例导引法
    %输入[导弹x坐标，导弹y坐标，目标x坐标，目标y坐标，导弹速度，目标速度，导弹theta，目标theta，导航比]
    %输出[视角q，dq/dt，dtheta/dt]
    r=sqrt((x_m-x_t)^2+(y_m-y_t)^2);
    q=atan((y_t-y_m)/(x_t-x_m));
    eta_m=q-theta_m;
    eta_t=q-theta_t;
    dqdt=(v_m*sin(eta_m)-v_t*sin(eta_t))/r;
    dthetadt=K * dqdt;
end