.header on
.mode csv

SELECT
  kf.victimPosition AS coordinates,
  ri.mapName        AS map,
  CASE kf.killerTeamNumber /* ID of *killer*, so if killed by alien (id 2) then victim must be marine */
	WHEN 1 THEN 'aliens'
	WHEN 2 THEN 'marines'
	ELSE kf.killerTeamNumber
  END AS team

FROM RoundInfo AS ri
JOIN KillFeed  AS kf
  ON kf.roundId = ri.roundId

WHERE ri.mapName    = 'ns2_biodome'
  AND ri.roundDate >= '2019-03-01'
;
