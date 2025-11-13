function TorqueTransientTest(test)

%Get the logged response data for TrqAchieved 
TrqAchieved = test.sltest_simout.logsout.get('<MtrTrq>').Values.Data;
time_vector = test.sltest_simout.logsout.get('<MtrTrq>').Values.Time;

%Calculate step response characteristics
S = stepinfo(TrqAchieved, time_vector, 100);

% Verify Overshoot shall not exceed 5% of commanded value
test.verifyLessThanOrEqual(S.Overshoot,5,'Overshoot shall be less than 5%');

% Verify Settling time shall not exceed 10 ms
test.verifyLessThanOrEqual((S.SettlingTime-5),0.01,'Settling time shall not exceed 10 ms');
end