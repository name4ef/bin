#!/usr/bin/env bash

login="<set login>"
password="<set password>"

URL1="https://login.yota.ru/UI/Login"
HEADER1="Host: login.yota.ru
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:73.0) Gecko/20100101 Firefox/73.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Content-Type: application/x-www-form-urlencoded
Content-Length: 251
Origin: https://my.yota.ru
Connection: keep-alive
Referer: https://my.yota.ru/selfcare/login
Cookie: FwdLogin=10.210.148.210; JSESSIONID=AC9A4675E38048ACC86D8C39D331D2BC; _ga=GA1.2.2094843631.1584164735; _gid=GA1.2.1834150369.1584164735; YOTA_SITE_VISITED=true; INITIAL_REFERER=direct; YOTA_REGION_CODE=O_71; top100_id=t1.6977670.137812336.1584166978876; last_visit=1584149759609::1584174959609; _ym_uid=1584166979424327735; _ym_d=1584166979; tmr_reqNum=14; tmr_lvid=8454e2ab2ee99928fb3203df9c358cb0; tmr_lvidTS=1584166979243; _ym_isad=2; _fbp=fb.1.1584166983448.160621818; old_adriver_views_time=1584174965567; analytic_id=1584166984704366
Upgrade-Insecure-Requests: 1"
DATA1="IDToken1=6052172500&IDToken2=simplepass4yota&goto=https%3A%2F%2Fmy.yota.ru%3A443%2Fselfcare%2FloginSuccess&gotoOnFail=https%3A%2F%2Fmy.yota.ru%3A443%2Fselfcare%2FloginError&org=customer&ForceAuth=true&login=$login&password=$password"

iPlanetDirectoryPro=$(curl -s -G -I -H "$HEADER1" -d "$DATA1" "$URL1" \
    | grep iPlanetDirectoryPro \
    | cut -d '=' -f 2 | cut -d ';' -f 1)
if [ -z $iPlanetDirectoryPro ]; then
    echo "\$iPlanetDirectoryPro is not valid"
    exit -1
fi

# Differents in cookies:
#
#JSESSIONID='8306c3182acc7ea00fb69e4dcc55'
#last_visit='1584149759609::1584174959609'
#tmr_reqNum='14'
#old_adriver_views_time='1584174965567'
#iPlanetDirectoryPro='AQIC5wM2LY4SfcyU9f39LFjtCjtceutfojD-kdALew5FMCg.*AAJTSQACMDIAAlNLAAotNzkxNTY3MzcxAAJTMQACMDM.*'

URL2="https://my.yota.ru/selfcare/devices"
HEADER2="Host: my.yota.ru
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:73.0) Gecko/20100101 Firefox/73.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: https://my.yota.ru/selfcare/login
Connection: keep-alive
Cookie: JSESSIONID=$JSESSIONID; username=name4ef@gmail.com; FwdLogin=10.210.148.210; _ga=GA1.2.2094843631.1584164735; _gid=GA1.2.1834150369.1584164735; YOTA_SITE_VISITED=true; INITIAL_REFERER=direct; YOTA_REGION_CODE=O_71; top100_id=t1.6977670.137812336.1584166978876; last_visit=$last_visit; _ym_uid=1584166979424327735; _ym_d=1584166979; tmr_reqNum=$tmr_reqNum; tmr_lvid=8454e2ab2ee99928fb3203df9c358cb0; tmr_lvidTS=1584166979243; _ym_isad=2; _fbp=fb.1.1584166983448.160621818; old_adriver_views_time=$old_adriver_views_time; analytic_id=1584166984704366; amlbcookie=rxsso2; NSC_ttp-zpubsv-mcwtfswfs-iuuq-8080=ffffffff090a963145525d5f4f58455e445a4a4229a0; dlbcookie=rxlogin2; iPlanetDirectoryPro=$iPlanetDirectoryPro
Upgrade-Insecure-Requests: 1
Pragma: no-cache
Cache-Control: no-cache"

curl -s -H "$HEADER2" -o output.gz "$URL2"
gunzip output.gz || exit 1
VALUE=$(grep '<div class="speed"><strong>' output | grep 'бит' \
    | cut -d '>' -f 3 | cut -d '<' -f 1)
rm output

if [ -z $VALUE ]; then
    echo "Unlimited"
else
    echo $VALUE
fi
