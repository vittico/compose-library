import redis
from rediscluster import RedisCluster

def connect_to_redis_cluster():
    # Assuming 'my_redis_password' is your Redis password
    redis_password = 'E9D6ECBB-3E2A-4745-B62B-006E2F80A9A8'

    # Redis cluster startup nodes
    startup_nodes = [
        {"host": "172.25.0.3", "port": "7100"},
        {"host": "172.25.0.2", "port": "7101"},
        {"host": "172.25.0.4", "port": "7102"}
    ]

    # Creating a Redis cluster connection
    rc = RedisCluster(
        startup_nodes=startup_nodes,
        password=redis_password,
        ssl=True,
        ssl_cert_reqs=None  # This will ignore verifying the SSL certificate
    )

    return rc

def main():
    redis_cluster = connect_to_redis_cluster()

    # Testing the connection
    response = redis_cluster.set("my_key", "my_value")
    print("Set key response:", response)

    value = redis_cluster.get("my_key")
    print("Got value:", value.decode())

if __name__ == "__main__":
    main()

