# ShellWork
Some shell scripts used in work
```bash
#!/bin/bash
#删除所有镜像
for i in $(docker images --format "{{.Repository}}:{{.Tag}}"); do docker rmi -f $i;  done
```
