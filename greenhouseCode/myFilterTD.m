% TDFiltered = myFilterTD(TD, us_Time)
% A background activity filter.
% For each event, this function checks whether one of the 8 (vertical and
% horizontal) neighbouring pixels has had an event within the last
% 'us_Time' microseconds. If not, the event being checked will be
% considered as noise and removed
function TDFiltered = myFilterTD (TD, varargin)
if nargin >1
    us_Time = varargin{1};
else
    us_Time = 3000;
end

if nargin >2
    rad = varargin{2};
else
    rad = 1;
end


[xMax,yMax] = findxyMaxFromTd(TD);

j = 1;
T0 = zeros(xMax,yMax)*-inf;
X_prev = 0;
Y_prev = 0;
P_prev = 0;
TDFiltered.x = zeros(size(TD.x));
TDFiltered.y = zeros(size(TD.x));
TDFiltered.p = zeros(size(TD.x));
TDFiltered.ts = zeros(size(TD.x));

nTimeSamples = length(TD.ts);
tenPercentileCheckPoints = ceil(nTimeSamples*(1:10)/10);
iCheckPoint = 1;
disp('.')
for i = 1:nTimeSamples
    if i>=tenPercentileCheckPoints(iCheckPoint)
        disp([num2str(10*iCheckPoint) '% processed.' ])
        iCheckPoint = iCheckPoint+1;
    end
    if X_prev ~= TD.x(i) || Y_prev ~= TD.y(i) || P_prev ~= TD.p(i)
        T0(TD.x(i), TD.y(i)) =  -inf;
        T0temp = T0(max((TD.x(i)-rad),1):min((TD.x(i)+rad), xMax), max((TD.y(i)-rad), 1):min((TD.y(i)+rad),yMax));
        T0temp = T0temp(:);
        [mi, loc] = min(TD.ts(i)-T0temp);
        if  mi < us_Time
            TDFiltered.x(j) = TD.x(i);
            TDFiltered.y(j) = TD.y(i);
            TDFiltered.p(j) = TD.p(i);
            TDFiltered.ts(j) = TD.ts(i);
            j = j+1;
        end
        T0(TD.x(i), TD.y(i)) =  TD.ts(i);
        X_prev = TD.x(i);
        Y_prev = TD.y(i);
        P_prev = TD.p(i);
    end
end

TDFiltered = RemoveNulls(TDFiltered, TDFiltered.x == 0);