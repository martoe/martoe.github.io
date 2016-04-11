---
layout:   post
title:    "Title"
category: dev
tags:     CI ant blog books dell devops dojo eclipse git gradle groovy hibernate intellij java jenkins maven quality shownotes sonar spring testing
comments: true
---

On PublicAPI/MCA JBoss, the management interface doesn't work with "recursive=true":
{noformat}
GET http://localhost:19590/management/?json.pretty&recursive=true

{
    "outcome" : "failed",
    "rolled-back" : true
}{noformat}

The cause is an error when fetching a deployment's cache configuration, e.g.:
{noformat}
GET http://localhost:19590/management/deployment/push-gateway.war/subsystem/jpa/hibernate-persistence-unit/push-gateway.war%23pushgateway_params/entity-cache?json.pretty

{
    "collection" : null,
    "query-cache" : null,
    "scoped-unit-name" : "push-gateway.war#pushgateway_params",
    "entity" : {"pushgateway.utils.params.ApplicationParameterValue" : null},
    "entity-cache" : {
        "7-3858_bug.org.hibernate.cache.spi.UpdateTimestampsCache" : null,
        "7-3858_bug.ApplicationParameterValue" : null,
        "7-3858_bug.org.hibernate.cache.internal.StandardQueryCache" : null
    }
}
{noformat}
Here, the "entity-cache" entries have a wrong name, so the recursive GET causes an exception (see class org.jboss.as.jpa.hibernate4.management.HibernateStatisticsResource:  getCacheRegionNames(), getChild())

h2.Root cause (detailled explaination)

# We use Hibernate with a second-level cache.
# JBoss 7 automatically prefixes all caches with "DeploymentFileName#PersistenceUnitName" (using Hibernate's "hibernate.cache.region_prefix" property)
# Since we don't know in advance the name of the deployment-file, we have to overwrite this property in "persistence.xml":
{noformat}
<persistence-unit name="...">
  ...
  <properties>
    ...
    <property name="hibernate.cache.region_prefix" value="A_prefix_to_work_around_the_JBoss_AS7-3858_bug" />
  </properties>
</persistence-unit>
{noformat}
The value of this prefix must not be shorter than the default value because of the [JBoss AS-3858 bug|https://issues.jboss.org/browse/AS7-3858]
# Now, the management console "guesses" the names of the second level cache regions by removing the "DeploymentFileName#PersistenceUnitName" prefix  - but since we use a different prefix, this guess is wrong (and leads to wrong names, as can be seen in the second code snipped above), see [JBoss AS-4441 bug|https://issues.jboss.org/browse/AS7-4441]
# Next, the management console tries to look up the statistics of those (wrongly guessed) caches - and fails silently, since those caches don't exist

<?xml version="1.0" encoding="UTF-8"?>
<!-- Using an H2 in-memory database -->
<persistence version="2.0" xmlns="http://java.sun.com/xml/ns/persistence" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://java.sun.com/xml/ns/persistence http://java.sun.com/xml/ns/persistence/persistence_2_0.xsd">

	<persistence-unit name="pushgateway">
		<provider>org.hibernate.ejb.HibernatePersistence</provider>
		<class>pushgateway.model.AppConfig</class>
		<class>pushgateway.model.MessageStatus</class>
		<class>pushgateway.model.Subscription</class>
		<properties>
			<property name="hibernate.cache.use_second_level_cache" value="true" />
			<property name="hibernate.cache.use_query_cache" value="true" />
			<property name="hibernate.cache.region.factory_class" value="org.hibernate.cache.ehcache.EhCacheRegionFactory" />
			<property name="hibernate.cache.region_prefix" value="A_prefix_to_work_around_the_JBoss_AS7-3858_bug" />
			<property name="net.sf.ehcache.configurationResourceName" value="/pushgateway-ehcache.xml" />
			<property name="hibernate.dialect" value="org.hibernate.dialect.H2Dialect" />
			<property name="hibernate.connection.driver_class" value="org.h2.Driver" />
			<property name="hibernate.connection.url" value="jdbc:h2:mem:;MODE=Oracle" />
			<property name="hibernate.hbm2ddl.auto" value="update" />
		</properties>
	</persistence-unit>

</persistence>


<?xml version="1.0" encoding="UTF-8"?>
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="ehcache.xsd" updateCheck="false">

	<!-- default cache - unused -->
	<defaultCache
		maxElementsInMemory="1"
		timeToLiveSeconds="600" />

	<cache
		name="A_prefix_to_work_around_the_JBoss_AS7-3858_bug.AppConfig"
		maxElementsInMemory="100"
		timeToLiveSeconds="600" />

	<!-- Hibernate default query cache - unused -->
	<cache
		name="A_prefix_to_work_around_the_JBoss_AS7-3858_bug.org.hibernate.cache.internal.StandardQueryCache"
		maxElementsInMemory="1"
		timeToLiveSeconds="600" />

	<!--
	 	Hibernate default cache for invalidating cached query results.
	 	According to the docs, entries should never expire.
	 	see https://docs.jboss.org/hibernate/orm/4.0/javadocs/org/hibernate/cache/spi/UpdateTimestampsCache.html
	 	see http://stackoverflow.com/a/12526574
	-->
	<cache
		name="A_prefix_to_work_around_the_JBoss_AS7-3858_bug.org.hibernate.cache.spi.UpdateTimestampsCache"
		maxElementsInMemory="10000"
		eternal="true" />

</ehcache>
