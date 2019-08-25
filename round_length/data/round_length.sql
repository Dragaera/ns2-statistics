.headers on
.mode csv

SELECT
  ri.roundId     AS round_id,
  ri.roundLength AS round_length,
  'Hashtagawesome'          AS server_name,
  COUNT(1)       AS player_count,
  SUM(prs.timePlayed * prs.hiveSkill) / SUM(prs.timePlayed) AS avg_skill,
  MIN(ri.maxPlayers1, ri.maxPlayers2) AS max_players

FROM RoundInfo AS ri
JOIN PlayerRoundStats AS prs
  ON ri.roundId = prs.roundId 

WHERE ri.roundDate >= '2019-04-23'
  AND (   prs.teamNumber = 1
       OR prs.teamNumber = 2)
/*  AND ri.maxPlayers1 >= 10
  AND ri.maxPlayers2 >= 10 */


GROUP BY ri.roundId

/* HAVING player_count > 12 */
;
