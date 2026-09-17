squared = @(x) x.^2;
squared(3)        % ans = 9
squared(1:3)      % ans = 1  4  9

addition = @(x,y) x+y;
addition(5,7)     % ans = 12

volumeBalok = @(p,l,t) p.*l.*t;   % variasi tambahan
volumeBalok(2,3,4)                % ans = 24
