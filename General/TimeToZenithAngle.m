function dataOut = TimeToZenithAngle(dataIn)
%converts time to zenith angles
%The algorithm is taken from the manual for laboratory work 
%"Distribution of VLF"

JD = fix(dataIn(:,1));
t = (dataIn(:,1) - JD) .* 24;
%radio path Aldra(66.07,13.02) - Apatity(67.05,22.79) middle point
phi = 66.89;
lambda = 22.79;

M = 6.2565835805 + 1.720196995 .* 10^(-2) .* (JD - 0.5);
L = 4.88162774017 + 1.72027892929 .* 10^(-2) .* (JD - 0.5);
lambda_sum = L + 2 * 1.6725495 .* 10^(-2) .* sin(M);
delta_sum = asin(0.3977846 .* sin(lambda_sum));
eta = 9.9 .* sin(2 .* lambda_sum) - 7.7 .* sin(1.37881 + lambda_sum);
m_sum = t + eta ./ 60 + lambda ./ 15;
hi = acos(sin((pi / 180) * phi) .* sin(delta_sum) - ...
    cos((pi / 180) * phi) .* cos(delta_sum) .* cos((pi / 12) .* m_sum));
hi = hi ./ pi .* 180;

dataOut = dataIn;
dataOut(:,1) = hi;