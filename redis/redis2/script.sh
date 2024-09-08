redis-cli -a "E9D6ECBB-3E2A-4745-B62B-006E2F80A9A8" --tls --cert /usr/local/etc/redis/redis1.crt \
	--key /usr/local/etc/redis/redis1.key  \
	--cacert /usr/local/etc/redis/ca.crt  \
	--cluster create 10.255.0.5:7100 10.255.0.5:7102 10.255.0.5:7103 \
	--cluster-replicas 2 --cluster-yes

redis-cli -a "E9D6ECBB-3E2A-4745-B62B-006E2F80A9A8" --tls --cert /usr/local/etc/redis/redis1.crt \
	--key /usr/local/etc/redis/redis1.key  \
	--cacert /usr/local/etc/redis/ca.crt


redis-cli -a "E9D6ECBB-3E2A-4745-B62B-006E2F80A9A8" --tls --insecure -h 10.255.0.5:7100 \
        --cluster create 10.255.0.5:7100 10.255.0.5:7102 10.255.0.5:7103 \
        --cluster-replicas 2 --cluster-yes


redis-cli -a "E9D6ECBB-3E2A-4745-B62B-006E2F80A9A8" --tls --insecure \
        --cluster create redis1:6379 redis2:6379 redis3:6379 \
        --cluster-replicas 0 --cluster-yes


redis-cli -a "E9D6ECBB-3E2A-4745-B62B-006E2F80A9A8" --tls --insecure  \

