%5.4

function it = fractal(c, maxIter)


    if nargin < 2, maxIter = 100; end

    z  = zeros(size(c), 'like', c);       
    it = zeros(size(c), 'uint16');      
    mask = true(size(c));                

    for k = 1:maxIter
        z(mask) = z(mask).^2 + c(mask);   % iterate only active points
        escaped = mask & (abs(z) > 2);    
        it(escaped) = k;
        mask = mask & ~escaped;           % keep only non-escaped
        if ~any(mask, 'all'), break; end  % all points decided
    end

    it(mask) = maxIter;                   % didn't escape within cap
end

% Single point:
it = fractal(0.3 + 0.5i);

[x,y] = meshgrid(linspace(-2.5,1,800), linspace(-1.5,1.5,600));
I = fractal(x + 1i*y, 100);
imshow(I, [], 'XData',[min(x(:)) max(x(:))], 'YData',[min(y(:)) max(y(:))]); axis on; axis xy;


%Bisection Method
function fn = indicator_fn_at_x(x)
    % returns an indicator function along a vertical line at a given x
    % it uses equivalence of logical variables (true - 1, false - 0) 
    % to produce a value of 1 for divergence and -1 for no divergence

    maxIter = 100;                 % fixed cap per assignment
    fn = @(y) (fractal(x + 1i*y, maxIter) < maxIter) * 2 - 1;
end

function m = bisection(fn_f, s, e, tol, maxIter)
    if nargin < 4, tol = 1e-7; end
    if nargin < 5, maxIter = 200; end

    fs = fn_f(s); fe = fn_f(e);
    if fs == 0, m = s; return; end
    if fe == 0, m = e; return; end
    if sign(fs) * sign(fe) >= 0
        error('bisection:badBracket', ...
              'Need fn_f(s)<0 and fn_f(e)>0 (sign change).');
    end

    for k = 1:maxIter
        m  = 0.5*(s+e);
        fm = fn_f(m);
        if fm == 0 || 0.5*(e-s) < tol
            return
        end
        if sign(fs) * sign(fm) < 0
            e = m; fe = fm;
        else
            s = m; fs = fm;
        end
    end
end
   
% indicator for a vertical line at x = -0.75
fn = indicator_fn_at_x(-0.75);

% bracket: y=0 is inside; y=1.5 is outside
s = 0.0; e = 1.5;
if sign(fn(s)) < 0 && sign(fn(e)) > 0
    yb = bisection(fn, s, e);     
    fprintf('Boundary at x=-0.75 is y≈ %.6f\n', yb);
else
    disp('Bracket does not straddle the boundary at this x.');
end


%7 Polynomial function fitting

xs = linspace(-2, 1, 1501);
ys = NaN(size(xs));

s = 0.0;     % inside (y=0 is inside for most columns)
e = 1.5;     % outside (above the set)
tol = 1e-7;

for i = 1:numel(xs)
    fn = indicator_fn_at_x(xs(i));  % +1 outside, -1 inside
    if sign(fn(s)) < 0 && sign(fn(e)) > 0
        ys(i) = bisection(fn, s, e, tol);
    end
end

%2) keepboundary points
mask = ~isnan(ys);


xwin = [-1.6, 0.4];             
mask = mask & xs >= xwin(1) & xs <= xwin(2);

xdata = xs(mask);
ydata = ys(mask);

%plot
figure; plot(xs, ys, '.','MarkerSize',6); hold on;
plot(xdata, ydata, 'r.'); grid on; axis tight;
xlabel('x'); ylabel('y (upper boundary)');
title('Mandelbrot boundary samples (red = windowed)');

% 3) fit degree-15 polynomial (center)
order = 15;
[p, ~, mu] = polyfit(xdata, ydata, order);   % mu = [mean, std]

% 4) evaluate
xf = linspace(min(xdata), max(xdata), 2000);
yf = polyval(p, xf, [], mu);

figure; 
plot(xdata, ydata, 'k.', 'DisplayName', 'Boundary data'); hold on;
plot(xf, yf, 'r-', 'LineWidth', 1.25, 'DisplayName', 'Degree-15 fit');
grid on; axis tight;
xlabel('x'); ylabel('y'); 
title(sprintf('Polynomial fit of order %d to boundary', order));
legend('Location','best');

%8 Boundary Length
function L = poly_len(p, s, e, mu)
%   L = poly_len(p, s, e)             
%   L = poly_len(p, s, e, mu)          % when [p,~,mu] = polyfit(...)
%
% Inputs
%   p  : polynomial coefficients (highest degree first)
%   s,e: interval in x (with s < e) — keep within the fitted x-range
%   mu : optional [mean, std] from polyfit for centered/scaled x
% Output
%   L  : arc length

    if nargin < 4, mu = []; end
    if ~(isscalar(s) && isscalar(e) && s < e)
        error('poly_len:badInterval','Require scalars with s < e.');
    end

    dp = polyder(p);

    if isempty(mu)        
        dydx = @(x) polyval(dp, x);
    else                
        m = mu(1); sc = mu(2);
        dydx = @(x) (1/sc) .* polyval(dp, (x - m)./sc);
    end

    integrand = @(x) sqrt(1 + (dydx(x)).^2);

    L = integral(integrand, s, e, 'RelTol',1e-9, 'AbsTol',1e-12);
end

s = min(xdata); e = max(xdata);           % stay within  window
L = poly_len(p, s, e, mu);
fprintf('Arc length on [%g,%g] = %.6f\n', s, e, L);