%{
Joshua Vincent
BIOE 162 Lab
HW 3, Problems 3 & 4
%}

clear

%{
Question 3(a)
Find the characteristic polynomial, characteristic equation, characterist
roots, and characteristic modes of this system.
%}

% Write the system in D notation.
% Transfer the coefficients to the characteristic polynomial.
syms lambda;
characteristic = lambda^2 + (5*lambda) + 6 == 0

% Find the characteristic roots
coeffs = [1 5 6];
r = roots(coeffs)

% The characteristic modes are...
syms c1 c2 c3 y(t);
modes = y == (c1*exp(r(1)*t)) + (c2*exp(r(2)*t))

%{
Question 3(b)
Find the zero-input response for the system.
%}

% Using matrix operations

% Find the first and second derivatives of y.
% Set t to zero and plug in the initial conditions.
% Use matrix notation.
% 
A = [2;-1];
% X is our matrix of coefficients
X = [1 1;-2 -3];
% B is our vector of [c1;c2]
% It follows that A = X*B and X\A = B
B = X\A

% Using dsolve()

% Steady-state equation
syms y(t);
Dy = diff(y, t);
D2y = diff(y, t, 2);
eqn = (D2y + (5*Dy) + 6)*y == 0;

% Initial conditions
conds = [y(0) == 2, Dy(0) == -1];

% Solve without initial conditions
ySol(t) = dsolve(eqn)

% Solve with initial conditions
ySol(t) = dsolve(eqn, conds)

clear

%{
Question 4(a)
Find the characteristic polynomial, characteristic equation, characterist
roots, and characteristic modes of this system.
%}

% Write the system in D notation.
% Transfer the coefficients to the characteristic polynomial.
syms lambda;
characteristic = lambda^3 + (6*lambda^2) + (11*lambda) + 6 == 0

% Find the characteristic roots
coeffs = [1 6 11 6];
r = roots(coeffs)

% The characteristic modes are...
syms c1 c2 c3 y(t);
modes = y == (c1*exp(r(1)*t)) + (c2*exp(r(2)*t)) + (c3*exp(r(3)*t))

%{
Question 4(b)
Find the zero-input response for the system.
%}

% Using matrix operations

% Find the first and second derivatives of y.
% Set t to zero and plug in the initial conditions.
% Use matrix notation.
% 
A = [2;-1;5];
% X is our matrix of coefficients
X = [1 1 1;-3 -2 -1;9 4 1];
% B is our vector of [c1;c2;c3]
% It follows that A = X*B and X\A = B
B = X\A

% Using dsolve()

% Steady-state equation
syms y(t);
Dy = diff(y, t);
D2y = diff(y, t, 2);
D3y = diff(y, t, 3);
eqn = (D3y + (6*D2y) + (11*Dy) + 6)*y == 0;

% Initial conditions
conds = [y(0) == 2, Dy(0) == -1, D2y(0) == 5];

% Solve without initial conditions
ySol(t) = dsolve(eqn)

% Solve with initial conditions
ySol(t) = dsolve(eqn, conds)