-- query us database for the full set of data, inner join 
-- usage: sqlite3 mydb.db < query_us_database.sql > my_desired_data_file.csv

-- select all columns from a table which is the result of a join between speeches, descriptions, and speakers
-- constraints: 
--	dateof column in descriptions is greater than 19931231, i.e., 1994 onward
-- 	chamber column in speakers is "H" 
-- 	sort the results by date 
SELECT * FROM speeches, descriptions, speakers
			WHERE speeches.speech_id=speakers.speech_id
			AND speakers.speech_id=descriptions.speech_id 
			AND descriptions.dateof > 19931231 
			AND speakers.chamber = "H"
			ORDER BY descriptions.dateof ; 


-- returnformat is 
-- speech_id|speech|speech_id|chamber|date|number_within_file|speaker|first_name|last_name|state|gender|line_start|line_end|file|char_count|word_count|speakerid|speech_id|lastname|firstname|chamber|state|gender|party|district|nonvoting
