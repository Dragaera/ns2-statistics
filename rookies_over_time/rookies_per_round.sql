.header on
.mode csv

SELECT
  foo.roundId AS round_id,
  foo.roundDate AS timestamp,
  MAX(foo.rookie_count) AS rookie_count,
  MAX(foo.nonrookie_count) AS nonrookie_count

FROM (
  SELECT
    r.roundId,
    r.roundDate,
    pr.isRookie,
    CASE WHEN pr.isRookie = 1 THEN
      COUNT(1)
    ELSE
      0
    END AS rookie_count,
    CASE WHEN pr.isRookie = 0 THEN
      COUNT(1)
    ELSE
      0
    END AS nonrookie_count

  FROM RoundInfo AS r

  JOIN PlayerRoundStats AS pr
    ON pr.roundId = r.roundId

  WHERE r.maxPlayers1 >= 10
    AND r.maxPlayers2 >= 10
    AND r.roundDate >= '2018-01-01'

  GROUP BY r.roundId, pr.isRookie
) AS foo

GROUP BY foo.roundId
;
