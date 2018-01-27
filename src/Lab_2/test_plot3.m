% test plot3
clear all; close all; clc

figure;

t = 0;%:0.010:0.135;
st = 0:1:10;
ct = (0*t);

l = 1:0.1:5;
%x1 = st(10*pi) + l;
y1 = 2*l;
z1 = 0.5*l;

plot3(st,ct,t)
%plot3(l,y1,z1)
axis on, grid on, hold on, axis equal
xlabel("X-axis");
ylabel("Y-axis");
zlabel("Z-axis");

x = [0 2 3];
y = [0 10 15];
z = [0 4 6];

p1 = [ x(1); y(1); z(1) ];
p2 = [ x(2); y(2); z(2) ];
p3 = [ x(3); y(3); z(3) ];

% p1 = [ x(1,1) y(1,1) z(1,1) ];
% p2 = [ x(2,2) y(2,2) z(2,2) ];
% p3 = [ x(3,3) y(3,3) z(3,3) ];

% plot3(x, y, z);
% plot3(0, 0, 0, x(3), y(3), z(3));



drawnow;