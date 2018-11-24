

# format is 
# speakermap
# speakerid|speech_id|lastname|firstname|chamber|state|gender|party|district|nonvoting

# descr
# speech_id|chamber|date|number_within_file|speaker|first_name|last_name|state|gender|line_start|line_end|file|char_count|word_count

# speeches
# speech_id|speech


mkdir _tmp

# concatenate speakermap files and sort on the first column, speech id, then remove duplicates

cat *SpeakerMap.txt | sort -k2,2 -t "|"  | uniq > _concat_spkrmap

# concatenate the descr files and sort on first field, speech id , remove duplicates

cat descr* | sort  -k1,1 -t "|"  | uniq > _concat_descr

# join the files 

join -1 1 -2 2 -t "|" _concat_descr _concat_spkrmap  | sort -k1,1 -t "|" > _joined_desc_spkrmap


# place all speeches in one file 

cat speeches_* > speechall 

# sort and drop duplicates as before

sort -k1,1 -t "|" speechall | uniq > _concat_speeches


# join with the other joined file and reverse order so the field names are at the top 

join -1 1 -2 1 -t "|" _concat_speeches _joined_desc_spkrmap  |  tail -r  > us_data_full.csv

# trim the us data by date. This happens in python for canada, but here we do it because the dates are integers like 19861018

awk -F "|" 'NR ==1 {print $0} NR > 1 {if ($4 > 19931231) {print $0} } ' < us_data_full.csv > us_data_trimmed_date.csv 

# trim the us data by chamber - i.e., only house

awk -F "|" 'NR ==1 {print $0} NR > 1 {if ($3 != "S") {print $0} } ' < us_data_trimmed_date.csv > us_data_trimmed.csv 



# clean up 

rm speechall

rm _joined_desc_spkrmap

rm _concat_speeches

rm _concat_spkrmap

rm _concat_descr

rm us_data_trimmed_date.csv 

rm us_data_full.csv
