/*
.mode column
.headers on
*/
.mode csv
.headers on

SELECT
  'TTO' AS server,
  ri.roundId AS round_id,
  ri.roundDate AS round_date,
  CASE
    WHEN ri.winningTeam = 1 THEN 'Marines'
    WHEN ri.winningTeam = 2 THEN 'Aliens'
  END AS winning_team,
  sum(prs.hiveSkill * prs.timePlayed) / sum(prs.timePlayed) AS linear_avg_skill,
  sum(prs.timePlayed) / ri.roundLength AS avg_player_count

FROM RoundInfo AS ri

JOIN PlayerRoundStats AS prs
  ON prs.roundId = ri.roundId

WHERE ri.roundDate >= '2019-04-23' /* b327 */

GROUP BY ri.roundId
;
