
-- usage: sqlite3 speeches.db < create_us_database.sql 


CREATE TABLE speeches(speech_id int, speech str);

.mode csv

.separator "|"

-- these files need to have their quotation marks removed with this command
-- sed -ie 'y/\"/\ /' < speeches_097.txt
-- this is why they are in the speeches_clean folder
-- to do: identify lines which are being dropped and manually edit
-- ref https://stackoverflow.com/questions/15212489/sqlite3-import-with-quotes
-- ref https://stackoverflow.com/questions/16154007/replace-all-double-quotes-with-single-quotes
-- ref https://stackoverflow.com/questions/2270558/sed-error-unterminated-substitute-pattern

.import speeches_clean/speeches_097.txt speeches

.import speeches_clean/speeches_098.txt speeches

.import speeches_clean/speeches_099.txt speeches

.import speeches_clean/speeches_100.txt speeches

.import speeches_clean/speeches_101.txt speeches

.import speeches_clean/speeches_102.txt speeches

.import speeches_clean/speeches_103.txt speeches

.import speeches_clean/speeches_104.txt speeches

.import speeches_clean/speeches_105.txt speeches

.import speeches_clean/speeches_106.txt speeches

.import speeches_clean/speeches_107.txt speeches

.import speeches_clean/speeches_108.txt speeches

.import speeches_clean/speeches_109.txt speeches

.import speeches_clean/speeches_110.txt speeches

.import speeches_clean/speeches_111.txt speeches

.import speeches_clean/speeches_112.txt speeches

.import speeches_clean/speeches_113.txt speeches

.import speeches_clean/speeches_114.txt speeches

-- remove the header rows 
-- ref http://sqlite.1065341.n5.nabble.com/How-do-you-load-a-quot-csv-quot-and-skip-the-first-line-td63956.html

DELETE FROM speeches WHERE speech_id = 'speech_id' ;


CREATE TABLE speakers (speakerid int, 
					speech_id int,lastname str,
					firstname str, chamber str,
					state str, gender str, 
					party str, district str,
					nonvoting str);

.mode csv

.separator "|"

.import 097_SpeakerMap.txt speakers

.import 098_SpeakerMap.txt speakers

.import 099_SpeakerMap.txt speakers

.import 100_SpeakerMap.txt speakers

.import 101_SpeakerMap.txt speakers

.import 102_SpeakerMap.txt speakers

.import 103_SpeakerMap.txt speakers

.import 104_SpeakerMap.txt speakers

.import 105_SpeakerMap.txt speakers

.import 106_SpeakerMap.txt speakers

.import 107_SpeakerMap.txt speakers

.import 108_SpeakerMap.txt speakers

.import 109_SpeakerMap.txt speakers

.import 110_SpeakerMap.txt speakers

.import 111_SpeakerMap.txt speakers

.import 112_SpeakerMap.txt speakers

.import 113_SpeakerMap.txt speakers

.import 114_SpeakerMap.txt speakers


-- remove the header rows 

DELETE FROM speakers WHERE speakerid = 'speakerid' ;


CREATE TABLE descriptions (speech_id int, 
							chamber str, 
							dateof str, 
							number_within_file str, 
							speaker str, 
							first_name str, 
							last_name str, 
							state str, 
							gender str, 
							line_start str, 
							line_end str, 
							file str, 
							char_count str, 
							word_count int); 

.mode csv

.separator "|"

.import descr_097.txt descriptions

.import descr_098.txt descriptions

.import descr_099.txt descriptions

.import descr_100.txt descriptions

.import descr_101.txt descriptions

.import descr_102.txt descriptions

.import descr_103.txt descriptions

.import descr_104.txt descriptions

.import descr_105.txt descriptions

.import descr_106.txt descriptions

.import descr_107.txt descriptions

.import descr_108.txt descriptions

.import descr_109.txt descriptions

.import descr_110.txt descriptions

.import descr_111.txt descriptions

.import descr_112.txt descriptions

.import descr_113.txt descriptions

.import descr_114.txt descriptions

-- remove the header rows 

DELETE FROM descriptions WHERE speech_id = 'speech_id' ;

