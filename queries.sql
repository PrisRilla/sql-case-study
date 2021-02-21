-- Question 1:
    -- Inner Join
SELECT Claims.claim_number, Claims.Member_ID
FROM Claims
INNER JOIN Procedures
ON Claims.procedure_code = Procedures.Procedure_Code
WHERE Claims.dos BETWEEN '2017-01-01' AND '2017-12-31'
    AND Procedures.Effective_Date BETWEEN '2017-01-01' AND '2017-12-31'
    AND Procedures.Type  = 'Minor Surgery';

    -- Subquery
SELECT claim_number, Member_ID
FROM claims
WHERE procedure_code IN ( SELECT Procedure_Code
                        FROM Procedures
                        WHERE Effective_Date BETWEEN '2017-01-01' AND '2017-12-31'
                            AND Type = 'Minor Surgery'
                        )
    AND dos BETWEEN '2017-01-01' AND '2017-12-31';


-- Question 2:
    -- Aggregation Function
SELECT procedure_code, count(claim_number) AS num_claims
FROM Claims
GROUP BY procedure_code;


-- Question3:
    -- All Claims filed within coverage period
SELECT DISTINCT Claims.claim_number AS Covered_Claims
FROM Claims, Members
WHERE Claims.Member_ID = Members.Member_ID
    AND Claims.dos BETWEEN Members.Effective_Date AND Members.Termination_Date;
 
    -- All Claims filed within coverage period, factoring in Procedure Type and Policy Type, no deductible used
SELECT DISTINCT  claim_number
FROM (SELECT tbl1.claim_number, tbl1.Member_ID, tbl1.dos, tbl1.Type, Members.Policy, Members.Effective_Date, Members.Termination_Date
    FROM (SELECT Claims.claim_number, Claims.Member_ID, Claims.dos,Procedures.procedure_code, Procedures.Type
        FROM Claims
        INNER JOIN Procedures ON Claims.procedure_code = Procedures.Procedure_Code
        ) As tbl1
    INNER JOIN Members ON tbl1.Member_ID = Members.Member_ID
    WHERE (tbl1.Type = 'Evaluation' AND Members.Policy IN ('Bronze','Silver', 'Gold', 'Platinum'))
        OR (tbl1.Type = 'Lab Test' AND Members.Policy IN ('Gold', 'Platinum'))
        OR (tbl1.Type = 'Minor Surgery' AND Members.Policy IN ('Platinum'))
    ) AS qualified_claims
WHERE dos BETWEEN Effective_Date AND Termination_Date; 


-- Question 4:
SELECT claim_number
FROM Claims
WHERE procedure_code IN (SELECT Procedure_Code
                        FROM Procedures
                        WHERE Cost > 150);


-- Question 5:
    -- Least expensive member and their cost
SELECT Member_ID, Total_Cost
FROM (SELECT *,
            dense_rank() over (ORDER BY Total_Cost ASC) as rnk
    FROM (SELECT Member_ID, SUM(Cost) AS Total_Cost
        FROM Claims, Procedures
        WHERE Claims.procedure_code = Procedures.Procedure_Code
        GROUP BY Member_ID
        )AS sum_cost
    ) AS sum_cost_ranked
WHERE rnk = 1;


    -- All members' costs 
SELECT Member_ID, SUM(Cost) AS Total_Cost
FROM Claims, Procedures
WHERE Claims.procedure_code = Procedures.Procedure_Code
GROUP BY Member_ID
ORDER BY Total_Cost ASC;