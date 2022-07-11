# URLDecode Method #1 
# 이 방법을 사용하면 맨 끝에 %가 붙어서 따로 떼주는 방법을 사용해야 함.

_urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
urldecode() {
    local str=$(_urldecode $1 | sed "s/%//g")
    echo $str
}

# Usage: urldecode
# urldecode "%E1%84%85%E1%85%A1%E1%84%8C%E1%85%B3%E1%84%87%E1%85%A6%E1%84%85%E1%85%B5%E1%84%91%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%A6%20Mattermost%20%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%201a9ad3a2d5c246ed9b4e840ee380d0d1/Untitled.png"




# URLDecode Method #2
# 얘는 깔끔하게 만들어 줌. 맨 끝에 % 안 붙음. 그냥 얘를 쓰는 것이 나음.

rawurlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
           [-_.~a-zA-Z0-9] ) o="${c}" ;;
           * )               printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"    # You can either set a return variable (FASTER) 
    REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

# Returns a string in which the sequences with percent (%) signs followed by
# two hex digits have been replaced with literal characters.
rawurldecode() {

  # This is perhaps a risky gambit, but since all escape characters must be
  # encoded, we can replace %NN with \xNN and pass the lot to printf -b, which
  # will decode hex for us

  printf -v REPLY '%b' "${1//%/\\x}" # You can either set a return variable (FASTER)

  echo "${REPLY}"  #+or echo the result (EASIER)... or both... :p
}

# Usage: 
# rawurldecode "%AF%E1%84%8E%E1%85%B5%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%201a9ad3a2d5c246ed9b4e840ee380d0d1/Untitled.png"
# rawurlencode "라즈베리파이에 Mattermost 설치하기 1a9ad3a2d5c246ed9b4e840ee380d0d1" 
#   --> 실패


pythonEncode() {
    local string="${1}"
    abc=$(python -c "from urllib import parse; ret=parse.quote(\"$string\"); print(ret)")
    echo $abc
}

# pythonEncode "라즈베리파이에 Mattermost 설치하기 1a9ad3a2d5c246ed9b4e840ee380d0d1"

rawurldecode "%E1%84%85%E1%85%A1%E1%84%8C%E1%85%B3%E1%84%87%E1%85%A6%E1%84%85%E1%85%B5%E1%84%91%E1%85%A1%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%A6%2520Mattermost%2520%E1%84%89%E1%85%A5%E1%86%AF%E1%84%8E%E1%85%B5%E1%84%92%E1%85%A1%E1%84%80%E1%85%B5%25201a9ad3a2d5c246ed9b4e840ee380d0d1"

pythonEncode "라즈베리파이에 Mattermost 설치하기 1a9ad3a2d5c246ed9b4e840ee380d0d1"