# YOJEE ASSIGNMENT 

## What I did do?
- Create a RoR app (Rails v6.1.6, ruby-3.0.4)
- A simple UI to create Threads, Posts
- Showing "Top popular threads"
- Unit tests & rubocop
- Setup & deploy the app to AWS ([http://3.0.19.238/](http://3.0.19.238/))

## Required
- [Redis](https://redis.io/)
- [Elastic search](https://www.elastic.co/elasticsearch/)

## Usage
```
bundle install
```

```
rake db:create db:migrate db:seed
```

```
rails s
```
Access [http://localhost:3000](http://localhost:3000)

## Best practices
- Query object
- Feature extraction
- Factory pattern
- DRY
- KISS

## Details
#### Database Replication
Create a replica DB (or more) of the source DB to serve read-heavy workloads. It works exactly the same as [Amazon RDS Read Replicas](https://aws.amazon.com/rds/features/read-replicas/).

We can redirect `read queries` to the replica database (read-only) and `write queries` to DB master. This can lower data access latency, and improve reliability, and availability...

Related files:
- [app/models/application_record.rb](https://github.com/conficker1805/yojee-forum/blob/affa8bc9c492be9d1b5146ddcceb715a8f33e146/app/models/application_record.rb#L4)
- [config/database.yml](https://github.com/conficker1805/yojee-forum/blob/affa8bc9c492be9d1b5146ddcceb715a8f33e146/config/database.yml#L27)
- [app/controllers/topics_controller.rb](https://github.com/conficker1805/yojee-forum/blob/caa908dfe9dfb602d50c780ed81d7b322130edf5/app/controllers/topics_controller.rb#L5)

#### Table Partitioning
Since we have a lot of threads and posts which can make the query's cost so high. I have split them into small chunks:
**Table threads**: Split based on created_at, 4 quarters for each year. eg:  
- Partition **quarter_1_2022** contains records which has **created_at** in **January, February, and March** of **2022**  
- Partition **quarter_2_2022** contains records which has **created_at** in **April, May, and June** of **2022**   
- Partition **quarter_3_2022** contains records which has **created_at** in **July, August, and September** of **2022**  
- Partition **quarter_4_2022** contains records which has **created_at** in **October, November, and December** of **2022** 
- Partition **quarter_1_2023** contains records which has **created_at** in **January, February, and March** of **2023**  
...  

This can speed up queries on to created_at, for example:
- Query list of newest threads
- Categorize thread by month
- Filtering
- ...

Instead of `Seq scan` every single record, pg will do Parallel scan on the specific partition(s). The `Execution time` will be lower.
![img](https://lh5.googleusercontent.com/NFMYreVU44RY1d8DRFuQOR61ndOWDGBeRmitjFL7fhmnCtorolNkghnxjJsqsLvxq-eff4ccDtupP8ENz8u7=w3584-h2032-rw)

**Table post**: Split base on range of id. eg:  
- Partition **posts_10k** contains records which has id from **1** to **9999**
- Partition **posts_20k** contains records which has id from **10000** to **99999**
- ...  

**(\*) In the scope of an assignment, I have created these partitions by a seed file instead of generating them dynamically**

Related files:
- [db/migrate/20220604063309_bootstrap_database.rb](https://github.com/conficker1805/yojee-forum/blob/caa908dfe9dfb602d50c780ed81d7b322130edf5/db/migrate/20220604063309_bootstrap_database.rb#L9)
- [db/seeds.rb](https://github.com/conficker1805/yojee-forum/blob/caa908dfe9dfb602d50c780ed81d7b322130edf5/db/seeds.rb#L19)
- [app/models/topic.rb](https://github.com/conficker1805/yojee-forum/blob/caa908dfe9dfb602d50c780ed81d7b322130edf5/app/models/topic.rb#L9)

#### Low-level caching & Counter cache
Since `top popular threads` does not require updates too often, I have added some caching to cache popular thread in **X minutes**. It means when creating a new post, it will update the rank of thread **after X minutes** to avoid hitting the database

I also create a cache field called `posts_count` to cache the number of posts for each thread, we will figure out popular threads by this field instead of making a `GROUP BY` and `COUNT` query.

Related files:  
- [app/controllers/topics_controller.rb](https://github.com/conficker1805/yojee-forum/blob/caa908dfe9dfb602d50c780ed81d7b322130edf5/app/controllers/topics_controller.rb#L41)
- [app/models/post.rb](https://github.com/conficker1805/yojee-forum/blob/caa908dfe9dfb602d50c780ed81d7b322130edf5/app/models/post.rb#L8)

#### Elastic Search
Perform extremely fast searches by using distributed inverted indices. In this scenario, It works like a secondary database which can reduce DB connection since the feature search is one of the main features of a forum.  

Related files:  
- [app/models/concerns/searchable.rb](https://github.com/conficker1805/yojee-forum/blob/caa908dfe9dfb602d50c780ed81d7b322130edf5/app/models/concerns/searchable.rb#L1)  
- [app/controllers/topics_controller.rb](https://github.com/conficker1805/yojee-forum/blob/caa908dfe9dfb602d50c780ed81d7b322130edf5/app/controllers/topics_controller.rb#L31)
- [db/seeds.rb](https://github.com/conficker1805/yojee-forum/blob/caa908dfe9dfb602d50c780ed81d7b322130edf5/db/seeds.rb#L74)
