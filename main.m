y1 = plan1([300; 0; 0; 7000; 0; 0 ;7000; 300]);
y2 = plan2(y1(:,end));
plot(y2(3,:),y2(4,:));