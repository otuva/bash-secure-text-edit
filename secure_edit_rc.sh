secure_edit() 
{
    # edit this
    local -r FILE_PATH="${HOME}/Documents/secure_file.txt"

    # no need to edit
    local -r ENCRYPTED_FILE_PATH="${FILE_PATH}.asc"

    if ! command -v vim &> /dev/null
    then
        echo "I require 'vim' to work"
        exit

    elif ! command -v gpg &> /dev/null
    then
        echo "I require 'gpg' to work"
        exit

    elif ! command -v shred &> /dev/null
    then
        echo "I require 'shred' to work"
        exit
    else
        # encrypted file edit mode
        if [[ -f ${ENCRYPTED_FILE_PATH} ]] 
        then
            {
                gpg ${ENCRYPTED_FILE_PATH}
            } && {
                shred -u ${ENCRYPTED_FILE_PATH}
                vim ${FILE_PATH}
                {
                    gpg -c -a --no-symkey-cache ${FILE_PATH}
                } && {
                    shred -u ${FILE_PATH}
                }
            }
            
        # normal file encryption mode
        else
            {
                vim ${FILE_PATH}
                gpg -c -a --no-symkey-cache ${FILE_PATH}
            } && {
                shred -u ${FILE_PATH}
            }
        fi
    fi
}


