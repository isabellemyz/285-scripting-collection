#!/bin/sh

# check args provided
# if none provided, send error message
if [ "$#" -lt 1 ]; then
    echo "Choose from these commands:
        mcword - most frequent word
        lcword - least frequent word
        nlines - total number of lines
        nstanzas - total number of stanzas
        wdiversity - word diversity"
    exit 1
fi

# extract command
command="$1"
shift # process input

# define scripts based on command
case "$command" in
    # need to fix: case sensitivity, what to return when words occur at same frequency
    # need to test: punctuation
    "mcword")
        awk '{
            for (i=1; i<=NF; i++) {
                words[$i]++
            }

        }
        END {
            max_count = 0
            mcword = ""

            for (word in words) {
                if (words[word] > max_count) {
                    max_count = words[word]
                    mcword = word
                }
            }

            print "the most common word is: " mcword
        }' "$@"
        ;;
    "lcword")
        awk '{
            for (i=1; i<=NF; i++) {
                words[$i]++
            }

        }
        END {
            min_count = 99999999
            lcword = ""

            for (word in words) {
                if (words[word] < min_count) {
                    min_count = words[word]
                    lcword = word
                }
            }

            print "the least common word is: " lcword
        }' "$@"
        ;;
esac