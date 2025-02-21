## Automatically Generating Version Numbers

### Using File Date and Content

    MODDATE=$(date -r "$0" "+%Y-%m-%d") # get the last modified date of the file
    HASH=$(md5 -q $0 | cut -c1-5 | tr '[a-f]' '[A-F]') # get the first 5 characters of the MD5 sum

We could also use `openssl md5 -r $0` or `openssl sha256 -r $0` here. MD5 is generally faster (though less secure) than SHA256, and `md5` is available by default on macOS. You can get `openssl` via `brew install openssl`.


### Git-Based Version

    BR=$(git branch --show-current)
    DATE=$(git show -s --date='format:%y%m%d' --format='%cd')
    HASH=$(git rev-parse @ | cut -c1-4 | tr 'a-f' 'A-F')
    echo "version $DATE ($BR edition $HASH)"
>    version 240411 (main edition 1C61) 

