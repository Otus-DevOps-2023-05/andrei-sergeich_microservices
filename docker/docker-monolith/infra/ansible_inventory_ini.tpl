[reddit]
%{ for index, ip in reddit_servers ~}
reddit_server-${index+1} ansible_host=${ip}
%{ endfor ~}
