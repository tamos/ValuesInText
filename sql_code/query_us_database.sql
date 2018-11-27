-- query us database for the full set of data, inner join 
-- usage: sqlite3 mydb.db < query_us_database.sql > my_desired_data_file.csv


SELECT * FROM speeches, descriptions, speakers
			WHERE speeches.speech_id=speakers.speech_id
			AND speakers.speech_id=descriptions.speech_id 
			AND descriptions.dateof > 19931231 
			AND speakers.chamber = "H"
			ORDER BY descriptions.dateof ; 