import redis
from rediscluster import RedisCluster
import logging
import random
import ssl

# Configure logging
logging.basicConfig(level=logging.INFO)

# Redis cluster configuration
startup_nodes = [
    {"host": "localhost", "port": "7100"},
    {"host": "localhost", "port": "7101"},
    {"host": "localhost", "port": "7102"}
]
password = "E9D6ECBB-3E2A-4745-B62B-006E2F80A9A8"

# TLS configuration
tls_config = {
    'ssl': True,
    'ssl_cert_reqs': ssl.CERT_NONE  # This will ignore self-signed certificates
}

# Connect to Redis
try:
    redis_cluster = RedisCluster(startup_nodes=startup_nodes, password=password, skip_full_coverage_check=True, **tls_config)
    logging.info("Connected to Redis with TLS")
except Exception as e:
    logging.error(f"Error connecting to Redis: {e}")
    exit(1)

# Write and Read operations
try:
    # Write operation
    for i in range(5):
        key = f"key_{i}"
        value = random.randint(1, 100)
        redis_cluster.set(key, value)
        logging.info(f"Set {key} to {value}")

        # Read operation
        read_value = redis_cluster.get(key)
        assert int(read_value) == value, "Mismatch in key value"
        logging.info(f"Read {key} with value {read_value}")

    logging.info("All read/write operations completed successfully")

except Exception as e:
    logging.error(f"Error during Redis operation: {e}")

# Close the connection
redis_cluster.close()

