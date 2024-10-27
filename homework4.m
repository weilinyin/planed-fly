v=185.231075114139;
theta=0.000564642825192501;
x=13541.3219351809;
y=3044.81769902494;
delta_z=0.261799387799149;
alpha=0.0628318530717959;
m=288.444800000045;
J_z=350;%初始状态

S_ref = 0.45;
g = 9.81; 
P = 2000;
C_x = 0.2 + 0.005 * rad2deg(alpha^2);
C_y = 0.25 * rad2deg(alpha) + 0.05 * rad2deg(delta_z);
a_11 = (-2*dynamic_pressure(y,v)/v*C_x*S_ref);
a_13 = -g*cos(theta);
a_14 = -(P*alpha+dynamic_pressure(y,v)*S_ref*0.01*rad2deg(alpha)*180/pi)/m;

a_21 = 0;
a_22 = -2/J_z;
a_24 = -0.1*180/pi/J_z;
a_25 = 0.024*180/pi/J_z;
a1_24 = 0;
a1_25 = 0;
a_31 = (-2*dynamic_pressure(y,v)/v*C_y*S_ref);
a_33 = g*sin(theta)/v;
a_34 = (P+dynamic_pressure(y,v)*S_ref*0.25*180/pi)/(m*v);
a_35 = (dynamic_pressure(y,v)*S_ref*0.05*180/pi)/(m*v);

A_Z =[-a_11, 0, -a_14+a_13, -a_13;
      -a_21-a1_24*a_31, -a_22-a1_24, a1_24*a_34+a1_24*a_33-a_24, -a1_24*a_33;
      a_31, 0, -a_34-a_33, a_33;
      0, 1, 0, 0];
b=[0, -a_25+a1_24*a_35, -a_35, 0]';
d=0;
[W_1a,W_1b] = ss2tf(A_Z, b, [0,1,0,0],d);
[W_2a,W_2b] = ss2tf(A_Z, b, [0,0,1,0],d);
[W_3a,W_3b] = ss2tf(A_Z, b, [0,0,0,1],d);
W_1 = tf(W_1a,W_1b);
W_2 = tf(W_2a,W_2b);
W_3 = tf(W_3a,W_3b);

A = A_Z(2:end,2:end);
b1= b(2:end);
[W_1a,W_1b] = ss2tf(A, b1, [1,0,0],d);
[W_2a,W_2b] = ss2tf(A, b1, [0,1,0],d);
[W_3a,W_3b] = ss2tf(A, b1, [0,0,1],d);
W_4 = tf(W_1a,W_1b);
W_5 = tf(W_2a,W_2b);
W_6 = tf(W_3a,W_3b);
bode(W_1,W_2,W_3,W_4,W_5,W_6);