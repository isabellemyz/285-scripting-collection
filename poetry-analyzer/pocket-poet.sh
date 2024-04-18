#!/bin/sh

# check args provided
# if none provided, send error message
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "
    Choose from these commands:
        mcword - most frequent word
        lcword - least frequent word
        nlines - total number of lines
        nstanzas - total number of stanzas
        wdiversity - word diversity

    Format: ./pocket-poet.sh [command] [file]
    "
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
    "nlines")
        awk '{
            if ($0 !~ /^[[:space:]]*$/) {
                tot_lines++
            }
        }       
        END {
            print "the total number of lines is: " tot_lines
        }' "$@"
        ;;
    
    "nstanzas")
        awk 'BEGIN {
                tot_stanzas=0
                in_stanza=0
            }

            {
                if ($0 !~ /^[[:space:]]*$/) { IF THE LINE HAS WORDS
                    if (!in_stanza) { 
                        tot_stanzas++
                        in_stanza = 1
                    }
                } else {
                    if (in_stanza) {
                        in_stanza = 0
                    }
                }
            }

            END {
                print "the total number of stanzas is: " tot_stanzas
            }' "$@"
        ;;
    *)
        echo "
        Choose from these commands:
            mcword - most frequent word
            lcword - least frequent word
            nlines - total number of lines
            nstanzas - total number of stanzas
            wdiversity - word diversity
        Format: ./pocket-poet.sh [command] [file]
        "
        exit 1
esac