# AWS

## Utils

### Get all AWS IP Ranges

`curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes | .[].ip_prefix'  | awk -v FS="," '{printf "\"%s\",\n",$1,ORS}' > all-aws-ips.txt`

### Filter AWS IPs by ranges 16 to 32

`curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes | .[].ip_prefix' | grep '/16\|/17\|/18\|/19\|/20\|/21\|/22\|/23\|/24\|/25\|/26\|/27\|/28\|/29\|/30\|/31\|/32'  | awk -v FS="," '{printf "\"%s\",\n",$1,ORS}' > all-aws-ips.txt`
