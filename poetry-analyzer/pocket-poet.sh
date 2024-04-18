#!/bin/sh

# check args provided
# if none provided, send error message
if { [ "$#" -lt 1 ] && [ "$#" != "help" ]; } || [ "$#" -gt 2 ]; then
    echo "
    Choose from these commands:
        mcword - most common word & frequency
        lcword - least common word & frequency
        nlines - total number of lines
        nstanzas - total number of stanzas
        wdiversity - word diversity

    Format: ./pocket-poet.sh [command] [file]
    For more notes on each command, enter the following: ./pocket-poet.sh help
    "
    exit 1
fi

# extract command
command="$1"
shift # process input

if [ "$command" == "help" ]; then
    echo "
    mcword - will return the most common word in all lower-case. will return multiple words if they are equally common.
    lcword - will return the least common word in all lower-case. will return multiple words if they are equally common.
    nlines - counts ALL lines with words, including ones for title and author if they are in the text file.
    nstanzas - counts ALL groupings, which are consecutive lines with words. will include lines for title and author if they are in text file.
    wdiversity - calculates word diversity, which is the number of unique (non-case sensitive) words divided by the total number of words.
                    higher score means more diverse, lower score means less diverse
    "

else

    # define scripts based on command
    case "$command" in
        "mcword")
            awk '{
                gsub(/[^[:alnum:]'\'' ]/, "", $0)
                for (i=1; i<=NF; i++) {
                    word = tolower($i)
                    words[word]++
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
                    printf "the most common words are: "
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
                gsub(/[^[:alnum:]'\'' ]/, "", $0)
                for (i=1; i<=NF; i++) {
                    word = tolower($i)
                    words[word]++
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
                    if ($0 !~ /^[[:space:]]*$/) {
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
        "wdiversity")
            awk '{
                gsub(/[^[:alnum:]'\'' ]/, "", $0)
                if ($0 !~ /^[[:space:]]*$/) {
                    num_total += NF
                    for (i=1; i<=NF; i++) {
                        word = tolower($i)
                        words[word]++
                    }
                }   
            }

            END {
                num_unique=0
                for (word in words) {
                    num_unique++
                }

                print "the word diversity is: " (num_unique / num_total)
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
            For more notes on each command, enter the following: ./pocket-poet.sh help
            "
            exit 1
            ;;
    esac
fi