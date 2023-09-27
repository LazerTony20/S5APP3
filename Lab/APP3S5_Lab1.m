clc
close all
clear

%% Probleme 1
load DonneesIdentifSyst1erOrdre_1.mat
% load ./DonneesIdentifSyst1erOrdre/DonneesIdentifSyst1erOrdre_2.mat


% Vu que mon numerateur de ma forme d'ordre 1 est de 0 + 1 (ordre 1, je regarde juste le premierniveau de xentree)
% Pour mon denumerateur, je garde ordre 1 car je prends l'ordre de mon
% denominateur comme niveau de conservation
Xentree1 = u;
Xsortie1 = -diff(y)./diff(t);
Ymat = y(1:end-1);

Xmat = [Xentree1(1:end-1) Xsortie1];

A1 = Xmat\Ymat;
K1 = A1(1);
T1 = A1(2);

disp('La valeur de K est : ')
disp(K1)
disp('La valeur de T est : ')
disp(T1)

figure('Name','Graph Ordre 1')
plot(t,y)
grid on

%% Probleme 2
num1 = [2 6.4];
den1 = [1 8];
num2 = [25];
den2 = [1 14.8 61.7 47 25];
num3 = [3];
den3 = [1 3];

tf1 = tf(num1,den1);
tf2 = tf(num2,den2);
tf3 = tf(num3,den3);

tf123 = series(tf1,series(tf2,tf3));

figure('Name','Pôles-Zeros')
%Plus proche de l'axe des img, plus le poids est elevé
pzmap(tf123)

%(B) Réduire le modèle
[numtot, dentot] = tfdata(tf123, 'v');
[Residues1, Poles, K2] = residue(numtot,dentot);  
poids = abs(Residues1)./real(Poles);
%selon le output de mon poids, je prends les 5e et 6e
%on recrée la fonction mais en gardant juste le plus important
[num4,den4] = residue(Residues1(5:6),Poles(5:6),K2);
tf4 = tf(num4,den4);

Ktf123 = dcgain(tf123);
Ktf4 = dcgain(tf4);
Kn = Ktf123/Ktf4;

figure('Name','Lab1 Prob 2')
hold on
stepplot(tf123)
stepplot(Kn*tf4)
hold off
grid on

%% Probleme 3
t3 = [0:0.01:25]';
u3 = zeros(size(t3));
u3((t3 >= 0) &(t3 < 2)) = 2;
u3((t3 >= 2)) = 0.5;

num6 = [1 2];
den6 = [1 1 0.25];
tf6 = tf(num6,den6);

[A,B,C,D] = tf2ss(num6,den6);
Ymat2 = lsim(tf6,u3,t3);

figure('Name','Probleme 3')
plot(t3,Ymat2)
grid on;

%% Probleme 5
A5 = [-2 -2.5 -0.5;
    1 0 0;
    0 1 0];
B5 = [1; 0; 0];
C5 = [0 1.5 1];
D5 = [0];

SYS7 = ss(A5,B5,C5,D5);

x07 = [1 0 2]';
t7 = [0:0.01:25]';
u7((t7 >= 0) &(t7 < 2)) = 2;
u7((t7 >= 2)) = 0.5;

[Y7,T7,X7] = lsim(SYS7,u7,t7,x07);

figure('Name','Probleme 5')
plot(T7,X7)
legend('x1(t)','x2(t)','x3(t)')
grid on

SYS2 = ss(A5,B5,C5,D5);
X08 = [0 0 0];
[Y8,T8,X8] = lsim(SYS2,u7,t7,X08);

figure('Name','Probleme 5 CI = 0')
plot(T8,X8)
legend('x1(t)','x2(t)','x3(t)')
grid on
