extract() {
    local extract_dir="$( echo "$file_name" | sed "s/\.${1##*.}//g" )"
    for i in "$@" ;do
    case "$1" in
      *.tar.gz|*.tgz        ) tar xzf "$1" ;;
      *.tar.bz2|*.tbz|*.tbz2) tar xjf "$1" ;;
      *.tar.xz|*.txz        ) tar --xz --help &> /dev/null &&
                              tar --xz -xf "$1" ||
                              xzcat "$1" | tar xf - ;;
      *.tar.zma|*.tlz       ) tar --lzma --help &> /dev/null &&
                              tar --lzma -xf "$1" ||
                              lzcat "$1" | tar xf - ;;
      *.tar.lrz) lrzuntar    "$1" ;;
      *.lrz    ) lrunzip     "$1" ;;
      *.tar    ) tar xf      "$1" ;;
      *.gz     ) gunzip      "$1" ;;
      *.bz2    ) bunzip2     "$1" ;;
      *.xz     ) unxz        "$1" ;;
      *.lzma   ) unlzma      "$1" ;;
      *.Z      ) uncompress  "$1" ;;
      *.zip    ) local extract_dir="$(echo $(basename "$1") | sed "s/\.${1##*.}//g")"
                 unzip       "$1" -d $extract_dir ;;
      *.rar    ) unrar e -ad "$1" ;;
      *.7z     ) 7za x       "$1" ;;
      *.Z      ) uncompress  "$1" ;;
      *) echo "extract: '$1' cannot be extracted" 1>&2
    esac
    done
}

compress() { # compress a file or folder
    case "$1" in
        tar.bz2|.tar.bz2) tar cvjf "${2%%/}.tar.bz2" "${2%%/}/"  ;;
        tbz2|.tbz2)       tar cvjf "${2%%/}.tbz2" "${2%%/}/"     ;;
        tbz|.tbz)         tar cvjf "${2%%/}.tbz" "${2%%/}/"      ;;       
        tar.xz)           tar cvJf "${2%%/}.tar.gz" "${2%%/}/"   ;;       
        tar.gz|.tar.gz)   tar cvzf "${2%%/}.tar.gz" "${2%%/}/"   ;;
        tgz|.tgz)         tar cvjf "${2%%/}.tgz" "${2%%/}/"      ;;
        tar|.tar)         tar cvf  "${2%%/}.tar" "${2%%/}/"      ;;
        rar|.rar)         rar a "${2}.rar" "$2"                  ;;
        zip|.zip)         zip -9 "${2}.zip" "$2"                 ;;
        7z|.7z)           7z a "${2}.7z" "$2"                    ;;
        lzo|.lzo)         lzop -v "$2"                           ;;   
        gz|.gz)           gzip -v "$2"                           ;;
        bz2|.bz2)         bzip2 -v "$2"                          ;;
        xz|.xz)           xz -v "$2"                             ;; 
        lzma|.lzma)       lzma -v "$2"                           ;;  
        *)  echo "Usage: compress <archive type> <filename>"
            echo "Example: compress tar.bz2 PKGBUILD"
            echo "Please specify archive type and source."
            echo "Valid archive types are:"
            echo "tar.bz2, tar.gz, tar.gz, tar, bz2, gz, tbz2, tbz,"
            echo "tgz, lzo, rar, zip, 7z, xz and lzma."
    esac
}

list() { # list content of archive but don't unpack
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2|*.tbz2|*.tbz)  tar -jtf "$1"  ;;
            *.tar.gz)                tar -ztf "$1"  ;;
            *.tar|*.tgz|*.tar.xz)    tar -tf "$1"   ;;
            *.gz)                    gzip -l "$1"   ;;    
            *.rar)                   rar vb "$1"    ;;
            *.zip)                   unzip -l "$1"  ;;
            *.7z)                    7z l "$1"      ;;
            *.lzo)                   lzop -l "$1"   ;;  
            *.xz|*.txz|*.lzma|*.tlz) xz -l "$1"     ;;
        esac
    else
        echo "Sorry, '$1' is not a valid archive."
        echo "Valid archive types are:"
        echo "tar.bz2, tar.gz, tar.xz, tar, gz,"
        echo "tbz2, tbz, tgz, lzo, rar"
        echo "zip, 7z, xz and lzma"
    fi
}

extract_dir() {
    for FILE in $(find -type -f *); do
        extract $FILE
    done
}
