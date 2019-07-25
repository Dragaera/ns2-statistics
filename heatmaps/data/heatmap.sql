.header on
.mode csv

SELECT
  kf.victimPosition AS coordinates,
  ri.mapName        AS map

FROM RoundInfo AS ri
JOIN KillFeed  AS kf
  ON kf.roundId = ri.roundId

WHERE ri.mapName    = 'ns2_tram'
  AND ri.roundDate >= '2019-01-01'
;
