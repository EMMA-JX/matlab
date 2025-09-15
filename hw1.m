function montecarlo_pi_for_loop_version(N)
    % N: total number of points

    tic;                      % start timer
    inside = 0;               % counter for points inside quarter circle
    pi_est = zeros(N,1);      % an N-by-1 column vector of zeros (used to preallocate space).
                                % store running estimate
    err    = zeros(N,1);      % store deviation from true pi

    for k = 1:N
        x = rand;             % pseudorandom number from the uniform distribution on (0,1).
        y = rand;             
        if x^2 + y^2 <= 1
            inside = inside + 1;
        end
        pi_est(k) = 4 * inside / k;
        err(k)    = abs(pi - pi_est(k));
    end
    elapsed = toc;            % stop timer

    %---- Plot running estimate and error ----
    figure;
    subplot(2,1,1)
    plot(1:N, pi_est, 'b'); hold on
    yline(pi,'r--','True \pi');
    xlabel('Number of Points'); ylabel('\pi Estimate');
    title('Monte Carlo \pi Estimate (for-loop)');

    subplot(2,1,2)
    plot(1:N, err, 'k');
    xlabel('Number of Points'); ylabel('Absolute Error');

    fprintf('Final estimate: %.6f\n', pi_est(end));
    fprintf('Absolute error: %.6f\n', err(end));
    fprintf('Elapsed time : %.4f seconds\n', elapsed);
end

montecarlo_pi_for_loop_version(50);   %Enter the number of random points here



function [pi_est, n, hist] = montecarlo_pi_while(sigfigs, alpha)
% Monte Carlo π with a while loop and CI-based stopping (no true pi used)
    if nargin < 2, alpha = 0.05; end
    z = norminv(1 - alpha/2);          % z-score
    tol = 0.5 * 10^(1 - sigfigs);      % absolute tolerance for s sig figs

    % initialize
    n = 0;
    hits = 0;
    batch = 1000;                       % draw in batches for speed
    hist.n = [];
    hist.pi = [];
    hist.halfwidth = [];

    tic
    halfwidth = inf;

    while halfwidth > tol
        % draw a batch of points
        x = rand(batch,1);
        y = rand(batch,1);
        hits = hits + sum(x.^2 + y.^2 <= 1);   % quarter-circle test
        n = n + batch;

        p_hat = hits / n;
        pi_est = 4 * p_hat;

        % standard error & CI half-width (normal approx)
        se = 4 * sqrt(max(p_hat*(1-p_hat), eps) / n);
        halfwidth = z * se;

        % record history for optional plots
        hist.n(end+1) = n;
        hist.pi(end+1) = pi_est;
        hist.halfwidth(end+1) = halfwidth;
    end

    elapsed = toc;
    fprintf('Sig figs target : %d (tol=%.6g)\n', sigfigs, tol);
    fprintf('Confidence level: %.1f%%\n', 100*(1-alpha));
    fprintf('n used          : %d\n', n);
    fprintf('π estimate      : %.10f\n', pi_est);
    fprintf('95%% half-width  : %.6g\n', halfwidth);
    fprintf('Elapsed time    : %.3f s\n', elapsed);

end

[pi2, n2, h2] = montecarlo_pi_while(2);    % target 2 significant figures
[pi3, n3]    = montecarlo_pi_while(3);     % target 3 significant figures


%  PART 3
function [pi_est, n] = mc_pi_sigfig(sigfigs, alpha, batch, maxN)
% Monte Carlo pi with CI-based stopping (no true pi used).

    % validation
    if nargin < 2 || isempty(alpha), alpha = 0.05; end
    if nargin < 3 || isempty(batch), batch = 1000; end
    if nargin < 4 || isempty(maxN),  maxN  = 1e8;  end
    sigfigs = max(1, floor(sigfigs));   
    batch   = max(1, floor(batch));

    % target
    tol = 0.5 * 10^(1 - sigfigs);     
    z   = sqrt(2) * erfinv(1 - alpha);

    % graph
    figure('Name','Monte Carlo \pi (while-loop)','Color','w');
    clf reset; hold on; axis equal; axis([0 1 0 1]); box on
    xlabel('x'); ylabel('y'); title('Estimating \pi via Monte Carlo');
    %boundary
    th = linspace(0, pi/2, 400);
    plot(cos(th), sin(th), 'k-', 'LineWidth', 1.25);

    % animated point streams
    hIn  = animatedline('Marker','.', 'LineStyle','none', ...
                        'Color',[0 0.4470 0.7410], ...  
                        'MaximumNumPoints',5e4, ...
                        'MarkerSize',3);
    hOut = animatedline('Marker','.', 'LineStyle','none', ...
                        'Color',[0.8500 0.3250 0.0980], ... 
                        'MaximumNumPoints',5e4, ...
                        'MarkerSize',3);
    legend({'Quarter circle','Inside','Outside'}, 'Location','southoutside');

    % how many points per batch to actually draw
    plotQuota = min(2000, batch);

    %counters 
    n = 0; hits = 0; pi_est = NaN; halfwidth = inf;
    t0 = tic;
    txt = gobjects(0);

    %while-loop
    while halfwidth > tol && n < maxN
        % batch
        x = rand(batch,1);
        y = rand(batch,1);
        in = (x.^2 + y.^2) <= 1;

        %counts
        hits = hits + sum(in);
        n    = n + batch;

        p_hat   = hits / n;
        pi_est  = 4 * p_hat;
        se      = 4 * sqrt(max(p_hat*(1-p_hat), eps) / n);
        halfwidth = z * se;

        %plotting
        if plotQuota > 0
            if any(in)
                xi = x(in); yi = y(in);
                if numel(xi) > plotQuota
                    idx = randperm(numel(xi), plotQuota);
                    xi = xi(idx); yi = yi(idx);
                end
                addpoints(hIn, xi, yi);
            end
            if any(~in)
                xo = x(~in); yo = y(~in);
                if numel(xo) > plotQuota
                    idx = randperm(numel(xo), plotQuota);
                    xo = xo(idx); yo = yo(idx);
                end
                addpoints(hOut, xo, yo);
            end
        end

       %title
        if mod(n, 10*batch) == 0 || halfwidth <= tol
            if isgraphics(txt), delete(txt); end
            msg = sprintf('n=%d | \\pi \\approx %.*g (\\pm %.3g @ %.0f%% CI)', ...
                          n, sigfigs, pi_est, halfwidth, 100*(1-alpha));
            title({'Estimating \pi via Monte Carlo (live)', msg});
            drawnow limitrate;
        end
    end

    elapsed = toc(t0);
    if halfwidth > tol
        warning('Stopped before reaching target precision (halfwidth=%.3g, tol=%.3g).', ...
                 halfwidth, tol);
    end

    %result
    pi_str = sprintf(['%.', num2str(sigfigs), 'g'], pi_est);   % to requested sig figs
    fprintf('Target sig figs  : %d (tol = %.6g)\n', sigfigs, tol);
    fprintf('Confidence level : %.1f%%\n', 100*(1-alpha));
    fprintf('Points used (n)  : %d\n', n);
    fprintf('π estimate       : %s\n', pi_str);
    fprintf('CI half-width    : %.6g\n', halfwidth);
    fprintf('Elapsed time     : %.3f s\n', elapsed);

    % label on the plot
    if isgraphics(txt), delete(txt); end
    text(0.02, 0.97, sprintf('\\pi \\approx %s', pi_str), ...
         'Units','normalized','FontWeight','bold','BackgroundColor','w');
end

[pi2, n2] = mc_pi_sigfig(2);          % 2 sig
[pi3, n3] = mc_pi_sigfig(3, 0.05);    % 3 sig
[pi4, n4] = mc_pi_sigfig(4, 0.05, 5000, 2e7); 
