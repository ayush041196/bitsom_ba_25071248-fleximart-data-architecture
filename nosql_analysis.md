NoSQL Suitability Analysis for FlexiMart Catalog Expansion

 Section A: Limitations of the Current RDBMS (~150 words)

FlexiMart’s existing relational database model works well for structured, uniform product data, but it becomes difficult to manage once product diversity increases. A key limitation is that relational schemas require all products in the `products` table to share the same columns. This structure works for simple attributes like price and category, but breaks down when laptops require fields such as RAM and processor, while shoes require size and color. Adding new product types would require adding more columns, creating many NULL fields and causing the table to grow horizontally without meaningful data.

Schema migration is another limitation: every time FlexiMart wants to add a new product attribute category, the database schema must be altered, tested, and redeployed, slowing development.

Relational databases also struggle to store nested, flexible data such as customer reviews. Reviews often include ratings, text, timestamps, and optional media—forcing developers to create multiple related tables and JOIN operations, making queries heavier and less intuitive. Combined, these issues reduce agility and increase maintenance complexity.

---

 
Section B: How MongoDB Addresses These Needs (~150 words)

MongoDB provides a document-oriented storage model that solves flexibility and agility challenges. In MongoDB, each product is a BSON document and can contain its own unique fields. A laptop document may store RAM and processor attributes, while a shoe document may store size and color—without needing a predefined schema or table changes. This reduces schema migration effort and accelerates onboarding of new product types.

MongoDB also supports embedded documents. Product reviews, ratings, customer IDs, and timestamps can be stored inside the product document itself, providing fast retrieval without extensive JOIN logic. This structure maps naturally to real-world objects and improves query simplicity.

Additionally, MongoDB’s horizontal scalability allows FlexiMart to distribute data across multiple nodes (sharding), letting large and growing product catalogs scale without significant performance loss. This supports millions of documents and high write throughput, providing long-term flexibility as FlexiMart expands into more categories and high-volume marketplaces.

---

 Section C: Trade-offs Using MongoDB (~100 words)

While MongoDB offers flexibility, it also introduces trade-offs. First, it does not support complex transactional consistency as strongly as MySQL. For example, updating multiple related product documents atomically may require additional application logic, increasing development complexity. Second, querying and analytics across diverse document structures can be slower or require aggregation pipelines, which may be less efficient than SQL JOINs on structured tables. In addition, data duplication is common in document models, increasing storage usage and raising the risk of inconsistent updates. Teams must balance flexibility against operational discipline and tooling maturity before fully shifting to MongoDB for product catalogs.
