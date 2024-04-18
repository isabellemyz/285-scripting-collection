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
    "mcword")
        awk '{
            for (i=1; i<=NF; i++) {
                words[$i]++
            }

        }
        END {
            max_count=0
            num_mcwords=0

            for (word in words) {
                if (words[word] > max_count) {
                    max_count = words[word]
                    delete mcwords
                    mcwords[word]
                } else if (words[word] == max_count) {
                    mcwords[word]
                }
            }

            for (mcword in mcwords) {
                num_mcwords++
            }

            if (num_mcwords == 1) {
                print "the most common word is: " mcword
            } else {
                printf "the least common words are: "
                first = 1
                for (mcword in mcwords) {
                    if (!first) {
                        printf ", "
                    }
                    printf "%s", mcword
                    first = 0
                }
                printf "\n"
            }

            print "the frequency is: " max_count
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
            num_lcwords = 0

            for (word in words) {
                if (words[word] < min_count) {
                    min_count = words[word]
                    delete lcwords
                    lcwords[word]
                } else if (words[word] == min_count) {
                    lcwords[word]
                }
            }

            for (lcword in lcwords) {
                num_lcwords++
            }

            if (num_lcwords == 1) {
                print "the least common word is: " lcword
            } else {
                printf "the least common words are: "
                first = 1
                for (lcword in lcwords) {
                    if (!first) {
                        printf ", "
                    }
                    printf "%s", lcword
                    first = 0
                }
                printf "\n"
            }

            print "the frequency is: " min_count

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