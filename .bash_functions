mkcdir() {
    mkdir -p $1; cd $1
}

function download(){
    curl -L --fail -O $1
}

function pdfrun() {
    pdflatex $1.tex -output-directory=target && biber $1.bcf && pdflatex $1.tex -output-directory=target
}
 
function latex_clean(){

    arg=${1}
    exts=( "aux" "bbl" "blg" "brf" "idx" "ilg" "ind" "lof" "log" "lol" "lot" "out" "toc" "synctex.gz" "nav" "run.xml" "snm" "vrb" "bcf" )

    if [ -d $arg ]; then
        for ext in "${exts[@]}"; do
             rm -f $arg/*.$ext
        done
    else
        for ext in "${exts[@]}"; do
             rm -f $arg.$ext
        done
    fi
}

function searchpdf() {
    find . -iname "*.pdf" -exec pdfgrep -i $1 {} +
}

function searchAll() {
    find . -iname "*" -type f -exec grep -i $1 {} +
}

function base64dec() {
    echo "$1" | base64 -d
}

function showSize(){
    du -sk * | sort -n | awk 'BEGIN{ pref[1]="K"; pref[2]="M"; pref[3]="G";} { total = total + $1; x = $1; y = 1; while( x > 1024 ) { x = (x + 1023)/1024; y++; } printf("%g%s\t%s\n",int(x*10)/10,pref[y],$2); } END { y = 1; while( total > 1024 ) { total = (total + 1023)/1024; y++; } printf("Total: %g%s\n",int(total*10)/10,pref[y]); }'

}

function extract_old() {
    dest=".";
    if [[ -n $2 ]] ; then
        dest="$2"
    fi
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1 -C $dest        ;;
            *.tar.gz)    tar xvzf $1 -C $dest     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xvf $1        ;;
            *.tbz2)      tar xvjf $1      ;;
            *.tgz)       tar xvzf $1       ;;
            *.zip)       unzip $1 -d $dest     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1   ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

cd_func_not_used ()
{   
    local x2 the_new_dir adir index;
    local -i cnt;
    if [[ $1 == "--" ]]; then
        dirs -v;
        return 0;
    fi;
    the_new_dir=$1;
    [[ -z $1 ]] && the_new_dir=$HOME;
    if [[ ${the_new_dir:0:1} == '-' ]]; then
        index=${the_new_dir:1};
        [[ -z $index ]] && index=1;
        adir=$(dirs +$index);
        [[ -z $adir ]] && return 1;
        the_new_dir=$adir;
    fi;
    [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}";
    pushd "${the_new_dir}" > /dev/null;
    [[ $? -ne 0 ]] && return 1;
    the_new_dir=$(pwd);
    popd -n +11 2> /dev/null > /dev/null;
    for ((cnt=1; cnt <= 10; cnt++))
    do  
        x2=$(dirs +${cnt} 2>/dev/null);
        [[ $? -ne 0 ]] && return 0;
        [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}";
        if [[ "${x2}" == "${the_new_dir}" ]]; then
            popd -n +$cnt 2> /dev/null > /dev/null;
            cnt=cnt-1;
        fi;
    done;
    return 0
}

function calcu(){
    python3 -c "print($1)"
}

source ~/.tips

function hdi(){ 
    howdoi $* -c -n 5; 
};

function cda() {
    find ~ -iname $1 -type d -exec cd {} +
}

function epubToMobiAll() {
	find . -maxdepth 1 -name '*.epub' -type f -exec bash -c 'ebook-convert "$0" "${0%.epub}.mobi" --prefer-author-sort --output-profile=kindle --linearize-tables --smarten-punctuation --enable-heuristics' {} \;
}


function epubToMobi() {
	ebook-convert "$1" "${1%.epub}.mobi" --prefer-author-sort --output-profile=kindle --linearize-tables --smarten-punctuation --enable-heuristics 
}

function e() {
	evince $1 &
}

function online-check() {
	awk ' {print;} NR % 3 == 0 { print ""; }' $1 | awk 'BEGIN {RS="\n\n"; FS="\n";} {print $1 }' | awk '{print($2, $1)}' | uniq | sort
}

function unzip_all() {
    for i in *.zip;
    do
      name=$(basename $i | cut -d. -f1)
      mkdir "$name"
      unzip "$i" -d "$name"
    done
}

function cheat() {
	curl "cheat.sh/$1"
}

function jplag() {
	java -jar /home/michi/Programs/JPlag/jplag.jar -l java19 -s "$1"
}

function jplagc() {
	java -jar /home/michi/Programs/JPlag/jplag.jar -l "c/c++" -s "$1"

}

