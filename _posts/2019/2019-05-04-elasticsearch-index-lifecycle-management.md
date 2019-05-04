---
layout:   post
title:    "ELK: Delete old logging data using the Index Lifecycle Management"
category: dev
tags:     elasticsearch
comments: true
---

Since Version 6.6, Elasticsearch includes a feature called [Index Lifecycle Management](https://www.elastic.co/guide/en/elasticsearch/reference/current/index-lifecycle-management.html) to implement detailed index retention policies.

In this post, I show how to use this feature for a very basic (and common) usecase:

## How to delete old logging data from an ELK stack

In the following, I assume that the Elasticsearch cluster contains data created by [Logstash](https://www.elastic.co/products/logstash) and [Filebeat](https://www.elastic.co/products/beats/filebeat), and that the Elasticsearch API is available at `http://elasticsearch:9200`. In case you have enabled authentication, just add "`-u username:password`" to the `curl` command.

#### 1. Create a policy that deletes indices after one month

{% highlight bash %}
curl -X PUT "http://elasticsearch:9200/_ilm/policy/cleanup_policy?pretty" \
     -H 'Content-Type: application/json' \
     -d '{
      "policy": {                       
        "phases": {
          "hot": {                      
            "actions": {}
          },
          "delete": {
            "min_age": "30d",           
            "actions": { "delete": {} }
          }
        }
      }
    }'
{% endhighlight %}

#### 2. Apply this policy to all existing filebeat and logstash indices

{% highlight bash %}
curl -X PUT "http://elasticsearch:9200/logstash-*/_settings?pretty" \
     -H 'Content-Type: application/json' \
     -d '{ "lifecycle.name": "cleanup_policy" }'
curl -X PUT "http://elasticsearch:9200/filebeat-*/_settings?pretty" \
     -H 'Content-Type: application/json' \
     -d '{ "lifecycle.name": "cleanup_policy" }'
{% endhighlight %}

#### 3. Create a template to apply this policy to new filebeat and logstash indices

{% highlight bash %}
curl -X PUT "http://elasticsearch:9200/_template/logging_policy_template?pretty" \
     -H 'Content-Type: application/json' \
     -d '{
      "index_patterns": ["filebeat-*", "logstash-*"],                 
      "settings": { "index.lifecycle.name": "cleanup_policy" }
    }'
{% endhighlight %}

That's it! From now on, all data that is older than 30 days will be deleted. Depending on the size of the data, this background operation can take some time.

#### A final note

If you change the policy (e.g. deleting after 60 instead of 30 days), these changes will not be applied to existing indices. The easiest way to enforce a new policy version on existing indices is to remove and re-add the policy, e.g.

{% highlight bash %}
curl -X POST "http://elasticsearch:9200/filebeat-*/_ilm/remove?pretty"
curl -X PUT "http://elasticsearch:9200/filebeat-*/_settings?pretty" \
     -H 'Content-Type: application/json' \
     -d '{ "lifecycle.name": "cleanup_policy" }'
{% endhighlight %}
