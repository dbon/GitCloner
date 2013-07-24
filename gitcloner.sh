set -e
path_to_repository=$1
path_to_workspace=$2

if [ -z "$path_to_workspace" ] && [ -z "$path_to_repository" ]
then
        echo "[ERROR]: parameters not set"
        echo "run: gitcloner.sh path_to_repository path_to_workspace"
else

	for current_dir in "$path_to_repository"/*; do

		echo "processing $current_dir";
                
        if [[ -d "$current_dir" ]]
        then
        	
        	cd $current_dir;

        	codinglanguage=`basename "$current_dir"`

        	subdircount=`find . -maxdepth 1 -type f -name "HEAD"  | wc -l`

	        # check if .git folder exists
	        if [ $subdircount -eq 0 ]
	        then
	            echo "$current_dir is not a repo... going deeper."	            

	            for current_sub_dir in "$current_dir"/*; do

	            	if [[ -d "$current_sub_dir" ]]
        			then        				

        				projectname=`basename "$current_sub_dir"`
        				
        				cd "$current_sub_dir";

        				subdircount=`find . -maxdepth 1 -type f -name "HEAD" | wc -l`

        				if [ $subdircount -eq 1 ]        					
	        			then
	        				echo "$current_sub_dir"	        				
	        				git clone . ~/workspace/"$codinglanguage"/"$projectname";
	        			else
	        				echo "not a repo"
	        			fi

        			else
        				echo "[ERROR]: file is not a directory."
				        echo "File: "$current_sub_dir""
				        echo "skipping..."
        			fi
        				        	
	        	done

		         continue
	        else
	        	echo "$current_dir has git repo let's clone it"
	        	cd $current_dir;
	        fi
		else                        
	        echo "[ERROR]: file is not a directory."
	        echo "File: "$current_dir""
	        echo "skipping..."
		fi                
	done
fi