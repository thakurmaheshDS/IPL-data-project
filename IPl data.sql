-- every season's champion

select season, winner as winner_of_final from cricketdata
where description like 'Final%' and season is not null;

--no. of matches stadium wise

select venue_name, count(venue_name) as no_of_matches from cricketdata
group by 1
order by 2 desc;

-- top 10 teams with most wins 

select winner,count(winner) as "wins" from cricketdata
where winner is not null
group by winner
order by 2 desc
limit 10;


-- most wins by any team season wise

select distinct on (season) season, winner, count(*) as wins 
from cricketdata
where season is not null
group by season,winner
order by season desc, wins desc;

--most player of the match by any player season wise 

select distinct on(season) season, pom, count(*) as times 
from cricketdata
where pom is not null and season is not null
group by season, pom
order by season desc, times desc;

--most score by any team season wise

select distinct on (season) season, winner, runs_scored 
from 
(select season, home_team, away_team, home_runs, away_runs,
case when home_runs > away_runs then home_team 
     else away_team 
     end as winner,
case when away_runs > home_runs then away_runs 
     else home_runs 
     end as runs_scored
from cricketdata
where season is not null and home_runs is not null and home_team is not null
group by season, home_team, away_team, home_runs, away_runs) as sample
order by season desc, runs_scored desc;

-----away team vs home team

select winners, count(winners) as match_won
from
(select home_team, away_team, winner,
case when home_team = winner then 'home_team' 
     else 'away_team' 
     end as winners
from cricketdata) as sample
group by winners
order by winners;

-- first inning vs second inning 

select inning, count(inning) as match_won
from
(select toss_won, decision, winner,
case when toss_won = winner and decision = 'BOWL FIRST' then 'second_inning'
     when toss_won != winner and decision = 'BOWL FIRST' then 'first_inning'
	 when toss_won = winner and decision = 'BAT FIRST' then 'first_inning'
	 when toss_won != winner and decision = 'BAT FIRST' then 'second_inning'
	 end as inning
from cricketdata) as sample
where decision is not null and inning is not null
group by inning
order by inning desc;

-- first inning vs second inning venue wise

select inning, count(inning) as match_won, venue_name
from
(select venue_name, toss_won, decision, winner,
case when toss_won = winner and decision = 'BOWL FIRST' then 'second_inning'
     when toss_won != winner and decision = 'BOWL FIRST' then 'first_inning'
	 when toss_won = winner and decision = 'BAT FIRST' then 'first_inning'
	 when toss_won != winner and decision = 'BAT FIRST' then 'second_inning'
	 end as inning
from cricketdata) as sample
where decision is not null and inning is not null
group by venue_name, inning
order by venue_name;

