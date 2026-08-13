# Database Selection Reference

**Load only when the change selects or changes a data store.** If the database is already chosen (existing codebase or `ARCHITECTURE.md`), respect it; do not re-evaluate or re-elect an existing store. Load this reference only for a new data-store decision or an explicit challenge to the current one.

## Decision Matrix

| Requirement                                               | Recommended                                                |
| --------------------------------------------------------- | ---------------------------------------------------------- |
| ACID transactions, complex queries, joins                 | PostgreSQL                                                 |
| Flexible schema, rapid prototyping, nested documents      | MongoDB (default)                                          |
| High-speed caching, sessions, pub/sub, sub-ms key-value   | Redis (cache only; pair with a primary DB for persistence) |
| Time-series metrics, IoT, analytics                       | TimescaleDB or InfluxDB                                    |
| Relationship traversal, recommendations, knowledge graphs | Neo4j                                                      |
| Full-text search, faceted navigation                      | Elasticsearch (secondary index) + primary DB               |
| Serverless key-value with auto-scaling                    | DynamoDB                                                   |
| File storage, blobs, CDN origin                           | S3 / Cloud Storage                                         |
| Massive write throughput, time-series at scale            | Cassandra / ScyllaDB                                       |

**PostgreSQL is the default for relational**. Choose MySQL only if the team already knows it well.

## Hard Constraints

- Never use Elasticsearch as primary data store (not ACID).
- Never use Redis for values > 1MB (performance degrades).
- Never use a time-series DB for non-time-based access patterns.
- Polyglot persistence: document WHY you need each. Every extra DB multiplies operational complexity.

## After Selection

Once a **relational store** is chosen (or re-confirmed), operational decisions follow: connection budget, access-path/index strategy, transaction behavior, volume-driven partitioning, and multitenancy isolation. Read `database-operations.md` for those; vendor-specific tuning and configuration are implementation concerns outside this architecture reference.
