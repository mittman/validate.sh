#!/bin/bash
#################
# validate.sh ###
version="1.7" ###
### mittman #####
#################

# Input files
#html=("index.html")
#css=("style.css")
#js=("app.js" "client.js")
#json=("db.json")

# Tests to run
list="jshint jsonlint csslint tidy whitespace stylish"
config="$PWD/.webapp"

checkdep() { type -p $1 &>/dev/null; }

# Color
alert="\e[1;34m"
notice="\e[1;39m"
warn="\e[1;33m"
fail="\e[1;31m"
invert="\e[7m"
reset="\e[0m"

printusage() {
  echo "USAGE: validate.sh <file> <file>"
  echo '    --config             - alt config file (default: $PWD/.webapp)'
  echo '    -c, --csslint        - run css validation'
  echo '    -j, --jshint         - run js validation'
  echo '    -o, --jsonlint       - run json validation'
  echo '    -s, --stylish        - run style validation'
  echo '    -t, --tidy           - run html validation'
  echo '    -w, --whitespace     - run whitespace validation'
  echo '    -nc, --no-csslint    - do not run css validation'
  echo '    -nj, --no-jshint     - do not run js validation'
  echo '    -no, --no-jsonlint   - do not run json validation'
  echo '    -ns, --no-stylish    - run style validation'
  echo '    -nt, --no-tidy       - run html validation'
  echo '    -nw, --no-whitespace - run whitespace validation'
  echo '    -v, --version        - print version'
  echo '    -h, --help           - outputs this message'
}

printversion() {
  echo "validate.sh -- version $version"
  echo -e "\nUtility to easily run webapp validation tests"
  echo "Copyright (c) 2016 mittman"
  echo "Dual licensed: MIT (aka X11) and GPLv2"
}

sampleconfig() {
  echo -e "\n${alert}==>${reset} ${notice}Creating $config file${reset}"
  echo 'html=("index.html" "about.html")' > $config
  echo 'css=("style.css")' >> $config
  echo 'js=("js/app.js" "server.js")' >> $config
  echo 'json=("db.json")' >> $config
  echo 'list="whitespace stylish jshint jsonlint csslint tidy"' >> $config
  cat $config 2>/dev/null
}

readmenodejs() {
  echo -e "\n${alert}==> ${notice}NOTE: nodeJS users${reset}"
  echo -e "  Add to ${fail}package.json${reset}"
  echo -e "    ${invert}  ""\"scripts""\": {${reset}"
  echo -e "    ${invert}    ""\"test""\": ""\"/path/to/validate.sh""\"${reset}"
  echo -e "    ${invert}  },${reset}"
  echo -e "${reset}  Then ${alert}\$${reset} ${warn}npm test${reset}\n"
}


run_utility() {
  if checkdep $cmd; then
    echo -e "${alert}==>${reset} ${notice}Running '${cmd}' ${what} validation${reset}"
    # filenames stored in array
    for file in ${input[@]}; do
      if [ -f "$file" ]; then
        # capture output to variable
        output=$($cmd $params "$file" 2>&1)
        if [ ! -z "$output" ]; then
          echo -e "${fail}==> FAIL${reset} $file"
          echo "$output"
          error="true"
        fi
      else
        echo -e "${warn}==> WARN${reset} Not a file: $file"
      fi
    done
  else
    echo -e "${warn}Missing ${cmd}${reset}. Skipping ${what} validation"
  fi
}

checkfiles() {
  exists="0"
  notfound="0"

  for file in "${html[@]}" "${css[@]}" "${json[@]}" "${js[@]}"; do
    if [ -f "$file" ]; then
      exists=$((exists+1))
    else
      notfound=$((notfound+1))
    fi
  done

  if [ $exists -eq 0 ]; then
    if [ $notfound -gt 0 ]; then
      echo -e "${warn}No files found${reset}"
      exit 1
    fi
  fi
}

whitespace() {
  if checkdep grep; then
    if [ -f "$1" ]; then
      # trailing spaces
      GREP_COLOR="1;30;41" grep -n --color=always " $" "$1"
      # any tab characters
      GREP_COLOR="1;30;41" grep -n --color=always $'\t' "$1"
    else
      echo -e "${warn}==> WARN${reset} Not a file: $1"
    fi
  else
    echo -e "${warn}Missing grep${reset}. Skipping ${what} validation"
  fi
}

stylish() {
  if checkdep grep; then
    if [ -f "$1" ]; then
      # compact curly brace
      GREP_COLOR="1;30;41" grep -n --color=always "){" "$1"
    else
      echo -e "${warn}==> WARN${reset} Not a file: $1"
    fi
  else
    echo -e "${warn}Missing grep${reset}. Skipping ${what} validation"
  fi
}

parse_utils() {
  for cmd in $list; do
    if [ $cmd = "tidy" ]; then
      what="HTML"
      params="-qe"
      input="${html[@]}"
      run_utility
    elif [ "$cmd" = "csslint" ]; then
      what="CSS"
      params="--quiet"
      input="${css[@]}"
      run_utility
    elif [ "$cmd" = "jsonlint" ]; then
      what="JSON"
      params="--quiet"
      input="${json[@]}"
      run_utility
    elif [ "$cmd" = "jshint" ]; then
      what="Javascript"
      params=""
      input="${js[@]}"
      run_utility
    elif [ "$cmd" = "whitespace" ]; then
      what="Whitespace"
      params=""
      input=("${html[@]}" "${css[@]}" "${json[@]}" "${js[@]}")
      run_utility
    elif [ "$cmd" = "stylish" ]; then
      what="Styling"
      params=""
      input=("${html[@]}" "${css[@]}" "${json[@]}" "${js[@]}")
      run_utility
    else
      echo -e "${fail}==> FAIL${reset} Unknown command $cmd"
    fi
  done

  if [ "$error" = "true" ]; then
    exit 1
  fi
}


# Parse parameters
if [ ! -z "$1" ]; then
  printversion
  while [[ "$1" ]]; do
    if [ "$1" = "-v" -o "$1" = "--version" ]; then
      exit 0
    elif [ "$1" = "-h" -o "$1" = "--help" ]; then
      printusage
      exit 0
    elif [ "$1" = "--config" ]; then
      config="$2"
      shift
    elif [ "$1" = "-j" -o "$1" = "--jshint" ]; then
      list="jshint"
    elif [ "$1" = "-o" -o "$1" = "--jsonlint" ]; then
      list="jsonlint"
    elif [ "$1" = "-c" -o "$1" = "--csslint" ]; then
      list="csslint"
    elif [ "$1" = "-t" -o "$1" = "--tidy" ]; then
      list="tidy"
    elif [ "$1" = "-w" -o "$1" = "--whitespace" ]; then
      list="whitespace"
    elif [ "$1" = "-s" -o "$1" = "--stylish" ]; then
      list="stylish"
    elif [ "$1" = "-nj" -o "$1" = "--nojshint" ]; then
      list="${list//jshint}"
    elif [ "$1" = "-no" -o "$1" = "--nojsonlint" ]; then
      list="${list//jsonlint}"
    elif [ "$1" = "-nc" -o "$1" = "--nocsslint" ]; then
      list="${list//csslint}"
    elif [ "$1" = "-nt" -o "$1" = "--notidy" ]; then
      list="${list//tidy}"
    elif [ "$1" = "-nw" -o "$1" = "--nowhitespace" ]; then
      list="${list//whitespace}"
    elif [ "$1" = "-ns" -o "$1" = "--nostylish" ]; then
      list="${list//stylish}"
    elif [ -f "$1" ]; then
      [[ "$1" = *.html ]] && html+=("$1") && echo -e "${alert}:: html${reset} $1"
      [[ "$1" = *.css ]] && css+=("$1") && echo -e "${alert}:: css${reset} $1"
      [[ "$1" = *.json ]] && json+=("$1") && echo -e "${alert}:: json${reset} $1"
      [[ "$1" = *.js ]] && js+=("$1") && echo -e "${alert}:: js${reset} $1"
      unset config
    elif [ -d "$1" ]; then
      echo -e "${notice}==> Skipping directory${reset} $1"
    else
      printusage
      exit 1
    fi
    shift
  done
else
  if [ ! -f "$config" ]; then
    sampleconfig
    readmenodejs
    exit 1
  fi
fi

# Load config file
if [ -f "$config" ]; then
  echo -e "${alert}==>${reset} ${notice}Parsing ($config) config file${reset}"
  source "$config"
  input=("${html[@]}" "${css[@]}" "${json[@]}" "${js[@]}")
else
  echo -e "${warn}==>${reset} ${notice}Config file ($config) not found${reset}"
fi

# Run tests
checkfiles "${input[@]}"
parse_utils

### END ###
